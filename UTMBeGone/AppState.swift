//
//  AppState.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import AppKit
import ServiceManagement

@Observable
@MainActor
final class AppState {
    private static let isStoppedKey = "IsStoppedKey"

    let queryItemsManager = QueryItemsManager()
    let cleaningStats = CleaningStats()
    private var pasteboardHandler: PasteboardHandler?

    var isStopped: Bool {
        didSet {
            UserDefaults.standard.set(isStopped, forKey: AppState.isStoppedKey)
            if isStopped {
                pasteboardHandler?.stop()
            } else {
                pasteboardHandler?.start()
            }
        }
    }

    var launchAtLogin: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set {
            do {
                if newValue {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Launch at login error: \(error)")
            }
        }
    }

    init() {
        self.isStopped = UserDefaults.standard.bool(forKey: AppState.isStoppedKey)
        let manager = queryItemsManager
        let stats = cleaningStats
        self.pasteboardHandler = PasteboardHandler(queryValuesProvider: {
            manager.queryValues
        }, stats: stats)
        if !isStopped {
            pasteboardHandler?.start()
        }
    }

    func openProjectWebsite() {
        if let url = URL(string: "https://github.com/Bunn/UTMBeGone") {
            NSWorkspace.shared.open(url)
        }
    }
}
