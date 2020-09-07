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
    
    func startListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(onPasteboardChanged), name: .NSPasteboardDidChange, object: nil)
        listerner.startListening()
    }
    
    func stopListening() {
        NotificationCenter.default.removeObserver(self, name: .NSPasteboardDidChange, object: nil)
        listerner.stopListening()
    }
    
    @objc
    func onPasteboardChanged(_ notification: Notification) {
        guard let pasteboard = notification.object as? NSPasteboard,
        let items = pasteboard.pasteboardItems,
        let item = items.first?.string(forType: .string) else { return }
        
        let itemsToRemove = QueryItemsManager().queryList.map { $0.value }
        print("Removing items \(itemsToRemove)")
        let newItem = URLGarbageRemover.removeGarbage(item, itemsToRemove: itemsToRemove)
        
        if newItem != item {
            listerner.stopListening()
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.writeObjects([newItem as NSPasteboardWriting])
            listerner.startListening()
        }
    }
}

