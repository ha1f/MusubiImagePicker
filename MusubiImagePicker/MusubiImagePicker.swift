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
    
    public init() {
        
    }
    
    public var isEditingEnabled = false
    public var isDeletingEnabled = false
    public var isFavoriteEnabled = false
}

public class MusubiImagePicker {
    public static func show(from viewController: UIViewController, config: MusubiImagePickerConfiguration) {
        tryInstanciate { picker in
            guard let picker = picker else {
                return
            }
            DispatchQueue.main.async {
                if let _ = viewController.navigationController {
                    viewController.show(picker, sender: nil)
                    return
                }
                if let nav = viewController as? UINavigationController {
                    nav.show(picker, sender: nil)
                    return
                }
                let nav = UINavigationController(rootViewController: picker)
                viewController.show(nav, sender: nil)
            }
        }
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
    
    private static func tryInstanciate(handler: @escaping (MusubiImagePickerViewController?)->()) {
        tryAuthorize { isAuthorized in
            if isAuthorized {
                handler(instantiateFromStoryboard())
            } else {
                handler(nil)
            }
        }
    }
    
    private static func instantiateFromStoryboard() -> MusubiImagePickerViewController? {
        return UIStoryboard(name: "MusubiImagePickerViewController", bundle: Bundle.musubiImagePicker).instantiateInitialViewController() as? MusubiImagePickerViewController
    }
}
