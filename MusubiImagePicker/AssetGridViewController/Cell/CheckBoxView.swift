//
//  CheckBoxView.swift
//  MusubiImagePicker
//
//  Created by はるふ on 2016/11/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

struct CheckBoxViewColors {
    let ovalColor: UIColor
    let ovalFrameColor: UIColor
    let checkColor: UIColor
    
    static let defaultActiveColor = CheckBoxViewColors(
        ovalColor: UIColor(red: 85/255, green: 185/255, blue: 1/255, alpha: 0.8),
        ovalFrameColor: UIColor.black,
        checkColor: UIColor.white
    )
    static let defaultNegativeColor = CheckBoxViewColors(
        ovalColor: UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.2),
        ovalFrameColor: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.3),
        checkColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    )
}

/// 参考：http://mashiroyuya.hatenablog.com/entry/2016/03/01/131211
class CheckBoxView: UIView {
    
    var isActive = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    convenience init(frame: CGRect, isActive: Bool) {
        self.init(frame: frame)
        self.isActive = isActive
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let checkMarkRect = CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10)
        
        let checkBoxViewColors = isActive ? CheckBoxViewColors.defaultActiveColor : CheckBoxViewColors.defaultNegativeColor
        
        // Draw Circle
        let oval = UIBezierPath(ovalIn: checkMarkRect)
        checkBoxViewColors.ovalColor.setFill()
        oval.fill()
        checkBoxViewColors.ovalFrameColor.setStroke()
        oval.lineWidth = 2
        oval.stroke()
        
        // Draw checkmark
        let startPoint = CGPoint(x: checkMarkRect.origin.x + checkMarkRect.width / 6,
                                 y: checkMarkRect.origin.y + checkMarkRect.height / 2)
        let turnPoint = CGPoint(x: checkMarkRect.origin.x + checkMarkRect.width / 3,
                                y: checkMarkRect.origin.y + checkMarkRect.height * 7 / 10)
        let endPoint = CGPoint(x: checkMarkRect.origin.x + checkMarkRect.width * 5 / 6,
                               y: checkMarkRect.origin.y + checkMarkRect.height * 1 / 3)
        
        let checkmark = UIBezierPath()
        checkmark.move(to: startPoint)
        checkmark.addLine(to: turnPoint)
        checkmark.addLine(to: endPoint)
        
        checkBoxViewColors.checkColor.setStroke()
        checkmark.lineWidth = 5
        checkmark.stroke()
    }
}
