//
//  MusubiImagePicker.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/11/30.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit
import Photos

public protocol MusubiImagePickerDelegate: class {
    func didFinishPickingAssets(picker: MusubiImagePicker, selectedAssets: [PHAsset], assetCollection: PHAssetCollection!)
}

public class MusubiImagePicker: UINavigationController {
    public static func instanciate() -> MusubiImagePicker {
        return UIStoryboard(name: "MusubiImagePicker", bundle: Bundle(identifier: "net.ha1f.MusubiImagePicker")).instantiateInitialViewController() as! MusubiImagePicker
    }
    public weak var musubiImagePickerDelegate: MusubiImagePickerDelegate?
}
