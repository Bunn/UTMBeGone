//
//  UTMBeGoneTests.swift
//  UTMBeGoneTests
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import XCTest
@testable import UTMBeGone

class UTMBeGoneTests: XCTestCase {
let defaultItemsToRemove = ["utm", "utm_source", "utm_media", "utm_campaign", "utm_medium", "utm_term"]
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testQueryWithoutScheme() {
        let value = "&nbsp;"
        XCTAssertEqual(URLGarbageRemover.removeGarbage(value, itemsToRemove: defaultItemsToRemove), value)
    }
    
    func testURLsWithScheme() throws {
        let values = ["https://www.gog.com/news/25th_anniversary_look_back_at_phantasmagoria?utm_medium=social&utm_source=twitter&utm_campaign=20200824_phantasmagoriaeditorial_entw&utm_term=EN" :"https://www.gog.com/news/25th_anniversary_look_back_at_phantasmagoria",
                      
                      "https://casa.sapo.pt/detalhes.aspx?UID=9fa85847-82ee-4b0c-a830-44d0b391caf4&utm_medium=email&utm_campaign=alerts&utm_source=details" : "https://casa.sapo.pt/detalhes.aspx?UID=9fa85847-82ee-4b0c-a830-44d0b391caf4",
                      
                      "https://www.reddit.com/r/politics/comments/g6wrl2/trump_suggests_injecting_disinfectant_to_treat/?utm_medium=android_app&utm_source=share" : "https://www.reddit.com/r/politics/comments/g6wrl2/trump_suggests_injecting_disinfectant_to_treat/"
        ]
        
        for (badData, goodData) in values {
            XCTAssertEqual(URLGarbageRemover.removeGarbage(badData, itemsToRemove: defaultItemsToRemove), goodData)
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
            XCTAssertEqual(URLGarbageRemover.removeGarbage(badData, itemsToRemove: defaultItemsToRemove), goodData)
        }
    }

}
