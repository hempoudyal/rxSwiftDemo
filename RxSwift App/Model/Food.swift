//
//  Food.swift
//  RxSwift App
//
//  Created by Hem Poudyal on 30.08.21.
//

import Foundation

struct Food {
    let name: String
    let image: String
    let price: Double
    let favorite: Bool
    
    init(name: String, image: String, price: Double, favorite: Bool){
        self.name = name
        self.image = image
        self.price = price
        self.favorite = favorite
    }
}
