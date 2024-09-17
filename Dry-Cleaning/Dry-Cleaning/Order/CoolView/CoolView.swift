//
//  CoolView.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

class CoolView: UIView {
    var completion: (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib() -> CoolView {
        return UINib(nibName: "CoolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CoolView
    }
    
    @IBAction func clickedCool(_ sender: UIButton) {
        self.removeFromSuperview()
        completion?()
    }
}
