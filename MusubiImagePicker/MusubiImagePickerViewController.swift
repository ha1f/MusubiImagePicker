//
//  MusubiImagePickerViewController.swift
//  MusubiImagePicker
//
//  Created by ST20591 on 2017/11/06.
//  Copyright © 2017年 はるふ. All rights reserved.
//

import UIKit
import Photos

class MusubiImagePickerViewController: UIViewController {
    
    @IBOutlet weak var selectAlbamView: UIView!
    @IBOutlet weak var assetGridView: UIView!
    
    override var title: String? {
        didSet {
            (navigationItem.titleView as? UILabel)?.text = title
        }
    }
    
    var assetGridViewController: MusubiAssetGridViewController? {
        return self.childViewControllers.flatMap { $0 as? MusubiAssetGridViewController }.first
    }
    
    var selectAlbamViewController: MusubiSelectAlbamViewController? {
        return self.childViewControllers.flatMap { $0 as? MusubiSelectAlbamViewController }.first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleLabel()
        selectAlbamView.isHidden = true
        selectAlbamViewController?.delegate = self
        
        setResult()
    }
    
    private func setResult(with collection: PHAssetCollection? = nil) {
        if let collection = collection {
            self.title = collection.localizedTitle ?? "Albam"
            assetGridViewController?.setResult(with: collection)
        } else {
            self.title = "All Photos"
            assetGridViewController?.setResultAllPhotos()
        }
    }
    
    private func setupTitleLabel() {
        let label = UILabel()
        label.text = self.title
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        let titleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTappedTitle(_:)))
        label.addGestureRecognizer(titleTapGestureRecognizer)
        navigationItem.titleView = label
    }
    
    @objc
    func onTappedTitle(_ recognizer: UIGestureRecognizer) {
        selectAlbamView.isHidden = !selectAlbamView.isHidden
    }
}

extension MusubiImagePickerViewController: MusubiSelectAlbamViewControllerDelegate {
    func selectAlbamViewController(didSelect collection: PHAssetCollection?) {
        setResult(with: collection)
        selectAlbamView.isHidden = true
    }
}
