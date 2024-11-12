//
//  StatisticsViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit
import Combine

class StatisticsViewController: UIViewController {
    @IBOutlet var labelsArray: [UILabel]!
    @IBOutlet weak var totalOrderLabel: UILabel!
    private let homeButton = UIButton(type: .custom)
    private let viewModel = StatisticsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }

    func setupUI() {
        homeButton.backgroundColor = .white
        homeButton.frame.size = CGSize(width: 44, height: 44)
        homeButton.layer.cornerRadius = 22
        homeButton.setImage(UIImage(named: "Home"), for: .normal)
        homeButton.imageView?.contentMode = .center
        homeButton.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
        setNavigationBar(title: "Statistics", button: homeButton)
        labelsArray.forEach { label in
            label.layer.borderWidth = 3
            label.layer.borderColor = UIColor.redBorder.cgColor
            label.layer.cornerRadius = 24
            label.layer.masksToBounds = true
            label.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 0.150196606)
        }
        totalOrderLabel.layer.borderWidth = 3
        totalOrderLabel.layer.borderColor = UIColor.redBorder.cgColor
        totalOrderLabel.layer.cornerRadius = 24
        totalOrderLabel.layer.masksToBounds = true
        totalOrderLabel.backgroundColor = .redBorder.withAlphaComponent(0.15)
    }
    
    func subscribe() {
        viewModel.$statistics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] statistics in
                guard let self = self else { return }
                self.labelsArray[0].text = statistics?.totalEarned
                self.labelsArray[1].text = statistics?.totalEarnedWeek
                self.labelsArray[2].text = statistics?.totalEarnedMonth
                self.labelsArray[3].text = statistics?.totalEarnedYear
                self.totalOrderLabel.text = statistics?.totalOrders
            }
            .store(in: &cancellables)
    }

    @objc func goToHome() {
        self.navigationController?.popViewController(animated: true)
    }
}
