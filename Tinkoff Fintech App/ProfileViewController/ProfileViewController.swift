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
    
    var profileInfoDataManager: DataManagerAbstraction!
    
    var profileInformation: ProfileInformation!
    
    var profileImage: UIImage?
    
    var isEditingMode = false
    
    var didChangeImage = false
    
    weak var profileInformationDelegate: PassProfileInformationProtocol?
    
    // MARK: - Lificycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileAvatarView.setImage(image: profileImage)
        nameField.text = profileInformation.name
        descriptionTextView.text = profileInformation.description
        
        setInterfaceStyle()
        
        configKeyboardObservers()
        
        nameField.isUserInteractionEnabled = false
        descriptionTextView.isEditable = false
        profileAvatarView.profileImageButton.isEnabled = false
        
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatarView.setCornerRadius(cornerRadius: profileAvatarView.frame.height / 2)
        
        profileAvatarView.clipsToBounds = true
        
        editButton.layer.cornerRadius = 10
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
        UIView.animate(withDuration: 0.2) {
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
        
        view.backgroundColor = ThemeManager.shared.current.backgroundColor
        
        navigationController?.navigationBar.tintColor = ThemeManager.shared.current.tintColor
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.current.backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
    }
    
    // MARK: - Work with Buttons
    @IBAction func editButtonPressed(_ sender: Any) {
        
        if isEditingMode {
            if profileInformation.name != nameField.text ||
                profileInformation.description != descriptionTextView.text ||
                didChangeImage {
                
                profileInformation.name = nameField.text ?? ""
                profileInformation.description = descriptionTextView.text
                if didChangeImage {
                    profileInformation.imageData = profileAvatarView.profileImageView.image?.pngData() ?? Data()
                    didChangeImage = false
                }
                
                profileInfoDataManager.saveProfileInformation(with: profileInformation) {
                    print("Saved by CoreData")
                }
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
    
    private func prepareForSave() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
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
                
            }))
        }
        
        present(alert, animated: true)
    }
    
    func enableInterface() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
}

// MARK: - Support
protocol PassProfileInformationProtocol: class {
    func setProfileInformation(image: UIImage?)
}
