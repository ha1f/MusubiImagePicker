//
//  MusubiAssetViewController.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/12/01.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Foundation

class MusubiAssetViewController: AssetViewController {
//    var config: MusubiImagePickerConfiguration {
//        return (self.navigationController! as! MusubiImagePicker).config
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        editButton.isEnabled = editButton.isEnabled || config.isEditingEnabled
//        trashButton.isEnabled = trashButton.isEnabled || config.isDeletingEnabled
//        favoriteButton.isEnabled = favoriteButton.isEnabled || config.isFavoriteEnabled
    }
}
