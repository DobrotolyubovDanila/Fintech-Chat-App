//
//  ViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 10.09.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileAvatarView: ProfileAvatarView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var informationTextView: UITextView!
    
    var profileImage:UIImage?
    
    var profileImageDelegate: PassImageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileAvatarView.setImage(image: profileImage)
        
        setInterfaceStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        /*
         Свойства frame отличаются из-за того, что в петвом случае
         наш основной view и его subViews были загружены,но не "обработаны" Auto Layout.
         
         Во втором случае механизм уже отработал. Frame стал соотсетствовать констрейнтам.
         Поэтому округление провожу в
         текущем методе.
         */
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatarView.setCornerRadius(cornerRadius: profileAvatarView.frame.height/2)
        
        profileAvatarView.clipsToBounds = true
        
        
        editButton.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        profileImageDelegate?.setImage(image: profileAvatarView.profileImageView.image)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoLiteral = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.chooseImagePicker(source: UIImagePickerController.SourceType.camera)
        })
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default, handler: { _ in
            self.chooseImagePicker(source: UIImagePickerController.SourceType.photoLibrary)
        })
        photo.setValue(photoLiteral, forKey: "image")//Добавление изображения всплывающему меню
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")//выравнивание слева
        
        let cansel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cansel)
        
        if ThemeManager.shared.current.style == .night {
            if #available(iOS 13.0, *) {
                actionSheet.overrideUserInterfaceStyle = .dark
            }
        }
        
        present(actionSheet, animated:true)
        
    }
    
    
    func setInterfaceStyle() {
        editButton.backgroundColor = ThemeManager.shared.current.secondBackgroundColor
        editButton.setTitleColor(ThemeManager.shared.current.tintColor, for: .normal)
        nameField.textColor = ThemeManager.shared.current.mainTextColor
        informationTextView.textColor = ThemeManager.shared.current.mainTextColor
        
        view.backgroundColor = ThemeManager.shared.current.backgroundColor
        
        navigationController?.navigationBar.tintColor = ThemeManager.shared.current.tintColor
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.current.backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.shared.current.mainTextColor]
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true //Редактирование после выбора
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]){
        
        let image = info[.editedImage] as? UIImage
        profileAvatarView.setImage(image: image)
        
        dismiss(animated: true, completion: nil)
    }
    
}

protocol PassImageProtocol {
    func setImage(image: UIImage?) -> ()
}
