//
//  AppDelegate.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let pasteboardHandler = PasteboardHandler()
    let menu = MenuManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
        pasteboardHandler.startListening()
        menu.setupMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        pasteboardHandler.stopListening()
    }
}
