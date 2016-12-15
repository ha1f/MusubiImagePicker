//
//  MusubiImagePicker.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/11/30.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit
import Photos

public struct MusubiImagePickerConfiguration {
    // すでに選択されているAssetのlocalIdentifierを渡しておける
    public var previouslySelectedAssetLocalIdentifiers = [String]()
    // 選択可能枚数（初期値は上限なし）
    public var maxSelectionsCount = Int.max
    // delegate
    public weak var delegate: MusubiImagePickerDelegate?
    
    public var isEditingEnabled = false
    public var isDeletingEnabled = false
    public var isFavoriteEnabled = false
}

@objc public protocol MusubiImagePickerDelegate: class {
    func didFinishPickingAssets(picker: MusubiImagePicker, selectedAssets: [PHAsset], assetCollection: PHAssetCollection!)
    @objc optional func didCancelPickingAssets(picker: MusubiImagePicker)
    @objc optional func didSelectAssetAt(indexPath: IndexPath)
    @objc optional func didDeselectAssetAt(indexPath: IndexPath)
}

public class MusubiImagePicker: UINavigationController {
    public var config = MusubiImagePickerConfiguration()
    public static func instanciate(handler: @escaping (MusubiImagePicker?)->()) {
        tryInstanciate(handler: handler)
    }
    private static func tryInstanciate(handler: @escaping (MusubiImagePicker?)->()) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization {_ in 
                tryInstanciate(handler: handler)
            }
        case .authorized:
            handler(UIStoryboard(name: "MusubiImagePicker", bundle: Bundle(identifier: "net.ha1f.MusubiImagePicker")).instantiateInitialViewController() as! MusubiImagePicker)
        case .denied, .restricted:
            handler(nil)
        }
    }
}
