//
//  URLGarbageRemover.swift
//  UTMBeGone
//
//  Created by Fernando Bunn on 31/08/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation

struct CleaningResult: Equatable {
    let cleanedString: String
    let parametersRemoved: Int
}

struct URLGarbageRemover {
    static func removeGarbage(_ value: String, itemsToRemove: [String]) -> CleaningResult {

        let sanitizedString = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let url = URL(string: sanitizedString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let scheme = components.scheme,
              scheme == "http" || scheme == "https" else {
            return CleaningResult(cleanedString: value, parametersRemoved: 0)
        }

        let originalCount = components.queryItems?.count ?? 0

        components.queryItems = components.queryItems?.filter { queryItem in
            !itemsToRemove.contains(queryItem.name)
        }

        let newCount = components.queryItems?.count ?? 0
        let removed = originalCount - newCount

        if var newURL = components.string {
            if newURL.last == "?" {
                newURL.removeLast()
            }
            return CleaningResult(cleanedString: newURL, parametersRemoved: removed)
        }
        return CleaningResult(cleanedString: value, parametersRemoved: 0)
    }
}
