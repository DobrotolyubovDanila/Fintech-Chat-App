//
//  ViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 10.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var profileAvatarView: ProfileAvatarView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var saveWithGCDButton: UIButton!
    
    @IBOutlet weak var saveWithOperationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var GCDProfileDM: DataManagerAbstraction!
    
    var operationManager: DataManagerAbstraction!
    
    var profileInformation: ProfileInformation!
    
    var profileImage: UIImage?
    
    weak var profileInformationDelegate: PassProfileInformationProtocol?
    
    // MARK: - Lificycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileAvatarView.setImage(image: profileImage)
        nameField.text = profileInformation.name
        descriptionTextView.text = profileInformation.description
        
        setInterfaceStyle()
        
        configKeyboardObservers()
        
        GCDProfileDM = GCDDataManager()
        operationManager = OperationDataManager()
        
        nameField.isUserInteractionEnabled = false
        descriptionTextView.isEditable = false
        profileAvatarView.profileImageButton.isEnabled = false
        
        activityIndicator.isHidden = true
        
        saveWithGCDButton.isHidden = true
        saveWithOperationButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatarView.setCornerRadius(cornerRadius: profileAvatarView.frame.height / 2)
        
        profileAvatarView.clipsToBounds = true
        
        editButton.layer.cornerRadius = 10
        saveWithGCDButton.layer.cornerRadius = 10
        saveWithOperationButton.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        profileInformationDelegate?.setProfileInformation(image: profileAvatarView.profileImageView.image)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    // MARK: - Work with keyboard
    private func configKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard self.navigationController?.view.frame.origin.y == 0 else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.view.frame.origin.y = 0
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Work with Interface
    func setInterfaceStyle() {
        editButton.backgroundColor = ThemeManager.shared.current.secondBackgroundColor
        editButton.setTitleColor(ThemeManager.shared.current.tintColor, for: .normal)
        nameField.textColor = ThemeManager.shared.current.mainTextColor
        descriptionTextView.textColor = ThemeManager.shared.current.mainTextColor
        saveWithGCDButton.backgroundColor = ThemeManager.shared.current.secondBackgroundColor
        saveWithOperationButton.backgroundColor = ThemeManager.shared.current.secondBackgroundColor
        
        view.backgroundColor = ThemeManager.shared.current.backgroundColor
        
        navigationController?.navigationBar.tintColor = ThemeManager.shared.current.tintColor
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.current.backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
    }
    
    // MARK: - Work with Buttons
    @IBAction func editButtonPressed(_ sender: Any) {
        switchEditMode()
    }
    
    @IBAction func GCDButtonPressed(_ sender: UIButton) {
        switchEditMode()
        
        prepareForSave()
        
        saveInformationWithGCD()
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        switchEditMode()
        
        prepareForSave()
        
        if profileInformation.name == nameField.text,
           profileInformation.description == descriptionTextView.text,
           profileInformation.imageData == profileAvatarView.profileImageView.image?.pngData() {
            enableInterface()
            return
        }
        
        profileInformation.name = nameField.text ?? ""
        profileInformation.description = descriptionTextView.text
        if let data = profileAvatarView.profileImageView.image?.pngData() {
            profileInformation.imageData = data
        }
        
        operationManager.saveProfileInformation(with: profileInformation) { [weak self] isSuccess in
            DispatchQueue.main.async {
                self?.enableInterface()
                if isSuccess {
                    self?.showAlert(title: "Success", message: "Data was written to the file with Operation")
                } else {
                    self?.showAlert(title: "Failing save", message: "Failed to save data")
                }
            }
        }
        
    }

    private func switchEditMode() {
        nameField.isUserInteractionEnabled.toggle()
        if nameField.isUserInteractionEnabled {
            nameField.layer.borderColor = ThemeManager.shared.current.secondBackgroundColor.cgColor
            nameField.layer.borderWidth = 1
        } else {
            nameField.layer.borderColor = nil
            nameField.layer.borderWidth = 0
        }
        
        descriptionTextView.isEditable.toggle()
        if descriptionTextView.isEditable {
            descriptionTextView.layer.borderWidth = 1
            descriptionTextView.layer.borderColor = ThemeManager.shared.current.secondBackgroundColor.cgColor
        } else {
            descriptionTextView.layer.borderWidth = 0
            descriptionTextView.layer.borderColor = nil
        }
        
        profileAvatarView.profileImageButton.isEnabled.toggle()
        
        editButton.isHidden.toggle()
        saveWithGCDButton.isHidden.toggle()
        saveWithOperationButton.isHidden.toggle()
    }
    
    private func prepareForSave() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        saveWithGCDButton.isEnabled = false
        saveWithOperationButton.isEnabled = false
    }
    
    private func saveInformationWithGCD() {
        
        if profileInformation.name == nameField.text,
           profileInformation.description == descriptionTextView.text,
           profileInformation.imageData == profileAvatarView.profileImageView.image?.pngData() {
            enableInterface()
            return
        }
        
        profileInformation.name = nameField.text ?? ""
        profileInformation.description = descriptionTextView.text
        if let data = profileAvatarView.profileImageView.image?.pngData() {
            profileInformation.imageData = data
        }
        
        GCDProfileDM.saveProfileInformation(with: profileInformation, completion: { [weak self] isSuccess in
            if isSuccess {
                self?.showAlert(title: "Success", message: "the data was written to the file")
                self?.enableInterface()
            } else {
                self?.showAlert(title: "Failing save", message: "Failed to save data")
            }
        })
    }
    
    deinit {
        print("deinit ProfileVC")
    }
}

extension ProfileViewController: DataUpdaterDelegate {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if title == "Success" {
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            alert.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { (_) in
                self.saveInformationWithGCD()
            }))
        }
        
        present(alert, animated: true)
    }
    
    func enableInterface() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        saveWithGCDButton.isEnabled = true
        saveWithOperationButton.isEnabled = true
    }
    
}

// MARK: - Support
protocol PassProfileInformationProtocol: class {
    func setProfileInformation(image: UIImage?)
}
