//
//  MenuViewModel.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import Foundation

class MenuViewModel {
    static let shared = MenuViewModel()
    @Published var orders: [OrderModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchOrders { [weak self] orders in
            guard let self = self else { return }
            self.orders = orders
        }
        print(orders)
    }
}
