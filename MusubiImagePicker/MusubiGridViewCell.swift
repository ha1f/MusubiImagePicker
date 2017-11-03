//
//  MusubiGridViewCell.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/11/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class MusubiGridViewCell: GridViewCell {
    
    static let selectedBackgroundColor = UIColor.green
    static let whiteLayerColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
    
    private lazy var checkBoxView: CheckBoxView = {
        return CheckBoxView(frame: CGRect.zero, isActive: true)
    }()
    
    private var whiteLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    private func setupWhiteLayer() {
        whiteLayer?.removeFromSuperlayer()
        let layer = CALayer()
        layer.frame = self.bounds
        layer.backgroundColor = MusubiGridViewCell.whiteLayerColor.cgColor
        self.layer.addSublayer(layer)
        whiteLayer = layer
    }
    
    private func removeWhiteLayer() {
        whiteLayer?.removeFromSuperlayer()
        whiteLayer = nil
    }
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            if isUserInteractionEnabled {
                removeWhiteLayer()
            } else {
                setupWhiteLayer()
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            _updateCheckbox()
            if oldValue != isSelected {
                // 変化あったときのみアニメーション
                if isSelected {
                    UIView.animate(withDuration: 0.05, animations: { [weak imageView = self.imageView] in
                        imageView?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.03) {[weak imageView = self.imageView] in
                                imageView?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                            }
                    })
                } else {
                    UIView.animate(withDuration: 0.03, animations: { [weak imageView = self.imageView] in
                        imageView?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.05) {[weak imageView = self.imageView] in
                                imageView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            }
                    })
                }
            }
        }
    }
    
    private func _updateCheckbox() {
        checkBoxView.isActive = isSelected
        checkBoxView.isHidden = !isSelected
    }
    
    private func _commonInit() {
        let boxWidth = frame.width * 0.5
        let boxRect = CGRect(origin: .zero, size: CGSize(width: boxWidth, height: boxWidth))
        
        if !self.subviews.contains(checkBoxView) {
            self.addSubview(checkBoxView)
        }
        
        checkBoxView.frame = boxRect
        _updateCheckbox()
        
        self.selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = MusubiGridViewCell.selectedBackgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeWhiteLayer()
        isUserInteractionEnabled = true
        isSelected = false
    }
    
}
