//
//  NetworkImagesViewController.swift
//  Tinkoff Fintech App
//
//  Created by Данила on 27.11.2020.
//  Copyright © 2020 Dobrotolyubov Danila. All rights reserved.
//

import UIKit

class NetworkImagesViewController: UICollectionViewController {
    
    let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    var model: NetworkImagesModel!
    
    weak var delegate: PassProfileImageProtocol?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 50,
                                                              y: 50,
                                                              width: 50,
                                                              height: 50))
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = ThemeManager.shared.current.backgroundColor
        
        view.addSubview(activityIndicator)
        
        let centrX = activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor, constant: 0)
        let centrY = activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([centrY, centrX])
        
        activityIndicator.startAnimating()
        
        DispatchQueue.global().async { [weak self] in
            self?.model.networkManager.getReferences { (ustrings) in
                self?.model.urlStrings = ustrings
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
            }
        }
    }
    
    deinit {
        print("deinit NetworkImagesViewController")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.urlStrings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? NetworkImageCell else {
            return UICollectionViewCell()
        }
        
        let urlString = model.urlStrings[indexPath.row]
        
        if let image = model.images[urlString] {
            
            cell.imageView.image = image
            return cell
        }
        
        model.networkManager.getImage(url: urlString) { [weak self] (image) in
            if let image = image {
                cell.setImage(image: image)
                self?.model.images[urlString] = image
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = model.urlStrings[indexPath.row]
        if let image = model.images[url] {
            delegate?.setProfileImage(image: image)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension NetworkImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + 4
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / 3
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Int(collectionView.frame.width), height: 40)
    }
    
}
