//
//  OrderModel.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation

struct OrderModel {
    var id: UUID
    var photo: NSData
    var name: String
    var materials: [MaterialModel]
    var weight: String
    var cost: String
    var date: String
    var time: String
    var isCompleted: Bool
}

struct MaterialModel {
    var name: String
    var percent: String
}

