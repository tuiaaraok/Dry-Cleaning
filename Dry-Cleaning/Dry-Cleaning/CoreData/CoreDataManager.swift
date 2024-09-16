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
    
    func saveOrder(orderModel: OrderModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
            print("Order saved successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchOrders() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
        
        do {
            let orders = try managedContext.fetch(fetchRequest)
            
            for order in orders {
                let name = order.value(forKey: "name") as? String
                let photo = order.value(forKey: "photo") as? String
                print("Order Name: \(name ?? "No Name"), Photo: \(photo ?? "No Photo")")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
