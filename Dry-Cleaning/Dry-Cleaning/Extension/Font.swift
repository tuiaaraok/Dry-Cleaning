//
//  Font.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

extension UIFont {
    static func regular(size: CFloat) -> UIFont? {
        return UIFont(name: .regular, size: CGFloat(size))
    }
    
    static func medium(size: CFloat) -> UIFont? {
        return UIFont(name: .medium, size: CGFloat(size))
    }
    
    static func semibold(size: CFloat) -> UIFont? {
        return UIFont(name: .semibold, size: CGFloat(size))
    }
    
    static func bold(size: CFloat) -> UIFont? {
        return UIFont(name: .bold, size: CGFloat(size))
    }
}
