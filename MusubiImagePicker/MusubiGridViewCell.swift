//
//  MusubiGridViewCell.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/11/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class MusubiGridViewCell: GridViewCell {
    
    private var checkBoxView: CheckBoxView!
    private var whiteLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckBox()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCheckBox()
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            if isUserInteractionEnabled {
                whiteLayer?.removeFromSuperlayer()
                whiteLayer = nil
            } else {
                whiteLayer?.removeFromSuperlayer()
                let layer = CALayer()
                layer.frame = self.bounds
                layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor
                self.layer.addSublayer(layer)
                whiteLayer = layer
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkBoxView.isHidden = !isSelected
            if oldValue != isSelected {
                // 変化あり
                let imageView = self.imageView
                if isSelected {
                    UIView.animate(withDuration: 0.05, animations: { [weak imageView] in
                        imageView?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.03) {[weak imageView] in
                                imageView?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                            }
                    })
                } else {
                    UIView.animate(withDuration: 0.04, animations: { [weak imageView] in
                        imageView?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.05) {[weak imageView] in
                                imageView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            }
                    })
                }
            }
        }
    }
    
    private func setupCheckBox() {
        let boxWidth = frame.width * 0.5
        let boxRect = CGRect(origin: .zero, size: CGSize(width: boxWidth, height: boxWidth))
        
        checkBoxView = CheckBoxView(frame: boxRect, selected: true)
        checkBoxView.isHidden = !isSelected
        
        self.selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = UIColor.green
        
        self.addSubview(checkBoxView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        whiteLayer?.removeFromSuperlayer()
        whiteLayer = nil
        isUserInteractionEnabled = true
    }
    
}
