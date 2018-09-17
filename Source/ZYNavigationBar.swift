//
//  ZYNavigationBar.swift
//  ZYNavigationBar
//
//  Created by yu zhou on 11/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

public class ZYNavigationBar: UINavigationBar {
    var shadowImageView: UIImageView = {
        let v = UIImageView()
        v.isUserInteractionEnabled = false
        v.contentScaleFactor = 1
        v.tag = 1
        return v
    }()
    var backgroundImageView: UIImageView = {
        let v = UIImageView()
        v.isUserInteractionEnabled = false
        v.contentScaleFactor = 1
        v.contentMode = .scaleToFill
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.contentMode = .scaleToFill
        v.tag = 1
        return v
    }()
    
    var fakeView: UIVisualEffectView = {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        v.isUserInteractionEnabled = false
        v.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        v.tag = 1
        return v
    }()
    
    public override var isTranslucent: Bool {
        get{
            return super.isTranslucent
        }set{
            if newValue == false {
                fatalError("isTranslucent must be true")
            }
            super.isTranslucent = true
        }
    }
    
    public override var barTintColor: UIColor? {
        get{
            return self.fakeView.subviews.last?.backgroundColor
        }set{
            self.fakeView.subviews.last?.backgroundColor = newValue//(newValue == nil ? UIColor.clear : newValue)
        }
    }
    
    /// 在swift中重写 shadowImage的get 和set会导致shadowImage始终显示，故此使用didset
    public override var shadowImage: UIImage? {
        willSet{
            self.shadowImageView.image = newValue
        }
        didSet{
            super.shadowImage = UIImage()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        ///layoutSubviews方法中才能得到self.subviews.first，在awakfromxib和init中都是nil
        setupFakeView()
        guard let superViewBounds = self.fakeView.superview?.bounds else { return }
        self.fakeView.frame = superViewBounds
        self.backgroundImageView.frame = superViewBounds
        self.shadowImageView.frame = CGRect(x: 0, y: superViewBounds.height-0.5, width: superViewBounds.width, height: 0.5)
    }
    
    /// 添加fakeView shadowView，bgView到navbar
    func setupFakeView() {
        guard let fsubView = self.subviews.first else { return }
        if self.fakeView.superview == nil{
            fsubView.insertSubview(self.fakeView, at: 0)
            self.fakeView.bounds = (self.fakeView.superview?.bounds)!
            super.setBackgroundImage(UIImage(), for: .default)
            super.shadowImage = UIImage()
        }
        
        if self.backgroundImageView.superview == nil {
            fsubView.insertSubview(self.backgroundImageView, aboveSubview: self.fakeView)
            self.backgroundImageView.frame = (self.backgroundImageView.superview?.bounds)!
        }
        
        if self.shadowImageView.superview == nil {
            fsubView.insertSubview(self.shadowImageView, aboveSubview: self.backgroundImageView)
            self.shadowImageView.frame = CGRect(x: 0, y: (self.shadowImageView.superview?.bounds.height)!-0.5, width: (self.shadowImageView.superview?.bounds.width)!, height: 0.5)
        }
    }
    
    public override func setBackgroundImage(_ backgroundImage: UIImage?, for barMetrics: UIBarMetrics) {
        self.backgroundImageView.image = backgroundImage
    }

}


