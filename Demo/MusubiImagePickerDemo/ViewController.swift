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
        config.previouslySelectedAssetLocalIdentifiers = ["ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED/L0/001", "495F9CF5-F638-4694-9C48-B73451DA9C7A/L0/001"]
        MusubiImagePicker.show(from: self, config: config)
    }
}

