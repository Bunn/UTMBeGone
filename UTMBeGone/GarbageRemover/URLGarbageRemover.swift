//
//  URLGarbageRemover.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

struct URLGarbageRemover {
    static func removeGarbage(_ value: String) -> String {

        guard var componenets = URLComponents(string: value) else {
            return value
        }

        let items =  componenets.queryItems?.filter { ($0.name.contains("utm") == false) }
        componenets.queryItems = items
        
        if let newURL = componenets.string {
            return newURL
        }
        return value
    }
}

