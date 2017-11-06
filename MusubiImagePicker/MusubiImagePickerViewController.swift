//
//  MusubiImagePickerViewController.swift
//  MusubiImagePicker
//
//  Created by ST20591 on 2017/11/06.
//  Copyright © 2017年 はるふ. All rights reserved.
//

import UIKit
import Photos

protocol MusubiImagePickerDelegate: class {
    func musubiImagePicker(didFinishPickingAssetsIn picker: MusubiImagePickerViewController, assets: [PHAsset])
    func musubiImagePicker(didCancelPickingAssetsIn picker: MusubiImagePickerViewController)
}

class MusubiImagePickerViewController: UIViewController {
    
    @IBOutlet weak var selectAlbamView: UIView!
    @IBOutlet weak var assetGridView: UIView!
    
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet var cancelBarButtonItem: UIBarButtonItem!
    
    weak var delegate: MusubiImagePickerDelegate?
    
    // TODO: set properly
    var selectedAssets = [PHAsset]()
    
    override var title: String? {
        didSet {
            guard let label = navigationItem.titleView as? UILabel else {
                return
            }
            label.text = title
            label.sizeToFit()
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
        
        assetGridViewController?.delegate = self
        
        setResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // DONE
        doneBarButtonItem.target = self
        doneBarButtonItem.action = #selector(self.onDonePickingAssets)
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        // CANCEL
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(self.onCancelPickingAssets)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
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
    
    @objc
    func onDonePickingAssets() {
        delegate?.musubiImagePicker(didFinishPickingAssetsIn: self, assets: selectedAssets)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func onCancelPickingAssets() {
        delegate?.musubiImagePicker(didCancelPickingAssetsIn: self)
        self.dismiss(animated: true, completion: nil)
    }
}

extension MusubiImagePickerViewController: MusubiAssetGridViewControllerDelegate {
    func assetGridViewController(didLongPressCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?) {
        guard let viewController = UIStoryboard(name: "AssetViewController", bundle: Bundle.musubiImagePicker).instantiateInitialViewController() as? MusubiAssetViewController else {
            return
        }
        viewController.asset = asset
        viewController.assetCollection = collection
        self.show(viewController, sender: nil)
    }
}

extension MusubiImagePickerViewController: MusubiSelectAlbamViewControllerDelegate {
    func selectAlbamViewController(didSelect collection: PHAssetCollection?) {
        setResult(with: collection)
        selectAlbamView.isHidden = true
    }
}
