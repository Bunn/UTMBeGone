//
//  AppDelegate.swift
//  UTMBeGoneHelper
//
//  Created by Fernando Bunn on 27/12/2021.
//  Copyright © 2021 Fernando Bunn. All rights reserved.
//

import Cocoa
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let log = OSLog(subsystem: "bunn.dev.UTMBeGoneHelper", category: String(describing: AppDelegate.self))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let config = NSWorkspace.OpenConfiguration()
        config.activates = false
        config.addsToRecentItems = false
        config.promptsUserIfNeeded = false
        
        NSWorkspace.shared.openApplication(
            at: Bundle.main.mainAppBundleURL,
            configuration: config) { _, error in
                if let error = error {
                    os_log("Failed to launch main app: %{public}@", log: self.log, type: .fault, String(describing: error))
                } else {
                    os_log("Main app launched successfully", log: self.log, type: .info)
                }
                
                DispatchQueue.main.async { NSApp?.terminate(nil) }
            }
    }

}

