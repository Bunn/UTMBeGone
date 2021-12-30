//
//  OpenWebsiteHelper.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 30/12/2021.
//  Copyright © 2021 Fernando Bunn. All rights reserved.
//


import Cocoa

struct OpenWebsiteHelper {
    
    static func openWebsite() {
        NSWorkspace.shared.open(URL(string: "https://github.com/Bunn/UTMBeGone")!)

    }
}
