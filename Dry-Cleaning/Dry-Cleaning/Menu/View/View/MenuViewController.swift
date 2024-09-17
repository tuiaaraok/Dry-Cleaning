//
//  MenuViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit
import Combine

class MenuViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ordersCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    let settingsButton = UIButton(type: .custom)
    private let viewModel = MenuViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.backgroundColor = .white
        settingsButton.frame.size = CGSize(width: 44, height: 44)
        settingsButton.layer.cornerRadius = 22
        dateLabel.text = Date().dateFormat()
        settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        setNavigationBar(title: nil, button: settingsButton)
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func subscribe() {
        viewModel.$orders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orders in
                guard let self = self else { return }
                let completedOrders = orders.filter({ !$0.isCompleted })
                if completedOrders.isEmpty {
                    self.ordersCountLabel.text = "You have no warrants"
                    self.photoImageView.image = UIImage(named: "NotOrders")
                } else {
                    self.ordersCountLabel.text = "You have \(completedOrders.count) orders"
                    self.photoImageView.image = UIImage(named: "Bell")
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func openSettings() {
        let settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func clickedCreateOrder(_ sender: UIButton) {
        let createOrderVC = CreateOrderViewController(nibName: "CreateOrderViewController", bundle: nil)
        self.navigationController?.pushViewController(createOrderVC, animated: true)
    }
    
    @IBAction func clickedMyOrders(_ sender: UIButton) {
        let orderVC = OrdersViewController(nibName: "OrdersViewController", bundle: nil)
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    @IBAction func clickedStatistics(_ sender: UIButton) {
        let statisticsVC = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        self.navigationController?.pushViewController(statisticsVC, animated: true)

    }
}
