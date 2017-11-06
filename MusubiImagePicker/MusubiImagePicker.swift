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
    
    /// Title shown on Navigation bar
    public var title = ""
    
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
    
    public static func tryAuthorize(_ handler: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { _ in
                tryAuthorize(handler)
            }
        case .authorized:
            handler(true)
        case .denied, .restricted:
            handler(false)
        }
    }
    
    private static func tryInstanciate(handler: @escaping (MusubiImagePicker?)->()) {
        tryAuthorize { isAuthorized in
            if isAuthorized {
                handler(instantiateFromStoryboard())
            } else {
                handler(nil)
            }
        }
    }
    
    private static func instantiateFromStoryboard() -> MusubiImagePicker? {
        return UIStoryboard(name: "MusubiImagePicker", bundle: Bundle.musubiImagePicker).instantiateInitialViewController() as? MusubiImagePicker
    }
}
