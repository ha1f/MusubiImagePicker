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

class ViewController: UIViewController, MusubiImagePickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let picker = MusubiImagePicker.instanciate()
        picker.musubiImagePickerDelegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func didFinishPickingAssets(picker: MusubiImagePicker, selectedAssets: [PHAsset], assetCollection: PHAssetCollection!) {
        print("done")
        picker.dismiss(animated: true, completion: nil)
        print(selectedAssets.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

