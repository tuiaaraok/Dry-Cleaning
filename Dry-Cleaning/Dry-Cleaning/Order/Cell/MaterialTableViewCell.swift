//
//  MaterialTableViewCell.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit

class MaterialTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var percentTextField: BaseTextField!
    private var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.delegate = self
        percentTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        nameTextField.text = nil
        percentTextField.text = nil
    }
    
    func setupData(material: MaterialModel, index: Int) {
        nameTextField.text = material.name
        let percent = material.percent.isEmpty ? "" : material.percent + " %"
        percentTextField.text = percent
        self.index = index
    }
}

extension MaterialTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        switch textField {
        case nameTextField:
            OrderViewModel.shared.setMaterialName(name: value, _at: index)
        case percentTextField:
            OrderViewModel.shared.setMaterialPercent(percent: value, _at: index)
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == percentTextField, let text = textField.text else { return true }
        
        let currentText = textField.text ?? ""
        let str = string == "," ? "." : string
        var newString = (currentText as NSString).replacingCharacters(in: range, with: str)
        if string.isEmpty {
            return true
        }
        if !newString.isValidNumberFormat(3) {
            return false
        }
        textField.text = newString.formatNumber()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty else { return }
        if textField == percentTextField {
            textField.text = value.replacingOccurrences(of: " %", with: "").trimmingCharacters(in: .whitespaces)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty else { return }
        if textField == percentTextField {
            percentTextField.text! += " %"
        }
    }
}
