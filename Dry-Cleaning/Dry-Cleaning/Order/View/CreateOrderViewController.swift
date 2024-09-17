//
//  CreateOrderViewController.swift
//  Dry-Cleaning
//
//  Created by Karen Khachatryan on 17.09.24.
//

import UIKit
import Combine
import PhotosUI

class CreateOrderViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var materialsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var weightTextField: BaseTextField!
    @IBOutlet weak var costTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var timeTextField: BaseTextField!
    @IBOutlet weak var createButton: UIButton!
    private let viewModel = OrderViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private var datePicker = UIDatePicker()
    private var timePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "Create an order", button: nil)
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        self.materialsTableView.reloadData()
        self.materialsTableView.layoutIfNeeded()
        self.tableViewHeightConst.constant = self.materialsTableView.contentSize.height
    }
    
    func setupUI() {
        self.registerKeyboardNotifications()
        nameTextField.delegate = self
        weightTextField.delegate = self
        costTextField.delegate = self
        materialsTableView.delegate = self
        materialsTableView.dataSource = self
        materialsTableView.register(UINib(nibName: "MaterialTableViewCell", bundle: nil), forCellReuseIdentifier: "MaterialTableViewCell")
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        datePicker.tintColor = .background
        timePicker.locale = NSLocale.current
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(sender:)), for: .valueChanged)
        timePicker.tintColor = .background
        dateTextField.inputView = datePicker
        timeTextField.inputView = timePicker
        createButton.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        timeTextField.placeholder = Date().timeFormat()
        dateTextField.placeholder = Date().dateFormat()
        photoImageView.layer.borderWidth = 3
        photoImageView.layer.borderColor = UIColor.redBorder.cgColor
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        let hourDate = sender.date
        let hourFormmater = DateFormatter()
        hourFormmater .locale = Locale.current
        hourFormmater.dateFormat = "HH:mm"
        let formatedTime = hourFormmater.string(from: hourDate)
        timeTextField.text = formatedTime
        viewModel.setTime(time: formatedTime)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let hourDate = sender.date
        let hourFormmater = DateFormatter()
        hourFormmater .locale = Locale.current
        hourFormmater.dateFormat = "dd.MM.YY"
        let formatedDate = hourFormmater.string(from: hourDate)
        dateTextField.text = formatedDate
        viewModel.setDate(date: formatedDate)
    }
    
    func subscribe() {
        viewModel.$materials
            .receive(on: DispatchQueue.main)
            .sink { [weak self] materials in
                guard let self = self, materials.count != viewModel.previousClassesCount else { return }
                self.materialsTableView.reloadData()
                self.materialsTableView.layoutIfNeeded()
                self.tableViewHeightConst.constant = self.materialsTableView.contentSize.height
                self.viewModel.previousClassesCount = materials.count
            }
            .store(in: &cancellables)
        
        viewModel.$isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                guard let self = self else { return }
                self.createButton.isEnabled = isValid
                self.createButton.backgroundColor = isValid ? .black : .black.withAlphaComponent(0.5)
            }
            .store(in: &cancellables)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func clickedAddMaterial(_ sender: UIButton) {
        viewModel.addMaterial()
    }
    @IBAction func choosePhoto(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.requestCameraAccess()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func clickedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickedCreate(_ sender: UIButton) {
        viewModel.createOrder(completion: { [weak self] success in
            if success {
                let coolView = CoolView.instanceFromNib()
                coolView.completion = { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.popViewController(animated: true)
                }
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    keyWindow.addSubview(coolView)
                }
            }
        })
    }
    
    deinit {
        viewModel.clear()
    }
}

extension CreateOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.materials.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialTableViewCell", for: indexPath) as! MaterialTableViewCell
        cell.setupData(material: viewModel.materials[indexPath.section], index: indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section < (viewModel.materials.count - 1) ? UIView() : nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section < (viewModel.materials.count - 1) ? 16 : 0
    }
}

extension CreateOrderViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.setName(name: textField.text)
        case weightTextField:
            viewModel.setWeight(weight: textField.text)
        case costTextField:
            viewModel.setCost(cost: textField.text)
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty else { return }
        switch textField {
        case weightTextField:
            textField.text = value.replacingOccurrences(of: " Kg", with: "").trimmingCharacters(in: .whitespaces)

        case costTextField:
            textField.text = value.replacingOccurrences(of: " $", with: "").trimmingCharacters(in: .whitespaces)
        default:
            break
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text, !value.isEmpty else { return }
        switch textField {
        case weightTextField:
            weightTextField.text! += " Kg"
        case costTextField:
            costTextField.text! += " $"
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }

        switch textField {
        case weightTextField, costTextField:
            let currentText = textField.text ?? ""
            let str = string == "," ? "." : string
            var newString = (currentText as NSString).replacingCharacters(in: range, with: str)
            if string.isEmpty {
                return true
            }
            if !newString.isValidNumberFormat() {
                return false
            }
            textField.text = newString.formatNumber()
            return false
        default:
            return true
        }
    }
    
    
}

extension CreateOrderViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateOrderViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

extension CreateOrderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess() {
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
            case .authorized:
                openCamera()
            case .denied, .restricted:
                showSettingsAlert()
            @unknown default:
                break
            }
        }
        
        private func requestPhotoLibraryAccess() {
            let photoStatus = PHPhotoLibrary.authorizationStatus()
            switch photoStatus {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.openPhotoLibrary()
                    }
                }
            case .authorized:
                openPhotoLibrary()
            case .denied, .restricted:
                showSettingsAlert()
            case .limited:
                break
            @unknown default:
                break
            }
        }
        
        private func openCamera() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func openPhotoLibrary() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func showSettingsAlert() {
            let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                photoImageView.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                photoImageView.image = originalImage
            }
            if let imageData = photoImageView.image?.jpegData(compressionQuality: 1.0) {
                let nsData = imageData as NSData
                viewModel.setPhoto(data: nsData)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
