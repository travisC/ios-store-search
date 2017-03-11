//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Travis Cunningham on 3/9/17.
//  Copyright © 2017 Travis Cunningham. All rights reserved.
//

class SearchResult {
    var name = ""
    var artistName = ""
    
    var artworkSmallURL = ""
    var artworkLargeURL = ""
    var storeURL = ""
    var kind = ""
    var currency = ""
    var price = 0.0
    var genre = ""
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
