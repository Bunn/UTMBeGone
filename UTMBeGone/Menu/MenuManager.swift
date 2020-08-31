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
    
    public func setupMenu() {
        let menu = NSMenu()
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
}
