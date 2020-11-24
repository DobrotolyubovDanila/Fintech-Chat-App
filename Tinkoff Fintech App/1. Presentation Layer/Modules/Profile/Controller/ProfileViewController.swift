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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: ProfileVCModelProto!
    
    private var isEditingMode = false
    
    var didChangeImage = false
    
    weak var profileInformationDelegate: PassProfileInformationProtocol?
    
    // MARK: - Lificycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileAvatarView.setImage(image: model.profileImage)
        nameField.text = model.profileInformation?.name
        descriptionTextView.text = model.profileInformation?.description
        
        setInterfaceStyle()
        
        configKeyboardObservers()
        
        nameField.isUserInteractionEnabled = false
        descriptionTextView.isEditable = false
        profileAvatarView.profileImageButton.isEnabled = false
        
        activityIndicator.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatarView.setCornerRadius(cornerRadius: profileAvatarView.frame.height / 2)
        
        profileAvatarView.clipsToBounds = true
        
        editButton.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        profileInformationDelegate?.setProfileImage(image: profileAvatarView.profileImageView.image)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Work with Interface
    func setInterfaceStyle() {
        let themeManager = ThemeManager.shared.current
        editButton.backgroundColor = themeManager.secondBackgroundColor
        editButton.setTitleColor(themeManager.tintColor, for: .normal)
        nameField.textColor = themeManager.mainTextColor
        descriptionTextView.textColor = themeManager.mainTextColor
        
        view.backgroundColor = themeManager.backgroundColor
        
        navigationController?.navigationBar.tintColor = themeManager.tintColor
        navigationController?.navigationBar.barTintColor = themeManager.backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeManager.mainTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: themeManager.mainTextColor]
    }
    
    // MARK: - Work with Buttons
    @IBAction func editButtonPressed(_ sender: Any) {
        
        if isEditingMode {
            if model.profileInformation?.name != nameField.text ||
                model.profileInformation?.description != descriptionTextView.text ||
                didChangeImage {
                
                model.profileInformation?.name = nameField.text ?? ""
                model.profileInformation?.description = descriptionTextView.text
                if didChangeImage {
                    model.profileInformation?.imageData = profileAvatarView.profileImageView.image?.pngData() ?? Data()
                    didChangeImage = false
                }
                
                model.saveProfileInformation(with: model.profileInformation ?? ProfileInformation(name: "", description: "", imageData: nil))
            }
        }
        
        switchEditMode()
    }

    private func switchEditMode() {
        isEditingMode.toggle()
        
        if isEditingMode {
            nameField.isUserInteractionEnabled.toggle()
            nameField.layer.borderColor = ThemeManager.shared.current.secondBackgroundColor.cgColor
            nameField.layer.borderWidth = 1
            
            descriptionTextView.isEditable.toggle()
            descriptionTextView.layer.borderWidth = 1
            descriptionTextView.layer.borderColor = ThemeManager.shared.current.secondBackgroundColor.cgColor
            
            profileAvatarView.profileImageButton.isEnabled.toggle()
            
            editButton.setTitle("Save", for: .normal)
        } else {
            nameField.isUserInteractionEnabled.toggle()
            nameField.layer.borderColor = nil
            nameField.layer.borderWidth = 0
            
            descriptionTextView.isEditable.toggle()
            descriptionTextView.layer.borderWidth = 0
            descriptionTextView.layer.borderColor = nil
            
            profileAvatarView.profileImageButton.isEnabled.toggle()
            
            editButton.setTitle("Edit", for: .normal)
        }
    }
    
    deinit {
        print("deinit ProfileVC")
    }
}

// MARK: - Support
protocol PassProfileInformationProtocol: class {
    func setProfileImage(image: UIImage?)
}
