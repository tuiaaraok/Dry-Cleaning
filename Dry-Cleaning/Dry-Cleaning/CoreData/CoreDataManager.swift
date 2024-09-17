//
//  CoreDataManager.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    func saveOrder(orderModel: OrderModel) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let orderEntity = NSEntityDescription.entity(forEntityName: "Order", in: managedContext)!
        let order = NSManagedObject(entity: orderEntity, insertInto: managedContext)
        
        order.setValue(orderModel.name, forKey: "name")
        order.setValue(orderModel.photo, forKey: "photo")
        order.setValue(orderModel.weight, forKey: "weight")
        order.setValue(orderModel.cost, forKey: "cost")
        order.setValue(orderModel.date, forKey: "date")
        order.setValue(orderModel.time, forKey: "time")
        
        let materialEntity = NSEntityDescription.entity(forEntityName: "Material", in: managedContext)!
        let materialsSet = order.mutableSetValue(forKey: "materials")
        for materialModel in orderModel.materials {
            let material = NSManagedObject(entity: materialEntity, insertInto: managedContext)
            material.setValue(materialModel.name, forKey: "name")
            material.setValue(materialModel.percent, forKey: "percent")
            materialsSet.add(material)
        }
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
//    func fetchOrders() -> [Order]? {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
//        
//        do {
//            let orders = try managedContext.fetch(fetchRequest)
//            return orders as? [Order]
//
////            for order in orders {
////                let name = order.value(forKey: "name") as? String
////                let photo = order.value(forKey: "photo") as? String
////                print("Order Name: \(name ?? "No Name"), Photo: \(photo ?? "No Photo")")
////            }
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
    
    func fetchOrders() -> [OrderModel] {
        // Get the managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the "Order" entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
        
        do {
            // Fetch the results
            let fetchedOrders = try managedContext.fetch(fetchRequest)
            
            // Convert fetched orders to OrderModel
            var orderModels = [OrderModel]()
            
            for order in fetchedOrders {
                // Extract properties
                let name = order.value(forKey: "name") as? String ?? "No Name"
                let weight = order.value(forKey: "weight") as? String ?? "No Weight"
                let cost = order.value(forKey: "cost") as? String ?? "No Cost"
                let date = order.value(forKey: "date") as? String ?? "No Date"
                let time = order.value(forKey: "time") as? String ?? "No Time"
                
                // Handle photo data (if it's saved as Data in Core Data)
                var photoString = ""
                let photoData = order.value(forKey: "photo") as? NSData ?? NSData()
                
                // Extract materials (assuming it's a relationship)
                var materialModels = [MaterialModel]()
                if let materialsSet = order.value(forKey: "materials") as? Set<NSManagedObject> {
                    for material in materialsSet {
                        let materialName = material.value(forKey: "name") as? String ?? "Unknown Material"
                        let materialPercent = material.value(forKey: "percent") as? String ?? "0%"
                        let materialModel = MaterialModel(name: materialName, percent: materialPercent)
                        materialModels.append(materialModel)
                    }
                }
                
                // Create an OrderModel
                let orderModel = OrderModel(
                    photo: photoData,
                    name: name,
                    materials: materialModels,
                    weight: weight,
                    cost: cost,
                    date: date,
                    time: time
                )                
                orderModels.append(orderModel)
            }
            
            return orderModels
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
