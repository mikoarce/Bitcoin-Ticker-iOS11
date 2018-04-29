//
//  BitcoinDataModel.swift
//  BitcoinTicker
//
//  Created by Miko Arce on 2018-04-29.
//

import Foundation

class BitcoinDataModel {
    var bidPrice: Double? = nil
    
    init(_ jsonDict: Dictionary<String, Any>) {
        self.bidPrice = jsonDict[JSONKeys.KEY_BID] as? Double
    }
}
