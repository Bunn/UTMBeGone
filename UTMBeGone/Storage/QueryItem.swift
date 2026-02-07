//
//  QueryItem.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 07/09/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

struct QueryItem: Codable, Identifiable, Equatable {
    var id = UUID()
    var creationDate = Date()
    var value: String = "utm"

    static func == (lhs: QueryItem, rhs: QueryItem) -> Bool {
        lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id, creationDate, value
    }

    init(value: String = "utm") {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(String.self, forKey: .value)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
    }
}
