//
//  URLGarbageRemover.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

struct URLGarbageRemover {
    static func removeGarbage(_ value: String, itemsToRemove: [String]) -> String {

        guard var componenets = URLComponents(string: value) else {
            return value
        }

        componenets.queryItems = componenets.queryItems?.filter { queryItem in
            itemsToRemove.map { queryItem.name == $0 }.allSatisfy { $0 == false }
        }
        
        if let newURL = componenets.string {
            return newURL
        }
        return value
    }
}

