//
//  PasteboardHandler.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Cocoa

class PasteboardHandler: NSObject {
    let listerner = PasteboardListener()
    
    override init() {
        super.init()
        setupListeners()
    }
    
    private func setupListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(pasteboardShouldStopListening), name: .PasteboardShouldStopListening, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pasteboardShouldStartListening), name: .PasteboardShouldStartListening, object: nil)
    }
    
    func startListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(onPasteboardChanged), name: .PasteboardDidChange, object: nil)
        listerner.startListening()
    }
    
    func stopListening() {
        NotificationCenter.default.removeObserver(self, name: .PasteboardDidChange, object: nil)
        listerner.stopListening()
    }
    
    @objc func pasteboardShouldStopListening(_ notification: Notification) {
        stopListening()
    }
    
    @objc func pasteboardShouldStartListening(_ notification: Notification) {
        startListening()
    }
    
    @objc func onPasteboardChanged(_ notification: Notification) {
        guard let pasteboard = notification.object as? NSPasteboard,
            let items = pasteboard.pasteboardItems,
            let item = items.first?.string(forType: .string) else { return }
        
        let itemsToRemove = QueryItemsManager().queryList.map { $0.value }
        let newItem = URLGarbageRemover.removeGarbage(item, itemsToRemove: itemsToRemove)
        
        if newItem != item {
            listerner.stopListening()
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(newItem, forType: .string)
            listerner.startListening()
        }
    }
}

