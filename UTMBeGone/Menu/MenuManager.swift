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
    private static let removeItemAlertKey = "UTMBeGone.RemoveItemAlertKey"
    //Hacky way to figure it out if the user is trying to open the app if it's already running
    private var activeCounter = 0
    
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
    
    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        activeCounter += 1
        guard  activeCounter > 1 else { return }
        if item.isVisible == false {
            item.isVisible = true
        }
    }
    
    public func setupMenu() {
        let menu = NSMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuManager.applicationDidBecomeActive), name: NSApplication.didBecomeActiveNotification, object: nil)
        
        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(MenuManager.openPreferences), keyEquivalent: "")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        let launchAtLoginItem = NSMenuItem(title: "Launch at Login ", action: #selector(MenuManager.toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.target = self
        launchAtLoginItem.state = launchAtLoginEnabled ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        let removeFromMenuItem = NSMenuItem(title: "Remove from Menu ", action: #selector(MenuManager.removeFromMenu), keyEquivalent: "")
        removeFromMenuItem.target = self
        menu.addItem(removeFromMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(MenuManager.quit), keyEquivalent: "")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        let image = NSImage(named: .init("icon"))
        image?.isTemplate = true
        
        self.item.button?.image = image
        item.menu = menu
        item.behavior = .removalAllowed
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc private func removeFromMenu() {
        displayRemoveMenuItemAlertIfNecessary()
        item.isVisible = false
    }
    
    private func displayRemoveMenuItemAlertIfNecessary() {
        if UserDefaults.standard.bool(forKey: MenuManager.removeItemAlertKey) == false {
            let alert = NSAlert()
            alert.messageText = "UTMBeGone"
            alert.informativeText = "UTMBeGone will keep running in the background. If you want to see the menu icon again just double click on the application's icon in your application's folder."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Understood!")
            alert.runModal()
            UserDefaults.standard.set(true, forKey: MenuManager.removeItemAlertKey)
        }
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
