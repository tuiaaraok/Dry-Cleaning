//
//  NumberTextField.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

class NumberTextField: BaseTextField, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        priceCommonnit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        priceCommonnit()
    }
    
    private func priceCommonnit() {
        self.delegate = self
        self.keyboardType = .decimalPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        textField.text = formatPrice(input: newString)
        return false
    }
    
    private func formatPrice(input: String) -> String {
        let cleanedInput = input.replacingOccurrences(of: "[^0-9.,]", with: "", options: .regularExpression)
        let normalizedInput = cleanedInput.replacingOccurrences(of: ",", with: ".")
        if normalizedInput.last == "." {
            return normalizedInput
        }
        let parts = normalizedInput.components(separatedBy: ".")
        
        var integerPart = parts.first ?? ""
        let decimalPart = parts.count > 1 ? parts.last! : ""
        
        if integerPart.count > 9 {
                integerPart = String(integerPart.prefix(9))
            }
        
        if let number = Double(integerPart) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            integerPart = formatter.string(from: NSNumber(value: number)) ?? integerPart
        }
        let formattedPrice = decimalPart.isEmpty ? integerPart : "\(integerPart).\(decimalPart.prefix(2))"
        
        return formattedPrice
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        delegate?.textFieldDidBeginEditing?(textField)
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        delegate?.textFieldDidEndEditing?(textField)
//    }
//    
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        delegate?.textFieldDidChangeSelection?(textField)
//    }
}
