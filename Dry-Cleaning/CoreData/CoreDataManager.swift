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
    
    func saveOrder(orderModel: OrderModel, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { completion(false)
            return
        }
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            let orderEntity = NSEntityDescription.entity(forEntityName: "Order", in: managedContext)!
            let order = NSManagedObject(entity: orderEntity, insertInto: managedContext)
            order.setValue(orderModel.id, forKey: "id")
            order.setValue(orderModel.name, forKey: "name")
            order.setValue(orderModel.photo, forKey: "photo")
            order.setValue(orderModel.weight, forKey: "weight")
            order.setValue(orderModel.cost, forKey: "cost")
            order.setValue(orderModel.date, forKey: "date")
            order.setValue(orderModel.time, forKey: "time")
            order.setValue(orderModel.isCompleted, forKey: "isCompleted")
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
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    func fetchOrders(completion: @escaping ([OrderModel]) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion([])
            return
        }
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
            
            do {
                let fetchedOrders = try managedContext.fetch(fetchRequest)
                var orderModels = [OrderModel]()
                for order in fetchedOrders {
                    let id = order.value(forKey: "id") as? UUID ?? UUID()
                    let name = order.value(forKey: "name") as? String ?? "No Name"
                    let weight = order.value(forKey: "weight") as? String ?? "No Weight"
                    let cost = order.value(forKey: "cost") as? String ?? "No Cost"
                    let date = order.value(forKey: "date") as? Date ?? Date()
                    let time = order.value(forKey: "time") as? String ?? "No Time"
                    let isCompleted = order.value(forKey: "isCompleted") as? Bool ?? false
                    let photoData = order.value(forKey: "photo") as? NSData ?? NSData()
                    var materialModels = [MaterialModel]()
                    if let materialsSet = order.value(forKey: "materials") as? Set<NSManagedObject> {
                        for material in materialsSet {
                            let materialName = material.value(forKey: "name") as? String ?? "Unknown Material"
                            let materialPercent = material.value(forKey: "percent") as? String ?? "0"
                            let materialModel = MaterialModel(name: materialName, percent: materialPercent)
                            materialModels.append(materialModel)
                        }
                    }
                    let orderModel = OrderModel(
                        id: id,
                        photo: photoData,
                        name: name,
                        materials: materialModels,
                        weight: weight,
                        cost: cost,
                        date: date,
                        time: time,
                        isCompleted: isCompleted
                    )
                    orderModels.append(orderModel)
                }
                completion(orderModels)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion([])
            }
        }
    }
    
    func editOrderCompletionStatus(orderId: UUID, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
            fetchRequest.predicate = NSPredicate(format: "id == %@", orderId as CVarArg)
            
            do {
                let fetchedOrders = try managedContext.fetch(fetchRequest)
                if let order = fetchedOrders.first {
                    order.setValue(true, forKey: "isCompleted")
                    try managedContext.save()
                    completion(true)
                } else {
                    print("Order not found")
                    completion(false)
                }
            } catch let error as NSError {
                print("Could not fetch or save. \(error), \(error.userInfo)")
                completion(false)
            }
        }
    }
}
