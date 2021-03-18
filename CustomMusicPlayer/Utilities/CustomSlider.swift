//
//  CustomSlider.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        debugPrint("In Track Rect.")
        return CGRect(x: 0, y: 0, width: bounds.size.width, height: 8) //30
     }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
         debugPrint("In Thumb Rect.")
        return super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
    }
}


@IBDesignable
class RoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}

@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
            didSet {
                self.layer.cornerRadius = cornerRadius
            }
        }
        
        override func awakeFromNib() {
            self.setupView()
        }
        
        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            self.setupView()
        }
        
    func setupView() {
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = cornerRadius
    }
    
}
