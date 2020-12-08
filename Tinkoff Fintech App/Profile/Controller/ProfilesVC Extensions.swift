//
//  ProfilesVC Extensions.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 08.12.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentTransition = CustomTransition(animationDuration: 0.5, animationType: .present)
        presentTransition.fromCenter = self.fromCenter
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(animationDuration: 0.7, animationType: .dismiss)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
        let networkImages = UIAlertAction(title: "Download", style: .default) { (_) in
            
            if let vc = self.presentationAssembly?.NetworkImagesViewController() {
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)

            }
        }
        
        networkImages.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cansel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(networkImages)
        actionSheet.addAction(cansel)
        
        if ThemeManager.shared.current.style == .night {
            if #available(iOS 13.0, *) {
                actionSheet.overrideUserInterfaceStyle = .dark
            }
        }
        
        present(actionSheet, animated: true)
    }
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true //Редактирование после выбора
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[.editedImage] as? UIImage
        profileAvatarView.setImage(image: image)
        self.didChangeImage = true
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: PassProfileImageProtocol {
    func setProfileImage(image: UIImage?) {
        self.profileAvatarView.setImage(image: image)
        self.didChangeImage = true
        
    }
}
