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
        ovalFrameColor: UIColor.white,
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
    
    var indexOfSelection: Int? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    convenience init(frame: CGRect, indexOfSelection: Int? = nil) {
        self.init(frame: frame)
        self.indexOfSelection = indexOfSelection
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let checkMarkRect = CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10)
        
        let checkBoxViewColors = indexOfSelection != nil ? CheckBoxViewColors.defaultActiveColor : CheckBoxViewColors.defaultNegativeColor
        
        // Draw Circle
        let oval = UIBezierPath(ovalIn: checkMarkRect)
        checkBoxViewColors.ovalColor.setFill()
        oval.fill()
        checkBoxViewColors.ovalFrameColor.setStroke()
        oval.lineWidth = 2
        oval.stroke()
        
        if let number = indexOfSelection {
            let nsstring = "\(number + 1)" as NSString
            let fontSize = min(rect.width, rect.height) - 16
            let attributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: checkBoxViewColors.checkColor,
                .paragraphStyle: NSMutableParagraphStyle.default
            ]
            let size = nsstring.size(withAttributes: attributes)
            let point = CGPoint(x: checkMarkRect.origin.x + (checkMarkRect.width - size.width) / 2,
                                y: checkMarkRect.origin.y + (checkMarkRect.height - size.height) / 2)
            nsstring.draw(at: point, withAttributes: attributes)
        }
    }
}
