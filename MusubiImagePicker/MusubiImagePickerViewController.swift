//
//  MusubiImagePickerViewController.swift
//  MusubiImagePicker
//
//  Created by ST20591 on 2017/11/06.
//  Copyright © 2017年 はるふ. All rights reserved.
//

import UIKit
import Photos

public class MusubiImagePickerViewController: UIViewController {
    
    @IBOutlet weak var selectAlbamView: UIView!
    @IBOutlet weak var assetGridView: UIView!
    
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet var deselectBarButtonItem: UIBarButtonItem!
    
    var config: MusubiImagePickerConfiguration = MusubiImagePickerConfiguration()
    
    weak var delegate: MusubiImagePickerDelegate?
    
    var isSelectAlbamViewHidden: Bool = true {
        didSet {
            selectAlbamView.isHidden = false
            if oldValue != isSelectAlbamViewHidden {
                // 変化時はアニメーション
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let unwrappedSelf = self else {
                        return
                    }
                    if unwrappedSelf.isSelectAlbamViewHidden {
                        unwrappedSelf.selectAlbamView.transform = CGAffineTransform(translationX: 0, y: -unwrappedSelf.selectAlbamView.frame.height)
                    } else {
                        unwrappedSelf.selectAlbamView.transform = CGAffineTransform.identity
                    }
                }
            } else {
                if isSelectAlbamViewHidden {
                    selectAlbamView.isHidden = true
                    selectAlbamView.transform = CGAffineTransform(translationX: 0, y: -selectAlbamView.frame.height)
                } else {
                    selectAlbamView.transform = CGAffineTransform.identity
                }
            }
            updateTitle()
        }
    }
    
    var selectedLocalIdentifiers = [String]() {
        didSet {
            deselectBarButtonItem.isEnabled = !selectedLocalIdentifiers.isEmpty
            updateTitle()
        }
    }
    
    public var albamTitle: String = "" {
        didSet {
            updateTitle()
        }
    }
    
    override public var title: String? {
        didSet {
            guard let label = navigationItem.titleView as? UILabel else {
                return
            }
            label.numberOfLines = 2
            label.text = title
            label.sizeToFit()
        }
    }
    
    private var collapseMark: String {
        return isSelectAlbamViewHidden ? "▼" : "▲"
    }
    
    private func updateTitle() {
        if selectedLocalIdentifiers.isEmpty {
            self.title = "\(albamTitle)\(collapseMark)"
        } else {
            self.title = "\(albamTitle)\(collapseMark)\n\(selectedLocalIdentifiers.count)件選択中"
        }
    }
    
    var assetGridViewController: MusubiAssetGridViewController? {
        return self.childViewControllers.flatMap { $0 as? MusubiAssetGridViewController }.first
    }
    
    var selectAlbamViewController: MusubiSelectAlbamViewController? {
        return self.childViewControllers.flatMap { $0 as? MusubiSelectAlbamViewController }.first
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLocalIdentifiers = config.previouslySelectedAssetLocalIdentifiers
        
        setupTitleLabel()
        isSelectAlbamViewHidden = true
        selectAlbamViewController?.delegate = self
        
        assetGridViewController?.delegate = self
        assetGridViewController?.pickerViewController = self
        
        setResult()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // DONE
        doneBarButtonItem.target = self
        doneBarButtonItem.action = #selector(self.onDonePickingAssets)
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        // CANCEL
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(self.onCancelPickingAssets)
        
        // DeselectAll
        deselectBarButtonItem.target = self
        deselectBarButtonItem.action = #selector(self.onDeselectAll)
        navigationItem.leftBarButtonItems = [
            cancelBarButtonItem, deselectBarButtonItem
        ]
        
        navigationController?.isToolbarHidden = true
    }
    
    private func setResult(with collection: PHAssetCollection? = nil) {
        if let collection = collection {
            self.albamTitle = collection.localizedTitle ?? "Albam"
            assetGridViewController?.setResult(with: collection)
        } else {
            self.albamTitle = "All Photos"
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
        isSelectAlbamViewHidden = !isSelectAlbamViewHidden
        updateTitle()
    }
    
    @objc
    func onDeselectAll() {
        selectedLocalIdentifiers = []
        assetGridViewController?.reloadWithAnimation()
    }
    
    @objc
    func onDonePickingAssets() {
        delegate?.musubiImagePicker(didFinishPickingAssetsIn: self, assets: selectedLocalIdentifiers)
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
    func assetGridViewController(didSelectCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?) {
        selectedLocalIdentifiers.append(asset.localIdentifier)
    }
    func assetGridViewController(didDeselectCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?) {
        if let removeIndex = selectedLocalIdentifiers.index(where: { $0 == asset.localIdentifier  }) {
            selectedLocalIdentifiers.remove(at: removeIndex)
        }
    }
}

extension MusubiImagePickerViewController: MusubiSelectAlbamViewControllerDelegate {
    func selectAlbamViewController(didSelect collection: PHAssetCollection?) {
        setResult(with: collection)
        isSelectAlbamViewHidden = true
    }
}
