//
//  OrdersViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit
import Combine

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    private let viewModel = OrdersViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private let homeButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func setupUI() {
        homeButton.backgroundColor = .white
        homeButton.frame.size = CGSize(width: 44, height: 44)
        homeButton.layer.cornerRadius = 22
        homeButton.setImage(UIImage(named: "Home"), for: .normal)
        homeButton.imageView?.contentMode = .center
        homeButton.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
        setNavigationBar(title: "My orders", button: homeButton)
    }

    func setupTableView() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        ordersTableView.register(UINib(nibName: "EmptyCompletedTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyCompletedTableViewCell")
    }
    
    func subscribe() {
        viewModel.$orders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orders in
                guard let self = self else { return }
                self.ordersTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func goToHome() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.orders.count
        } else {
            return viewModel.completedOrders.isEmpty ? 1 : viewModel.completedOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        if indexPath.section == 0 {
            cell.setupContent(order: viewModel.orders[indexPath.row])
        } else {
            if !viewModel.completedOrders.isEmpty {
                cell.setupContent(order: viewModel.completedOrders[indexPath.row])
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCompletedTableViewCell", for: indexPath) as! EmptyCompletedTableViewCell
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 0 ? UIView() : nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let headerView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = "Completed"
        titleLabel.textColor = .white.withAlphaComponent(0.5)
        titleLabel.font = .semibold(size: 18)
        titleLabel.frame = CGRect(x: 16, y: 5, width: tableView.frame.width - 32, height: 25)
        headerView.addSubview(titleLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 35 : 0
    }
    
}
