//
//  MusubiAssetGridViewController.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/11/30.
//  Copyright © 2016年 Apple. All rights reserved.
//


import UIKit
import Photos
import PhotosUI

protocol MusubiAssetGridViewControllerDelegate: class {
    func assetGridViewController(didLongPressCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?)
    func assetGridViewController(didSelectCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?)
    func assetGridViewController(didDeselectCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?)
}

extension MusubiAssetGridViewControllerDelegate {
    func assetGridViewController(didLongPressCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?) {
        
    }
    func assetGridViewController(didSelectCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?) {
        
    }
    func assetGridViewController(didDeselectCellAt indexPath: IndexPath, asset: PHAsset, collection: PHAssetCollection?) {
        
    }
}

class MusubiAssetGridViewController: AssetGridViewController {
    @IBOutlet var doneButtonItem: UIBarButtonItem!
    @IBOutlet var cancelButtonItem: UIBarButtonItem!
    
    weak var pickerViewController: MusubiImagePickerViewController?
    weak var delegate: MusubiAssetGridViewControllerDelegate?
    
    var config: MusubiImagePickerConfiguration {
        return pickerViewController?.config ?? MusubiImagePickerConfiguration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.onCellPressedLong(_:)))
        collectionView?.addGestureRecognizer(gestureRecognizer)
        
        collectionView?.allowsMultipleSelection = true
        
        if fetchResult == nil {
            setResultAllPhotos()
        }
    }
    
    private func _layoutGrid() {
        let numberOfGridsPerRow = Int(round(view.frame.width / 120))
        collectionView?.adaptBeautifulGrid(numberOfGridsPerRow: numberOfGridsPerRow, gridLineSpace: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _layoutGrid()
    }
    
    func setResultAllPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: options)
        assetCollection = nil
        collectionView?.reloadData()
    }
    
    func setResult(with collection: PHAssetCollection) {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(in: collection, options: options)
        assetCollection = collection
        collectionView?.reloadData()
    }
    
    func reloadSelectedCells(additionalIndexPaths: [IndexPath] = []) {
        guard let collectionView = collectionView else {
            return
        }
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            collectionView.reloadItems(at: indexPaths)
        }
    }
    
    func reloadWithAnimation() {
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            collectionView?.reloadItems(at: indexPaths)
        }
        collectionView?.reloadData()
    }
    
    @objc func onCellPressedLong(_ recognizer: UILongPressGestureRecognizer) {
        guard let collectionView = self.collectionView, recognizer.view == collectionView else {
            return
        }
        if recognizer.state == .began {
            let point = recognizer.location(in: recognizer.view)
            let indexPath = collectionView.indexPathForItem(at: point)!
            delegate?.assetGridViewController(didLongPressCellAt: indexPath, asset: fetchResult.object(at: indexPath.item), collection: assetCollection)
        }
    }
    
    // MARK: - UICollectionView
    
    private func isCollectionViewCanSelect(_ collectionView: UICollectionView) -> Bool {
        return (pickerViewController?.selectedLocalIdentifiers.count ?? 0) < config.maxSelectionsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.assetGridViewController(didSelectCellAt: indexPath, asset: fetchResult.object(at: indexPath.item), collection: assetCollection)
        reloadSelectedCells()
        disableUserInteractionIfNeed(collectionView)
    }
    
    private func disableUserInteractionIfNeed(_ collectionView: UICollectionView) {
        if !isCollectionViewCanSelect(collectionView) {
            collectionView.visibleCells
                .filter{ cell in !cell.isSelected }
                .forEach { cell in
                    cell.isUserInteractionEnabled = false
            }
        }
    }
    
    private func enableUserInteractionIfNeed(_ collectionView: UICollectionView) {
        if isCollectionViewCanSelect(collectionView) {
            collectionView.visibleCells
                .forEach { cell in
                    cell.isUserInteractionEnabled = true
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.assetGridViewController(didDeselectCellAt: indexPath, asset: fetchResult.object(at: indexPath.item), collection: assetCollection)
        // 今解除されたものと、既に選択されたものをリロード
        reloadSelectedCells(additionalIndexPaths: [indexPath])
        
        // 選択できるなら選択できるように更新
        enableUserInteractionIfNeed(collectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isCollectionViewCanSelect(collectionView) && !cell.isSelected {
            cell.isUserInteractionEnabled = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let index = pickerViewController?.selectedLocalIdentifiers.index(where: { $0 == fetchResult.object(at: indexPath.item).localIdentifier }) {
            (cell as? MusubiGridViewCell)?.indexOfSelection = index
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.isSelected = true
        } else {
            (cell as? MusubiGridViewCell)?.indexOfSelection = nil
        }
        return cell
    }
    
//    private func addAsset(image: UIImage) {
//        // photo libraryに追加
//        PHPhotoLibrary.shared().performChanges({
//            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//            if let assetCollection = self.assetCollection {
//                let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
//                addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
//            }
//        }) { success, error in
//            if !success {
//                print("error creating asset: \(error?.localizedDescription ?? "error")")
//            }
//        }
//    }
}
