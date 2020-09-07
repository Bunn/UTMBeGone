//
//  QueryItem.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 07/09/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

class QueryItem: Codable, Equatable {
    static func == (lhs: QueryItem, rhs: QueryItem) -> Bool {
        lhs.creationDate == rhs.creationDate
    }
    
    var creationDate = Date()
    var value: String = "utm"
}

