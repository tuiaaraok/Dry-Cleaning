//
//  OrderViewModel.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation

class OrderViewModel {
    static let shared = OrderViewModel()
    private init() {}
    var order: OrderModel?
    @Published var isValid = false
    var name: String?
    var photo: NSData?
    @Published var materials: [MaterialModel] = [MaterialModel(name: "", percent: "")]
    var weight: String?
    var cost: String?
    var date: Date?
    var time: String?
    var previousClassesCount: Int = 0

    func setName(name: String?) {
        self.name = name
        checkValidation()
    }
    
    func setPhoto(data: NSData?) {
        self.photo = data
        checkValidation()
    }
    
    func setWeight(weight: String?) {
        self.weight = weight
        checkValidation()
    }
    
    func setCost(cost: String?) {
        self.cost = cost
        checkValidation()
    }
    
    func setMaterialName(name: String, _at index: Int) {
        materials[index].name = name
    }
    
    func setMaterialPercent(percent: String, _at index: Int) {
        materials[index].percent = percent
    }
    
    func setDate(date: Date?) {
        self.date = date
        checkValidation()
    }
    
    func setTime(time: String?) {
        self.time = time
        checkValidation()
    }
    
    func addMaterial() {
        materials.append(MaterialModel(name: "", percent: ""))
    }
    
    func checkValidation() {
        self.isValid = (!(name?.isEmpty ?? true) && photo != nil && !(materials.contains(where: { $0.name.isEmpty || $0.percent.isEmpty })) && !(weight?.isEmpty ?? true) && !(cost?.isEmpty ?? true) && (date != nil) && !(time?.isEmpty ?? true))
    }
    
    func createOrder(completion: @escaping (Bool) -> Void) {
        guard let name = name, let photo = photo, let cost = cost, let weight = weight, let date = date, let time = time else { completion(false)
            return
        }
        let orderModel = OrderModel(id: UUID(), photo: photo, name: name, materials: materials, weight: weight, cost: cost, date: date, time: time, isCompleted: false)
        CoreDataManager.shared.saveOrder(orderModel: orderModel, completion: { success in
            completion(success)
        })
    }
    
    func clear() {
        isValid = false
        name = nil
        photo = nil
        materials = [MaterialModel(name: "", percent: "")]
        weight = nil
        cost = nil
        date = nil
        time = nil
        previousClassesCount = 0
    }
}
