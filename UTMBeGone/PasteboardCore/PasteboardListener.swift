//
//  PasteboardListener.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import AppKit

final class PasteboardListener: Sendable {
    private let interval: TimeInterval

    init(interval: TimeInterval = 0.3) {
        self.interval = interval
    }

    func changes() -> AsyncStream<NSPasteboard> {
        let interval = self.interval
        return AsyncStream { continuation in
            let task = Task { @MainActor in
                var lastChangeCount = NSPasteboard.general.changeCount
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(interval))
                    let pasteboard = NSPasteboard.general
                    if pasteboard.changeCount != lastChangeCount {
                        lastChangeCount = pasteboard.changeCount
                        continuation.yield(pasteboard)
                    }
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
