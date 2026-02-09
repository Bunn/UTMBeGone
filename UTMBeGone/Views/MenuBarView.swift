//
//  MenuBarView.swift
//  UTMBeGone
//
//  Created by Fernando Bunn.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import SwiftUI

struct MenuBarView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        @Bindable var appState = appState

        let stats = appState.cleaningStats

        if stats.isEnabled {
            Text(UserText.urlsCleaned(stats.urlsCleaned))
            Text(UserText.parametersRemoved(stats.parametersRemoved))

            Divider()
        }

        Button(UserText.preferences) {
            openSettings()
            NSApp.activate(ignoringOtherApps: true)
        }
        .keyboardShortcut(",", modifiers: .command)

        Divider()

        Button(appState.isStopped ? UserText.resume : UserText.stop) {
            appState.isStopped.toggle()
        }

        Toggle(UserText.launchAtLogin, isOn: $appState.launchAtLogin)

        Divider()

        Button(UserText.projectWebsite) {
            appState.openProjectWebsite()
        }

        Divider()

        Button(UserText.quitApp) {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: .command)
    }
}
