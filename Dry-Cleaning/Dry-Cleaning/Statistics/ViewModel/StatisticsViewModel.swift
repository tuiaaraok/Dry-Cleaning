//
//  StatisticsViewModel.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 18.09.24.
//

import Foundation

class StatisticsViewModel {
    static let shared = StatisticsViewModel()
    private let currentDate = Date()
    private let calendar = Calendar.current
    @Published var statistics: StatisticsModel?
    private init() {}
    
    func fetchData() {
        var totalEarned = ""
        var ordersLastWeek = ""
        var ordersLastMonth = ""
        var ordersLastYear = ""

        if let lastWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate) {
            ordersLastWeek = calculateTotalCost(of: filterOrders(byDateRange: lastWeekStartDate, endDate: currentDate))
        }

        if let lastMonthStartDate = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            ordersLastMonth = calculateTotalCost(of: filterOrders(byDateRange: lastMonthStartDate, endDate: currentDate))
        }

        if let lastYearStartDate = calendar.date(byAdding: .year, value: -1, to: currentDate) {
            ordersLastYear = calculateTotalCost(of: filterOrders(byDateRange: lastYearStartDate, endDate: currentDate))
        }
        
        totalEarned = calculateTotalCost(of: MenuViewModel.shared.orders.filter({ $0.isCompleted }))
        
        statistics = StatisticsModel(totalEarned: totalEarned, totalEarnedWeek: ordersLastWeek, totalEarnedMonth: ordersLastMonth, totalEarnedYear: ordersLastYear, totalOrders: "\(MenuViewModel.shared.orders.count)")
    }
    
    private func filterOrders(byDateRange startDate: Date, endDate: Date) -> [OrderModel] {
        return MenuViewModel.shared.orders.filter { $0.isCompleted && $0.date >= startDate && $0.date <= endDate }
    }
    
    private func calculateTotalCost(of orders: [OrderModel]) -> String {
        let totalCost = orders.compactMap { Double($0.cost) }.reduce(0, +)
        if Double(Int(totalCost)) == totalCost {
            return "\(Int(totalCost))$"
        } else {
            return "\(Double(totalCost))$"
        }
    }
}
