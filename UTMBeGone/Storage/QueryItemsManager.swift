//
//  QueryItemsManager.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 07/09/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation


class QueryItemsManager {
    private static let listKey = "QueryItemListKey"
    private(set) var queryList = [QueryItem]()
    
    init() {
        restoreAll()
    }
    
    var numberOfItems: Int {
        queryList.count
    }
    
    func item(for index: Int) -> QueryItem {
        queryList[index]
    }
    
    func delete(_ item: QueryItem) {
        guard let itemIndex = queryList.firstIndex(of: item) else { return }
        queryList.remove(at: itemIndex)
        save()
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
        
        if queryList.count == 0 {
            setupDefaultList()
            save()
        }
    }
    
    func createNewItem() -> QueryItem {
        let item =  QueryItem()
        queryList.append(item)
        return item
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        do {
        let encoded = try jsonEncoder.encode(queryList)
        UserDefaults.standard.set(encoded, forKey: QueryItemsManager.listKey)
        } catch {
            print("Error encoding \(error)")
        }
    }
    
    private func setupDefaultList() {
        _ = createNewItem().value = "utm"
        _ = createNewItem().value = "utm_source"
        _ = createNewItem().value = "utm_media"
        _ = createNewItem().value = "utm_campaign"
        _ = createNewItem().value = "utm_medium"
        _ = createNewItem().value = "utm_term"
        _ = createNewItem().value = "utm_content"
    }
}
