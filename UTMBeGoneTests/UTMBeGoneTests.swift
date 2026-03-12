//
//  UTMBeGoneTests.swift
//  UTMBeGoneTests
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import XCTest
@testable import UTMBeGone

class QueryItemsManagerTests: XCTestCase {
    private var suiteName: String!
    private var testDefaults: UserDefaults!
    private var manager: QueryItemsManager!

    override func setUp() {
        super.setUp()
        suiteName = "QueryItemsManagerTests-\(UUID().uuidString)"
        testDefaults = UserDefaults(suiteName: suiteName)!
        manager = QueryItemsManager(userDefaults: testDefaults)
        // Clear defaults loaded by the manager so tests start empty
        manager.queryList.removeAll()
    }

    override func tearDown() {
        testDefaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testCreateNewItem() {
        manager.createNewItem()
        XCTAssertEqual(manager.queryList.count, 1)
    }

    func testDeleteAtOffsets() {
        manager.queryList = [QueryItem(value: "a"), QueryItem(value: "b"), QueryItem(value: "c")]
        manager.delete(at: IndexSet([1]))
        XCTAssertEqual(manager.queryList.map(\.value), ["a", "c"])
    }

    func testDeleteByIds() {
        let items = [QueryItem(value: "a"), QueryItem(value: "b"), QueryItem(value: "c")]
        manager.queryList = items
        manager.delete(ids: [items[0].id, items[2].id])
        XCTAssertEqual(manager.queryList.map(\.value), ["b"])
    }

    func testUpdateValue() {
        manager.queryList = [QueryItem(value: "original")]
        let id = manager.queryList[0].id
        manager.updateValue(for: id, newValue: "updated")
        XCTAssertEqual(manager.queryList[0].value, "updated")
    }

    func testUpdateValueUnknownIdDoesNothing() {
        manager.queryList = [QueryItem(value: "original")]
        manager.updateValue(for: UUID(), newValue: "changed")
        XCTAssertEqual(manager.queryList[0].value, "original")
    }

    func testQueryValues() {
        manager.queryList = [QueryItem(value: "utm"), QueryItem(value: "utm_source")]
        XCTAssertEqual(manager.queryValues, ["utm", "utm_source"])
    }

    func testSavePersistsAndRestores() {
        manager.queryList = [QueryItem(value: "persisted")]
        manager.save()

        let restoredManager = QueryItemsManager(userDefaults: testDefaults)
        XCTAssertEqual(restoredManager.queryList.map(\.value), ["persisted"])
    }

    func testEmptyListLoadsDefaults() {
        let freshManager = QueryItemsManager(userDefaults: testDefaults)
        XCTAssertFalse(freshManager.queryList.isEmpty)
        XCTAssertTrue(freshManager.queryList.contains(where: { $0.value == "utm" }))
    }
}

class UTMBeGoneTests: XCTestCase {
    let defaultItemsToRemove = ["utm", "utm_source", "utm_media", "utm_campaign", "utm_medium", "utm_term"]

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testQueryWithoutScheme() {
        let value = "&nbsp;"
        let result = URLGarbageRemover.removeGarbage(value, itemsToRemove: defaultItemsToRemove)
        XCTAssertEqual(result.cleanedString, value)
        XCTAssertEqual(result.parametersRemoved, 0)
    }

    func testURLsWithScheme() throws {
        let values = ["https://www.gog.com/news/25th_anniversary_look_back_at_phantasmagoria?utm_medium=social&utm_source=twitter&utm_campaign=20200824_phantasmagoriaeditorial_entw&utm_term=EN" :"https://www.gog.com/news/25th_anniversary_look_back_at_phantasmagoria",

                      "https://casa.sapo.pt/detalhes.aspx?UID=9fa85847-82ee-4b0c-a830-44d0b391caf4&utm_medium=email&utm_campaign=alerts&utm_source=details" : "https://casa.sapo.pt/detalhes.aspx?UID=9fa85847-82ee-4b0c-a830-44d0b391caf4",

                      "https://www.reddit.com/r/politics/comments/g6wrl2/trump_suggests_injecting_disinfectant_to_treat/?utm_medium=android_app&utm_source=share" : "https://www.reddit.com/r/politics/comments/g6wrl2/trump_suggests_injecting_disinfectant_to_treat/"
        ]

        for (badData, goodData) in values {
            let result = URLGarbageRemover.removeGarbage(badData, itemsToRemove: defaultItemsToRemove)
            XCTAssertEqual(result.cleanedString, goodData)
            XCTAssertGreaterThan(result.parametersRemoved, 0)
        }
    }

    /*
     Every browser copies the scheme with the URL.
     If the URL doesn't have scheme I'm assuming the user is copying it from another place and we should probably not change it
     */
    func testURLsWithoutScheme() throws {
        let values = [
            "www.reddit.com/r/portugal/comments/esae9x/informação_útil_para_donos_de_nintendo_switch_e/?utm_medium=android_app&utm_source=share": "www.reddit.com/r/portugal/comments/esae9x/informação_útil_para_donos_de_nintendo_switch_e/?utm_medium=android_app&utm_source=share"
        ]

        for (badData, goodData) in values {
            let result = URLGarbageRemover.removeGarbage(badData, itemsToRemove: defaultItemsToRemove)
            XCTAssertEqual(result.cleanedString, goodData)
        }
    }

    /*
     Text containing colons should not be processed as URLs.
     Only http:// and https:// URLs should be processed.
     */
    func testNonURLTextWithColons() throws {
        let values = [
            // CSS code
            "width: 50%;\nheight: 100%;": "width: 50%;\nheight: 100%;",
            "width: 50%;": "width: 50%;",

            // Text with colon after first word
            "Hello: world": "Hello: world",

            // Text with colon later in the sentence (should also not be processed)
            "Hello, your name is: John Doe": "Hello, your name is: John Doe",

            // Other common non-URL patterns with colons
            "Time: 10:30 AM": "Time: 10:30 AM",
            "Note: This is important": "Note: This is important",
            "Subject: Meeting tomorrow": "Subject: Meeting tomorrow"
        ]

        for (input, expected) in values {
            let result = URLGarbageRemover.removeGarbage(input, itemsToRemove: defaultItemsToRemove)
            XCTAssertEqual(result.cleanedString, expected, "Failed for input: \(input)")
        }
    }

    /*
     Verify that HTTP and HTTPS URLs are still processed correctly
     */
    func testHTTPAndHTTPSURLsAreProcessed() throws {
        let values = [
            "http://example.com?utm_source=test": "http://example.com",
            "https://example.com?utm_source=test": "https://example.com",
            "http://example.com?utm_source=test&id=123": "http://example.com?id=123",
            "https://example.com?id=123&utm_source=test": "https://example.com?id=123"
        ]

        for (input, expected) in values {
            let result = URLGarbageRemover.removeGarbage(input, itemsToRemove: defaultItemsToRemove)
            XCTAssertEqual(result.cleanedString, expected, "Failed for input: \(input)")
        }
    }

}
