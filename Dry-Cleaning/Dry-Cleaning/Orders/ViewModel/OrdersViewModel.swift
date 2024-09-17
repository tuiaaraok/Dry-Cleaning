//
//  OrdersViewModel.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation

class OrdersViewModel {
    static let shared = OrdersViewModel()
    @Published var orders: [OrderModel] = []
    @Published var completedOrders: [OrderModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchOrders(completion: { [weak self] orders in
            guard let self = self else { return }
            self.completedOrders = orders.filter({ $0.isCompleted })
            self.orders = orders.filter({ !$0.isCompleted })
        })
    }
    
    
    
    func competedOrder(id: UUID) {
        DispatchQueue.main.async {
            if let completedOrder = self.orders.first(where: { $0.isCompleted }) {
                self.completedOrders.append(completedOrder)
                self.orders.removeAll(where: { $0.id == id })
            }
        }
    
        CoreDataManager.shared.editOrderCompletionStatus(orderId: id) { [weak self] success in
            guard let self = self, success else { return }
            self.fetchData()
        }
    }
}
