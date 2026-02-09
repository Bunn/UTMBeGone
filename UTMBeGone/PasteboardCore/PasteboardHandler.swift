//
//  PasteboardHandler.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import AppKit

@MainActor
final class PasteboardHandler {
    private let listener = PasteboardListener()
    private let queryValuesProvider: @MainActor () -> [String]
    private let stats: CleaningStats
    private var task: Task<Void, Never>?
    private var skipNextChange = false

    init(queryValuesProvider: @escaping @MainActor () -> [String], stats: CleaningStats) {
        self.queryValuesProvider = queryValuesProvider
        self.stats = stats
    }

    func start() {
        task = Task {
            for await pasteboard in listener.changes() {
                handleChange(pasteboard)
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    private func handleChange(_ pasteboard: NSPasteboard) {
        if skipNextChange {
            skipNextChange = false
            return
        }

        guard let items = pasteboard.pasteboardItems,
              let item = items.first?.string(forType: .string) else { return }

        let itemsToRemove = queryValuesProvider()
        let result = URLGarbageRemover.removeGarbage(item, itemsToRemove: itemsToRemove)

        if result.cleanedString != item {
            stats.recordCleaning(parametersRemoved: result.parametersRemoved)
            skipNextChange = true
            pasteboard.clearContents()
            pasteboard.setString(result.cleanedString, forType: .string)
        }
    }
}
