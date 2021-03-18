//
//  CustomButton.swift
//  CustomMusicPlayer
//
//  Created by Nitin Bhatia on 3/17/21.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    @IBInspectable var selectedImageName: String = "" {
        didSet {
            self.setImage(UIImage(named: selectedImageName), for: .selected)
        }
    }
    
    @IBInspectable var normalImageName: String = "" {
        didSet {
            self.setImage(UIImage(named: normalImageName), for: .normal)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = -1 {
           didSet {
               self.layer.cornerRadius = cornerRadius
           }
       }
    
    override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            setupView()
        }
    
    func setupView() {
        self.imageView?.contentMode = .scaleAspectFit
        if selectedImageName != "" {
            self.setImage(UIImage(named: selectedImageName), for: .selected)
        }
        if normalImageName != "" {
            self.setImage(UIImage(named: normalImageName), for: .normal)
        }
        if cornerRadius != -1 {
            self.layer.cornerRadius = cornerRadius
        }
        self.layer.cornerRadius = self.frame.height / 2
    }
}

class CustomButtonRightImage: UIButton {
    
    override func awakeFromNib() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        if imageView != nil {
            if AppUtility.isPad() {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - 35), bottom: 0, right: 5)
            } else {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - 28), bottom: 0, right: 0)
            }
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}


@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var topAlpha: CGFloat = 1 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomAlpha: CGFloat = 1 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.withAlphaComponent(topAlpha).cgColor, bottomColor.withAlphaComponent(bottomAlpha).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

@IBDesignable
class GradientCircleView: GradientView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
