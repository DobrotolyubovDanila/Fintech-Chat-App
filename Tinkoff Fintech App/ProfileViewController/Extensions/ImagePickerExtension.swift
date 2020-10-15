//
//  ImagePickerExtension.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 15.10.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType){
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
