//
//  UTMBeGoneApp.swift
//  UTMBeGone
//
//  Created by Fernando Bunn.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import SwiftUI

@main
struct UTMBeGoneApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        MenuBarExtra(UserText.appName, systemImage: "scissors") {
            MenuBarView()
                .environment(appState)
        }

        Settings {
            SettingsView()
                .environment(appState)
        }
    }
}
