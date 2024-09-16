//
//  OrderModel.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation

struct OrderModel: Codable {
    var photo: String
    var name: String
    var materials: [MaterialModel]
    var weight: String
    var cost: String
    var date: String
    var time: String
}

struct MaterialModel: Codable {
    var name: String
    var percent: String
}

