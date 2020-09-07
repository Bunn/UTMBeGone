//
//  MenuManager.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Cocoa

class MenuManager: NSObject {
    private let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var windowController: NSWindowController?
    private var appURL: URL { Bundle.main.bundleURL }
    private var launchAtLoginEnabled: Bool {
           get {
                SharedFileList.sessionLoginItems().containsItem(appURL)
           }
           set {
               if newValue {
                   SharedFileList.sessionLoginItems().addItem(appURL)
               } else {
                   SharedFileList.sessionLoginItems().removeItem(appURL)
               }
           }
       }

    public func setupMenu() {
        let menu = NSMenu()
        
        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(MenuManager.openPreferences), keyEquivalent: "")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        let launchAtLoginItem = NSMenuItem(title: "Launch at Login ", action: #selector(MenuManager.toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.target = self
        launchAtLoginItem.state = launchAtLoginEnabled ? .on : .off
        menu.addItem(launchAtLoginItem)

        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(MenuManager.quit), keyEquivalent: "")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        let image = NSImage(named: .init("icon"))
        image?.isTemplate = true
        
        self.item.button?.image = image
        item.menu = menu
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc private func openPreferences() {
        NSApp.activate(ignoringOtherApps: true)
        let preferences = PreferencesViewController()
        if windowController == nil {
            let window = NSWindow(contentViewController: preferences)
            window.delegate = self
            windowController = NSWindowController(window: window)
        }
        windowController?.showWindow(self)
        windowController?.window?.makeKey()
    }
    
    @objc private func toggleLaunchAtLogin() {
        launchAtLoginEnabled.toggle()
        setupMenu()
    }
}

extension MenuManager: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        windowController = nil
    }
}
