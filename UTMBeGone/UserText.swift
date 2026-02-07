//
//  UserText.swift
//  UTMBeGone
//
//  Created by Fernando Bunn.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

enum UserText {
    static let appName = "UTMBeGone"

    // Menu bar
    static let preferences = "Preferences..."
    static let resume = "Resume"
    static let stop = "Stop"
    static let launchAtLogin = "Launch at Login"
    static let projectWebsite = "Project Website"
    static let quitApp = "Quit UTMBeGone"

    static func urlsCleaned(_ count: Int) -> String {
        "\(count) URLs cleaned"
    }

    static func parametersRemoved(_ count: Int) -> String {
        "\(count) parameters removed"
    }

    // Settings
    static let queryParametersHeader = "Query parameters to remove:"
    static let parameterPlaceholder = "Parameter"
    static let enableStats = "Enable Statistics"
    static let resetStats = "Reset Statistics"
}
