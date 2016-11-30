//
//  MusubiImagePicker.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/11/30.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit
import Photos

@objc public protocol MusubiImagePickerDelegate: class {
    func didFinishPickingAssets(picker: MusubiImagePicker, selectedAssets: [PHAsset], assetCollection: PHAssetCollection!)
    @objc optional func didSelectAssetAt(indexPath: IndexPath)
    @objc optional func didDeselectAssetAt(indexPath: IndexPath)
}

public class MusubiImagePicker: UINavigationController {
    public var previouslySelectedAssetLocalIdentifiers = [String]()
    public var maxSelectionsCount = Int.max
    public static func instanciate() -> MusubiImagePicker {
        return UIStoryboard(name: "MusubiImagePicker", bundle: Bundle(identifier: "net.ha1f.MusubiImagePicker")).instantiateInitialViewController() as! MusubiImagePicker
    }
    public weak var musubiImagePickerDelegate: MusubiImagePickerDelegate?
}
