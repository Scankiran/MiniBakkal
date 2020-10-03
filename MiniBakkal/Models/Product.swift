//
//  Product.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 3.10.2020.
//

import Foundation

/**
 {
        "id": "5f52348e919ff34aed98d349",
        "name": "Elma",
        "price": 6.99,
        "currency": "₺",
        "imageUrl": "https://desolate-shelf-18786.herokuapp.com/images/elma.png",
        "stock": 5
    }
 */

class Product: Hashable, Codable {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    private enum CodingKeys:String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case currency = "currency"
        case stock = "stock"
        case imageUrl = "imageUrl"
    }
    
    var id:String
    var name:String
    var price:Double
    var currency:String
    var stock:Int
    var imageUrl:String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Double.self, forKey: .price)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.stock = try container.decode(Int.self, forKey: .stock)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
}
