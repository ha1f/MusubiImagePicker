//
//  ViewController.swift
//  MusubiImagePickerDemo
//
//  Created by はるふ on 2016/11/30.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit
import MusubiImagePicker
import Photos

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var config = MusubiImagePickerConfiguration()
        config.maxSelectionsCount = 3
        config.previouslySelectedAssetLocalIdentifiers = ["ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED/L0/001"]
        MusubiImagePicker.show(from: self, config: config, delegate: self)
    }
}

extension ViewController: MusubiImagePickerDelegate {
    func musubiImagePicker(didFinishPickingAssetsIn picker: MusubiImagePickerViewController, assets: [String]) {
        print("finish", assets)
    }
    
    func musubiImagePicker(didCancelPickingAssetsIn picker: MusubiImagePickerViewController) {
        print("cancel")
    }
}
