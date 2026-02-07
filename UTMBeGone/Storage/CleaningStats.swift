//
//  CleaningStats.swift
//  UTMBeGone
//
//  Created by Fernando Bunn.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

@Observable
final class CleaningStats {
    private static let urlsCleanedKey = "CleaningStats_URLsCleaned"
    private static let paramsRemovedKey = "CleaningStats_ParamsRemoved"
    private static let isEnabledKey = "CleaningStats_IsEnabled"

    var urlsCleaned: Int {
        didSet { UserDefaults.standard.set(urlsCleaned, forKey: CleaningStats.urlsCleanedKey) }
    }

    var parametersRemoved: Int {
        didSet { UserDefaults.standard.set(parametersRemoved, forKey: CleaningStats.paramsRemovedKey) }
    }

    var isEnabled: Bool {
        didSet { UserDefaults.standard.set(isEnabled, forKey: CleaningStats.isEnabledKey) }
    }

    init() {
        self.urlsCleaned = UserDefaults.standard.integer(forKey: CleaningStats.urlsCleanedKey)
        self.parametersRemoved = UserDefaults.standard.integer(forKey: CleaningStats.paramsRemovedKey)

        if UserDefaults.standard.object(forKey: CleaningStats.isEnabledKey) == nil {
            self.isEnabled = true
        } else {
            self.isEnabled = UserDefaults.standard.bool(forKey: CleaningStats.isEnabledKey)
        }
    }

    func recordCleaning(parametersRemoved count: Int) {
        guard isEnabled else { return }
        urlsCleaned += 1
        parametersRemoved += count
    }

    func reset() {
        urlsCleaned = 0
        parametersRemoved = 0
    }
}
