//
//  Model.swift
//  Dog Bread Search
//
//  Created by macmini01 on 29/07/22.
//

import Foundation

struct DogImages: Codable {
    var message: [String]
}

struct DogBreads : Codable {
    let message : [String : [String]]?
    let status : String?
}
