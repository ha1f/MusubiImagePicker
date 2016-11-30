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

class MusubiAssetGridViewController: AssetGridViewController {
    @IBOutlet var doneButtonItem: UIBarButtonItem!
    @IBOutlet var cancelButtonItem: UIBarButtonItem!
    
    var delegate: MusubiImagePickerDelegate? {
        return config.delegate
    }
    
    var musubiImagePicker: MusubiImagePicker {
        return self.navigationController! as! MusubiImagePicker
    }
    
    // すでに選択されているAssetを前の画面から渡せる
    var config: MusubiImagePickerConfiguration {
        set {
            musubiImagePicker.config = newValue
        }
        get {
            return musubiImagePicker.config
        }
    }
    
    var selectedAssets: [PHAsset] {
        return fetchResult.objects(at: IndexSet(self.collectionView!.indexPathsForSelectedItems!.map { $0.item }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 長押ししたら画像を開く
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.onCellPressedLong(_:)))
        collectionView?.addGestureRecognizer(gestureRecognizer)
        
        collectionView?.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 完了ボタン
        navigationItem.rightBarButtonItem = doneButtonItem
        doneButtonItem.target = self
        doneButtonItem.action = #selector(self.onFinishSelectingAssets)
        
        // キャンセルボタン
        navigationItem.leftBarButtonItem = cancelButtonItem
        cancelButtonItem.target = self
        cancelButtonItem.action = #selector(self.onCancelPickingAssets)
    }
    
    // Asset詳細への遷移でindexPathを渡すようにしたので変更
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AssetViewController else {
            fatalError("unexpected view controller for segue")
        }
        let indexPath = sender as! IndexPath
        destination.asset = fetchResult.object(at: indexPath.item)
        destination.assetCollection = assetCollection
    }
    
    func onCellPressedLong(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.view! == collectionView! else {
            return
        }
        if recognizer.state == .began {
            let point = recognizer.location(in: recognizer.view)
            let indexPath = self.collectionView!.indexPathForItem(at: point)!
            self.performSegue(withIdentifier: "showAsset", sender: indexPath)
        }
    }
    
    func onCancelPickingAssets() {
        delegate?.didCancelPickingAssets?(picker: musubiImagePicker)
    }
    
    func onFinishSelectingAssets() {
        delegate?.didFinishPickingAssets(picker: musubiImagePicker, selectedAssets: selectedAssets, assetCollection: assetCollection)
    }
    
    private func isCollectionViewCanSelect(_ collectionView: UICollectionView) -> Bool {
        return collectionView.indexPathsForSelectedItems?.count ?? 0 < (config.maxSelectionsCount - config.previouslySelectedAssetLocalIdentifiers.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectAssetAt?(indexPath: indexPath)
        if !isCollectionViewCanSelect(collectionView) {
            collectionView.visibleCells
                .filter{ cell in !cell.isSelected }
                .forEach { cell in
                    cell.isUserInteractionEnabled = false
                }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = config.previouslySelectedAssetLocalIdentifiers.index(of: fetchResult.object(at: indexPath.item).localIdentifier) {
            config.previouslySelectedAssetLocalIdentifiers.remove(at: index)
        }
        
        if isCollectionViewCanSelect(collectionView) {
            collectionView.visibleCells
                .forEach { cell in
                    cell.isUserInteractionEnabled = true
            }
        }
        delegate?.didDeselectAssetAt?(indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isCollectionViewCanSelect(collectionView) && !cell.isSelected {
            cell.isUserInteractionEnabled = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let index = config.previouslySelectedAssetLocalIdentifiers.index(of: fetchResult.object(at: indexPath.item).localIdentifier) {
            // 含まれている
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
            cell.isSelected = true
            config.previouslySelectedAssetLocalIdentifiers.remove(at: index)
        }
        return cell
    }
    
    private func addAsset(image: UIImage) {
        // photo libraryに追加
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if let assetCollection = self.assetCollection {
                let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
            }
        }) { success, error in
            if !success {
                print("error creating asset: \(error)")
            }
        }
    }
}

extension MusubiAssetGridViewController: UICollectionViewDelegateFlowLayout {
    // MARK: LayoutDelegates
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
