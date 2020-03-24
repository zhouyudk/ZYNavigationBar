//
//  ZYNavigationController.swift
//  ZYNavigationBar
//
//  Created by yu zhou on 11/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

public class ZYNavigationController: UINavigationController {
    var inGesture = false
    
    var fromFakeBar: UIVisualEffectView =  {
        return UIVisualEffectView(effect: UIBlurEffect.init(style: .light))
    }()
    var toFakeBar: UIVisualEffectView = {
        return UIVisualEffectView(effect: UIBlurEffect.init(style: .light))
    }()
    var fromFakeImageView: UIImageView = {
       return UIImageView()
    }()
    var toFakeImageView: UIImageView = {
        return UIImageView()
    }()
    lazy var fromFakeShadow: UIImageView = {
        let v = UIImageView(image: self.zy_navigationBar.shadowImageView.image)
        v.backgroundColor = self.zy_navigationBar.shadowImageView.backgroundColor
        return v
    }()
    lazy var toFakeShadow: UIImageView = {
        let v = UIImageView(image: self.zy_navigationBar.shadowImageView.image)
        v.backgroundColor = self.zy_navigationBar.shadowImageView.backgroundColor
        return v
    }()
    
    var zy_navigationBar: ZYNavigationBar {
        return self.navigationBar as! ZYNavigationBar
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: ZYNavigationBar.classForCoder(), toolbarClass: nil)
        super.viewControllers = [rootViewController]
    }
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        guard let isSubclass = navigationBarClass?.isSubclass(of: ZYNavigationBar.self), isSubclass == true else {
            fatalError("navigationBarClass must be ZYNavigationBar")
        }
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }

    public init() {
        super.init(navigationBarClass: ZYNavigationBar.self, toolbarClass: nil)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGesture(recognizer:)))
        self.delegate = self
        self.zy_navigationBar.isTranslucent = true
        self.zy_navigationBar.shadowImageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func fakeBarFrameForViewController(_ vc:UIViewController) -> CGRect {
        let backgroundFrame = self.zy_navigationBar.subviews.first!.frame
        var frame = self.zy_navigationBar.convert(backgroundFrame, to: vc.view)
        frame.origin.x = vc.view.frame.origin.x
        if vc.view.isKind(of: UIScrollView.self) {
            frame.origin.y = -(UIScreen.main.bounds.height == 812.0 ? 88 : 64)
        }
        return frame
    }
    
    func fakeShadowFrameWithBarFrame(frame:CGRect) -> CGRect {
        return CGRect(x: frame.origin.x, y: frame.height+frame.origin.y-0.5, width: frame.width, height: 0.5)
    }

    func removeFakeView() {
        fromFakeBar.removeFromSuperview()
        fromFakeShadow.removeFromSuperview()
        fromFakeImageView.removeFromSuperview()
        toFakeShadow.removeFromSuperview()
        toFakeBar.removeFromSuperview()
        toFakeImageView.removeFromSuperview()
    }
    
    func updateNavigationBarForViewController(controller:UIViewController) {
        self.updateNavigationBarAnimatedForController(controller)
        self.updateNavigationBarAlphaForViewController(controller)
        self.updateNavigationBarShadowAlphaForViewController(controller)
        self.updateNavigationBarColorOrImageForViewController(controller)
    }
    
    /// update target controller barStyle
    ///
    /// - Parameter controller: targetController
    func updateNavigationBarAnimatedForController(_ controller:UIViewController) {
        self.zy_navigationBar.barStyle = controller.zy_barStyle
        self.zy_navigationBar.titleTextAttributes = controller.zy_titleTextAttributes
        self.zy_navigationBar.tintColor = controller.zy_tintColor
    }
    
    /// update target controller barAlpha and shadowAlpha
    ///
    /// - Parameter controller:
    func updateNavigationBarAlphaForViewController(_ controller:UIViewController) {
        if controller.zy_computedBarImage != nil {
            self.zy_navigationBar.fakeView.alpha = 0
            self.zy_navigationBar.backgroundImageView.alpha = controller.zy_barAlpha
        } else {
            self.zy_navigationBar.fakeView.alpha = controller.zy_barAlpha
            self.zy_navigationBar.backgroundImageView.alpha = 0
        }
        self.zy_navigationBar.shadowImageView.alpha = controller.zy_computedBarShadowAlpha
    }
    
    func updateNavigationBarColorOrImageForViewController(_ controller:UIViewController) {
        self.zy_navigationBar.barTintColor = controller.zy_computedBarTintColor
        self.zy_navigationBar.backgroundImageView.image = controller.zy_computedBarImage
    }
    
    func updateNavigationBarShadowAlphaForViewController(_ controller:UIViewController) {
        self.zy_navigationBar.shadowImageView.alpha = controller.zy_computedBarShadowAlpha
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        guard let vc = self.topViewController else { return nil }
        let pVC = super.popViewController(animated: animated)
        self.zy_navigationBar.barStyle = vc.zy_barStyle
        self.zy_navigationBar.titleTextAttributes = vc.zy_titleTextAttributes
        return pVC
    }
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let vc = self.topViewController else { return nil }
        let pVC = super.popToRootViewController(animated: animated)
        self.zy_navigationBar.barStyle = vc.zy_barStyle
        self.zy_navigationBar.titleTextAttributes = vc.zy_titleTextAttributes
        return pVC
    }
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard let vc = self.topViewController else { return nil }
        let pVCs = super.popToViewController(viewController, animated: animated)
        self.zy_navigationBar.barStyle = vc.zy_barStyle
        self.zy_navigationBar.titleTextAttributes = vc.zy_titleTextAttributes
        return pVCs
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ZYNavigationController:UIGestureRecognizerDelegate {
    @objc func handlePopGesture(recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let coordinator = self.transitionCoordinator,
              let fromVC = coordinator.viewController(forKey: .from),
              let toVC = coordinator.viewController(forKey: .to)
        else { return }
        
        if recognizer.state == .began || recognizer.state == .changed {
            self.inGesture = true
            self.zy_navigationBar.tintColor = self.blendColor(from: fromVC.zy_tintColor, to: toVC.zy_tintColor, percent: coordinator.percentComplete)
        }else{
            self.inGesture = false
        }
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let vc = self.topViewController else { return false}
        return self.viewControllers.count > 1 ? (vc.zy_backInteractive && vc.zy_swipeBackEnabled) : false
    }
}

// MARK: - UINavigationControllerDelegate
extension ZYNavigationController: UINavigationControllerDelegate{
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let coordinator = self.transitionCoordinator,
            let fromVC = coordinator.viewController(forKey: .from),
            let toVC = coordinator.viewController(forKey: .to)
            else { self.updateNavigationBarForViewController(controller: viewController); return }
        
        coordinator.animate(alongsideTransition: { (context) in
            guard self.shouldShowFake(vc: viewController, from: fromVC, to: toVC) else { return }
            self.updateNavigationBarAnimatedForController(viewController)
            UIView.performWithoutAnimation {
                self.zy_navigationBar.fakeView.alpha = 0
                self.zy_navigationBar.shadowImageView.alpha = 0
                self.zy_navigationBar.backgroundImageView.alpha = 0
                
                //from
                self.fromFakeImageView.image = fromVC.zy_computedBarImage
                self.fromFakeImageView.alpha = fromVC.zy_barAlpha
                self.fromFakeImageView.frame = self.fakeBarFrameForViewController(fromVC)
                fromVC.view.addSubview(self.fromFakeImageView)

                self.fromFakeBar.subviews.last?.backgroundColor = fromVC.zy_computedBarTintColor
                self.fromFakeBar.alpha = (fromVC.zy_barAlpha == 0 || fromVC.zy_computedBarImage != nil) ? 0.01:fromVC.zy_barAlpha
                self.fromFakeBar.frame = self.fakeBarFrameForViewController(fromVC)
                fromVC.view.addSubview(self.fromFakeBar)

                self.fromFakeShadow.alpha = fromVC.zy_computedBarShadowAlpha
                self.fromFakeShadow.frame = self.fakeShadowFrameWithBarFrame(frame: self.fakeBarFrameForViewController(fromVC))
                fromVC.view.addSubview(self.fromFakeShadow)

//                 //to
                self.toFakeImageView.image = toVC.zy_computedBarImage
                self.toFakeImageView.alpha = toVC.zy_barAlpha
                self.toFakeImageView.frame = self.fakeBarFrameForViewController(toVC)
                toVC.view.addSubview(self.toFakeImageView)

                self.toFakeBar.subviews.last?.backgroundColor = toVC.zy_computedBarTintColor
                self.toFakeBar.alpha = toVC.zy_computedBarImage != nil ? 0 : toVC.zy_barAlpha
                self.toFakeBar.frame = self.fakeBarFrameForViewController(toVC)
                toVC.view.addSubview(self.toFakeBar)

                self.toFakeShadow.alpha = toVC.zy_computedBarShadowAlpha
                self.toFakeShadow.frame = self.fakeShadowFrameWithBarFrame(frame: self.fakeBarFrameForViewController(toVC))
                toVC.view.addSubview(self.toFakeShadow)
            }
        }) { (context) in
            context.isCancelled ? self.updateNavigationBarForViewController(controller: fromVC) : self.updateNavigationBarForViewController(controller: viewController)
            if toVC == viewController {
                self.removeFakeView()
            }
            //解决iOS10及以下，在barIshidden的页面侧滑返回取消时 出现神奇的“...”在navigationBar上
            if #available(iOS 11.0, *){
            }else{
                if context.isCancelled {
                    let buttItemView = self.navigationBar.subviews.filter { (v) -> Bool in
                        return "\(type(of: v))" == "UINavigationItemButtonView"
                    }
                    buttItemView.first?.isHidden = fromVC.zy_barIsHidden
                }
            }
        }
    }
}

// MARK: - UINavigationBarDelegate
extension ZYNavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        guard let topVC = self.topViewController else { return false }
        if self.viewControllers.count > 1 && topVC.navigationItem == item{
            if topVC.zy_backInteractive == false {
                self.resetNavBarSubViews(navBar: self.zy_navigationBar)
                return false
            }
        }
        if !inGesture {
            _ = self.popViewController(animated: true)
        }
        return true
    }
    func resetNavBarSubViews(navBar: UINavigationBar) {
        if #available(iOS 11, *) {
        }else{
            for v in navBar.subviews {
                if v.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        v.alpha = 1
                    })
                }
            }
        }
        
    }
}

// MARK: - Tool
extension ZYNavigationController {
    
    /// 计算两种颜色的中间色
    ///
    /// - Parameters:
    ///   - from: <#from description#>
    ///   - to: <#to description#>
    ///   - percent: <#percent description#>
    /// - Returns: <#return value description#>
    func blendColor(from:UIColor,to:UIColor,percent:CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        let nRed =  fromRed + (toRed - fromRed) * percent
        let nGreen =  fromGreen + (toGreen - fromGreen) * percent
        let nBlue =  fromBlue + (toBlue - fromBlue) * percent
        let nAlpha =  fromAlpha + (toAlpha - fromAlpha) * percent
        
        return UIColor(red: nRed, green: nGreen, blue: nBlue, alpha: nAlpha)
    }
    
    /// 判断navbar的状态是否相同，用于是否进行动画的判断
    ///
    /// - Parameters:
    ///   - vc: <#vc description#>
    ///   - from: <#from description#>
    ///   - to: <#to description#>
    /// - Returns: <#return value description#>
    func shouldShowFake(vc: UIViewController,from: UIViewController, to:UIViewController) -> Bool {
        guard vc == to  else { return false }
        if from.zy_computedBarImage != nil &&
            to.zy_computedBarImage != nil &&
            isEqualImage(from.zy_computedBarImage!, to.zy_computedBarImage!) {
            if abs(from.zy_barAlpha - to.zy_barAlpha) > 0.1 {
                return true
            }
            return false
        }
        
        if from.zy_computedBarImage == nil &&
            to.zy_computedBarImage == nil &&
            from.zy_computedBarTintColor?.description == to.zy_computedBarTintColor?.description {
            if abs(from.zy_barAlpha - to.zy_barAlpha) > 0.1 {
                return true
            }
            return false
        }
        return true
    }
    
    /// 比较两个image是否相同
    ///
    /// - Parameters:
    ///   - image1: <#image1 description#>
    ///   - image2: <#image2 description#>
    /// - Returns: <#return value description#>
    func isEqualImage(_ image1:UIImage,_ image2:UIImage) -> Bool {
        guard image1 != image2 else { return true }
        let data1 = image1.pngData()
        let data2 = image2.pngData()
        
        return data1 == data2
    }
}
