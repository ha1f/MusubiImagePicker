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
    
    func reloadWithAnimation() {
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            print(indexPaths)
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
        if !isCollectionViewCanSelect(collectionView) {
            collectionView.visibleCells
                .filter{ cell in !cell.isSelected }
                .forEach { cell in
                    cell.isUserInteractionEnabled = false
                }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.assetGridViewController(didDeselectCellAt: indexPath, asset: fetchResult.object(at: indexPath.item), collection: assetCollection)
        if isCollectionViewCanSelect(collectionView) {
            collectionView.visibleCells
                .forEach { cell in
                    cell.isUserInteractionEnabled = true
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isCollectionViewCanSelect(collectionView) && !cell.isSelected {
            cell.isUserInteractionEnabled = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let index = pickerViewController?.selectedLocalIdentifiers.index(where: { $0 == fetchResult.object(at: indexPath.item).localIdentifier }) {
            // TODO: 数字を出す
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
            cell.isSelected = true
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

extension MusubiAssetGridViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDelegateFlowLayout
    // 横に並ぶセルの数
    static let HORIZONTAL_CELLS_COUNT: CGFloat = 3
    // セルの間隔
    static let CELLS_MARGIN: CGFloat = 1
    // 周りの余白
    static let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    // TODO: パフォーマンス改善したい
    fileprivate var cellSize: CGSize {
        let space = type(of: self).CELLS_MARGIN
        
        var boundSize = collectionView!.bounds.size
        boundSize.width -= collectionView!.contentInset.left - collectionView!.contentInset.right
        boundSize.height -= collectionView!.contentInset.top - collectionView!.contentInset.bottom
        
        let contentWidth: CGFloat
        if let direction = (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection, direction == .horizontal {
            // 横スクロールなら縦並びのセル数として計算
            contentWidth = boundSize.height - MusubiAssetGridViewController.edgeInsets.top - MusubiAssetGridViewController.edgeInsets.bottom
        } else {
            contentWidth = boundSize.width - MusubiAssetGridViewController.edgeInsets.right - MusubiAssetGridViewController.edgeInsets.left
        }
        
        let cellLength = (contentWidth - space * (type(of: self).HORIZONTAL_CELLS_COUNT-1)) / type(of: self).HORIZONTAL_CELLS_COUNT
        
        return CGSize(width: cellLength, height: cellLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return MusubiAssetGridViewController.edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let space = type(of: self).CELLS_MARGIN
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let space = type(of: self).CELLS_MARGIN
        return space
    }
}
