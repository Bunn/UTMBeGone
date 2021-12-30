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
    private static let stoppedKey = "UTMBeGone.Stopped"
    
    //Hacky way to figure it out if the user is trying to open the app if it's already running
    private var activeCounter = 0
    
    private var launchAtLoginEnabled: Bool {
        get {
            LaunchAtLoginHelper().checkEnabled()
        }
        set {
            LaunchAtLoginHelper().setEnabled(newValue)
        }
    }
    
    private var stopped: Bool {
        get {
            UserDefaults.standard.bool(forKey: MenuManager.stoppedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: MenuManager.stoppedKey)
            if newValue {
                NotificationCenter.default.post(name: .PasteboardShouldStopListening, object: nil)
            } else {
                NotificationCenter.default.post(name: .PasteboardShouldStartListening, object: nil)
            }
            setupMenu()
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
                
        if stopped {
            let resumeMenuItem = NSMenuItem(title: "Resume ", action: #selector(MenuManager.resume), keyEquivalent: "")
            resumeMenuItem.target = self
            menu.addItem(resumeMenuItem)
        } else {
            let stopMenuItem = NSMenuItem(title: "Stop ", action: #selector(MenuManager.stop), keyEquivalent: "")
            stopMenuItem.target = self
            menu.addItem(stopMenuItem)
        }
        
        let launchAtLoginItem = NSMenuItem(title: "Launch at Login ", action: #selector(MenuManager.toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.target = self
        launchAtLoginItem.state = launchAtLoginEnabled ? .on : .off
        menu.addItem(launchAtLoginItem)

        let removeFromMenuItem = NSMenuItem(title: "Hide Icon ", action: #selector(MenuManager.removeFromMenu), keyEquivalent: "")
        removeFromMenuItem.target = self
        menu.addItem(removeFromMenuItem)
        
        let websiteItem = NSMenuItem(title: "Project Website", action: #selector(MenuManager.openProjectWebsite), keyEquivalent: "")
        websiteItem.target = self
        menu.addItem(websiteItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(MenuManager.quit), keyEquivalent: "")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        let image = NSImage(named: .init("icon"))
        image?.isTemplate = true
        
        self.item.button?.image = image
        item.menu = menu
        item.behavior = .removalAllowed
    }
    
    private func displayRemoveMenuItemAlertIfNecessary() {
        if UserDefaults.standard.bool(forKey: MenuManager.removeItemAlertKey) == false {
            let alert = NSAlert()
            alert.messageText = "UTMBeGone is not gone 😉"
            alert.informativeText = "UTMBeGone will keep running in the background. If you wish to see the menu icon again, just double click on the application's icon in your application's folder."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Understood!")
            alert.runModal()
            UserDefaults.standard.set(true, forKey: MenuManager.removeItemAlertKey)
        }
    }
}


//MARK: - Menu Actions

extension MenuManager {
    
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
    
    @objc private func openProjectWebsite() {
        OpenWebsiteHelper.openWebsite()
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(self)
    }
    
    @objc private func removeFromMenu() {
        displayRemoveMenuItemAlertIfNecessary()
        item.isVisible = false
    }
    
    @objc private func stop() {
        stopped = true
    }
    
    @objc private func resume() {
        stopped = false
    }
}


//MARK: - Window Delegate

extension MenuManager: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        windowController = nil
    }
}
