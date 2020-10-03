//
//  Order.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 3.10.2020.
//

import Foundation

class Order:Codable {
    private enum CodingKeys:String, CodingKey{
        case orderID = "orderID"
        case message = "message"
    }
    
    var orderID:String
    var message:String
    
    required init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.orderID = try container.decode(String.self, forKey: .orderID)
        self.message = try container.decode(String.self, forKey: .message)
    }
}
