//
//  EmptyCompletedTableViewCell.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

class EmptyCompletedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
