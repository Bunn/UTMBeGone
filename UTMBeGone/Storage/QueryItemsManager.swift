//
//  QueryItemsManager.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 07/09/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

@Observable
final class QueryItemsManager {
    private static let listKey = "QueryItemListKey"
    var queryList = [QueryItem]()

    var queryValues: [String] {
        queryList.map(\.value)
    }

    init() {
        restoreAll()
    }

    func createNewItem() {
        queryList.append(QueryItem())
        save()
    }

    func delete(at offsets: IndexSet) {
        queryList.remove(atOffsets: offsets)
        save()
    }

    func delete(ids: Set<QueryItem.ID>) {
        queryList.removeAll { ids.contains($0.id) }
        save()
    }

    func updateValue(for id: QueryItem.ID, newValue: String) {
        guard let index = queryList.firstIndex(where: { $0.id == id }) else { return }
        queryList[index].value = newValue
        save()
    }

    func save() {
        do {
            let encoded = try JSONEncoder().encode(queryList)
            UserDefaults.standard.set(encoded, forKey: QueryItemsManager.listKey)
        } catch {
            print("Error encoding \(error)")
        }
    }

    private func restoreAll() {
        queryList.removeAll()
        if let itemsData = UserDefaults.standard.data(forKey: QueryItemsManager.listKey) {
            do {
                let items = try JSONDecoder().decode([QueryItem].self, from: itemsData)
                queryList.append(contentsOf: items)
            } catch {
                print("Decoding error \(error)")
            }
        }

        if queryList.isEmpty {
            setupDefaultList()
        }
    }

    private func setupDefaultList() {
        let defaults = ["utm", "utm_source", "utm_media", "utm_campaign", "utm_medium", "utm_term", "utm_content"]
        for value in defaults {
            queryList.append(QueryItem(value: value))
        }
        save()
    }
}
