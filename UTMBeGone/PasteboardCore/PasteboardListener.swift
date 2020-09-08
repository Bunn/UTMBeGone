//
//  PasteboardListener.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Cocoa

class PasteboardListener: NSObject {
    var changeCount: Int = 0
    var timer: Timer!
    
    func startListening() {
        let pasteboard: NSPasteboard = .general
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            if self.changeCount != pasteboard.changeCount {
                self.changeCount = pasteboard.changeCount
                NotificationCenter.default.post(name: .NSPasteboardDidChange, object: pasteboard)
            }
        }
    }
    
    func stopListening() {
        timer.invalidate()
    }
}

extension NSNotification.Name {
    public static let NSPasteboardDidChange: NSNotification.Name = .init(rawValue: "pasteboardDidChangeNotification")
}
