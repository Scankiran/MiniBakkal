//
//  Session.swift
//  MiniBakkal
//
//  Created by Said Çankıran on 3.10.2020.
//

import Foundation

//Save User Session Status.
class Session {
    
    static let run = Session()
    
    var totalPrice:Double = 0
    var cart:[Product:Int] = [:] {
        didSet {
            calculateTotalPrice()
        }
    }
    
    private func calculateTotalPrice() {
        totalPrice = 0
        let products = Array(cart.keys)
        let values = Array(cart.values)
        
        for index in 0..<products.count {
            self.totalPrice += (products[index].price * Double(values[index]))
        }
        print(totalPrice)
    }
}
