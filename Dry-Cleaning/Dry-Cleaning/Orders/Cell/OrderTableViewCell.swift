//
//  OrderTableViewCell.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tickConst: NSLayoutConstraint!
    @IBOutlet weak var bgViewConst: NSLayoutConstraint!
    @IBOutlet weak var bgViewLeftConst: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    private var orderID: UUID?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.layer.borderWidth = 3
        bgView.layer.borderColor = UIColor.redBorder.cgColor
        bgView.layer.cornerRadius = 24
        photoImageView.layer.borderWidth = 2
        photoImageView.layer.borderColor = UIColor.redBorder.cgColor
        photoImageView.layer.cornerRadius = 12
        completedButton.layer.borderWidth = 2
        completedButton.layer.borderColor = UIColor.redBorder.cgColor
        completedButton.layer.cornerRadius = 18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupContent(order: OrderModel) {
        topView.backgroundColor = order.isCompleted ? .black.withAlphaComponent(0.4) : .clear
        tickConst.isActive = order.isCompleted
        bgViewConst.isActive = !order.isCompleted
        bgViewLeftConst.constant = order.isCompleted ? 45 : 24
        completedButton.isHidden = order.isCompleted
        photoImageView.image = UIImage(data: order.photo as Data)
        dateLabel.text = order.date
        timeLabel.text = order.time
        dateLabel.layer.cornerRadius = 12
        dateLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 12
        timeLabel.layer.masksToBounds = true
        topView.layer.cornerRadius = 24
        orderID = order.id
        let nameLabel = UILabel()
        nameLabel.text = order.name
        nameLabel.font = .semibold(size: 16)
        nameLabel.textColor = .redBorder
        stackView.addArrangedSubview(nameLabel)
        for material in order.materials {
            let label = UILabel()
            label.font = .semibold(size: 16)
            label.textColor = .white.withAlphaComponent(0.5)
            label.text = "\(material.name) - \(material.percent)%"
            stackView.addArrangedSubview(label)
        }
        let costLabel = UILabel()
        costLabel.font = .semibold(size: 16)
        costLabel.textColor = .white.withAlphaComponent(0.5)
        costLabel.text = "Cost: \(order.cost)$"
        stackView.addArrangedSubview(costLabel)
    }
    
    @IBAction func clickedCompletedOrder(_ sender: UIButton) {
        if let orderID = orderID {
            OrdersViewModel.shared.competedOrder(id: orderID)
        }
    }
    
    override func prepareForReuse() {
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
}
