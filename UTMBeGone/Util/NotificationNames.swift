//
//  NotificationNames.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 12/09/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation


extension NSNotification.Name {
    public static let PasteboardDidChange = NSNotification.Name("pasteboardDidChangeNotification")
    public static let PasteboardShouldStopListening = NSNotification.Name("pasteboardShouldStopListening")
    public static let PasteboardShouldStartListening = NSNotification.Name("pasteboardShouldStartListening")
}
