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
    
    static let green = CheckBoxViewColors(
        ovalColor: UIColor(red: 85/255, green: 185/255, blue: 1/255, alpha: 0.8),
        ovalFrameColor: UIColor.black,
        checkColor: UIColor.white
    )
    static let gray = CheckBoxViewColors(
        ovalColor: UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.2),
        ovalFrameColor: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.3),
        checkColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    )
}

// 参考：http://mashiroyuya.hatenablog.com/entry/2016/03/01/131211
class CheckBoxView: UIView {
    
    private var isSelected = false
    
    convenience init(frame: CGRect, selected: Bool) {
        self.init(frame: frame)
        self.isSelected = selected
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let checkMarkRect = CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10)
        
        let checkBoxViewColors = isSelected ? CheckBoxViewColors.green : CheckBoxViewColors.gray
        
        // 円 -------------------------------------
        let oval = UIBezierPath(ovalIn: checkMarkRect)
        
        // 塗りつぶし色の設定
        checkBoxViewColors.ovalColor.setFill()
        // 内側の塗りつぶし
        oval.fill()
        //枠の色
        checkBoxViewColors.ovalFrameColor.setStroke()
        //枠の太さ
        oval.lineWidth = 2
        // 描画
        oval.stroke()
        
        let xx = checkMarkRect.origin.x
        let yy = checkMarkRect.origin.y
        let width = checkMarkRect.width
        let height = checkMarkRect.height
        
        // チェックマークの描画 ----------------------
        let checkmark = UIBezierPath()
        //起点
        checkmark.move(to: CGPoint(x: xx + width / 6, y: yy + height / 2))
        //帰着点
        checkmark.addLine(to: CGPoint(x: xx + width / 3, y: yy + height * 7 / 10))
        checkmark.addLine(to: CGPoint(x: xx + width * 5 / 6, y: yy + height * 1 / 3))
        // 色の設定
        checkBoxViewColors.checkColor.setStroke()
        // ライン幅
        checkmark.lineWidth = 6
        // 描画
        checkmark.stroke()
    }
}
