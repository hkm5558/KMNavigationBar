//
//  KMNavigationBar.swift
//  KMNavigationBarDemo
//
//  Created by KM on 2018/6/1.
//  Copyright © 2018年 KM. All rights reserved.
//

import UIKit

class KMNavigationBar: UINavigationBar {

    internal var preference: KMNavigationBarOption?

    /// isBackgroundFakeBarHidden
    var isBackgroundFakeBarHidden: Bool {
        get { return self.fakeBar.isHidden }
        set {
            self.fakeBar.isHidden = newValue
        }
    }

    // MARK: ---------------- private ----------------
    /// _tintColor
    private var _tintColor: UIColor = KMNavigationBarOption.default.tintColor {
        didSet { self.tintColor = self._tintColor }
    }

    /// _barStyle
    private var _barStyle: UIBarStyle = KMNavigationBarOption.default.isWhiteBarStyle ? .black : .default {
        didSet { self.barStyle = self._barStyle }
    }

    /// _alpha
    private var _alpha: CGFloat = KMNavigationBarOption.default.alpha {
        didSet { self.alpha = self._alpha }
    }

    /// _option
    private var _option: KMNavigationBarOption?
    
    /// FakeBar
    private lazy var fakeBar = KMFakeBarView()

    private lazy var fromFakeBar = KMFakeBarView()

    private lazy var toFakeBar = KMFakeBarView()

    private var fromViewController: UIViewController?

    private var toViewController: UIViewController?

    private var displayLink: CADisplayLink?

    // MARK: ---------------- override ----------------
    // MARK: - For override system logic
    /// tintColor
    override var tintColor: UIColor! {
        get { return super.tintColor }
        set { super.tintColor = self._tintColor }
    }

    /// barStyle
    override var barStyle: UIBarStyle {
        get { return super.barStyle }
        set { super.barStyle = self._barStyle }
    }

    /// alpha
    override var alpha: CGFloat {
        get { return super.alpha }
        set { super.alpha = self._alpha }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        displayLink = CADisplayLink(target: self, selector: #selector(refreshDisplay))
//        displayLink?.frameInterval = 2
        displayLink?.add(to: .main, forMode: .common)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let bgView = self.findBackgroundView() else {
            return
        }
        bgView.backgroundColor = .clear
        fakeBar.frame = bgView.bounds
    }
}
extension KMNavigationBar {
 
    func updateToOption(_ toOption: KMNavigationBarOption) {
        self._option = toOption
        fakeBar.updateToOption(toOption, preference: preference)
        
        let toTintColor = toOption._tintColor
            ?? preference?._tintColor
            ?? KMNavigationBarOption.default.tintColor
        self._tintColor = toTintColor
        
        let toIsWhiteBarStyle = toOption._isWhiteBarStyle
            ?? preference?._isWhiteBarStyle
            ?? KMNavigationBarOption.default.isWhiteBarStyle
        if toIsWhiteBarStyle {
            self._barStyle = .black
        } else {
            self._barStyle = .default
        }
        
        let toAlpha = toOption._alpha
            ?? preference?._alpha
            ?? KMNavigationBarOption.default.alpha
        self._alpha = toAlpha
        
        removeWhiteCoverWhenNotTranslucent()
    }
}
extension KMNavigationBar {

    func removeTransitionFakeBar() {
        self.fromFakeBar.removeFromSuperview()
        self.toFakeBar.removeFromSuperview()
    }

    func addFromFakeBar(to fromVc: UIViewController) {
        fromViewController = fromVc
        addFakeBar(fake: fromFakeBar, to: fromVc)
    }

    func addToFakeBar(to toVc: UIViewController) {
        toViewController = toVc
        addFakeBar(fake: toFakeBar, to: toVc)
    }

    /// add fakeBar to viewController
    private func addFakeBar(fake: KMFakeBarView, to vc: UIViewController) {
        
        guard let preference = self.preference else { return }
        let option = vc.navigationBarHelper.option
        UIView.performWithoutAnimation {
            removeWhiteCoverWhenNotTranslucent()
            // set option
            fake.updateToOption(vc.navigationBarHelper.option, preference: preference)
            if vc.view.isKind(of: UIScrollView.self) || vc.edgesForExtendedLayout == UIRectEdge(rawValue: 0) {
                vc.view.clipsToBounds = false
            }
            
            // 因为这里的FakeBar加在控制器视图上 不是加在导航栏上
            // 还要考虑原来导航栏的透明度
            let alpha = option._alpha ?? preference._alpha ?? KMNavigationBarOption.default.alpha
            let backgroundAlpha = option._backgroundAlpha ?? preference._backgroundAlpha ?? KMNavigationBarOption.default.backgroundAlpha
            let shadowImageAlpha = option._shadowImageAlpha ?? preference._shadowImageAlpha ?? KMNavigationBarOption.default.shadowImageAlpha
            
            fake.contentView.alpha = alpha * backgroundAlpha
            fake.shadowImageView.alpha = alpha * shadowImageAlpha

            // add subview
            vc.view.addSubview(fake)
        }
    }
}

private extension KMNavigationBar {
    
    func findBackgroundView() -> UIView? {
        return subviews.first(where: {
            $0.isUIbarBackGround() || $0.isUINavigationBarBackground()
        })
    }
    
    func removeWhiteCoverWhenNotTranslucent() {
        guard isTranslucent == false else {
            return
        }
        hideOtherColorView(true)
    }
    
    func recoverWhiteCoverWhenNotTranslucentt() {
        guard isTranslucent == false else {
            return
        }
        hideOtherColorView(false)
    }
    
    func hideOtherColorView(_ hide: Bool) {
        fakeBar.superview?.subviews.filter({
            $0 != fakeBar
        }).forEach({
            if let _ = $0.backgroundColor {
                $0.isHidden = hide
            }
        })
    }

    @objc func refreshDisplay() {
        if let barSuperView = fakeBar.superview {
            let rect = barSuperView.bounds
            if !fakeBar.frame.equalTo(rect) {
                fakeBar.frame = rect
            }

            if fromFakeBar.superview != nil,
                let fromVc = fromViewController {
                var fakeFrame = barSuperView.convert(rect, to: fromVc.view)
                if !fakeFrame.equalTo(fromFakeBar.frame) {
                    fakeFrame.origin.x = fakeBar.frame.origin.x
                    fromFakeBar.frame = fakeFrame
                }
            }
            if toFakeBar.superview != nil,
                let toVc = toViewController {
                var fakeFrame = barSuperView.convert(rect, to: toVc.view)
                if !fakeFrame.equalTo(toFakeBar.frame) {
                    fakeFrame.origin.x = fakeBar.frame.origin.x
                    toFakeBar.frame = fakeFrame
                }
            }
        }

        guard self.fakeBar.superview == nil else { return }
        guard let bgView = self.findBackgroundView() else {
            return
        }
        bgView.insertSubview(self.fakeBar, at: 0)
    }
}

fileprivate class KMFakeBarView: UIView {

    lazy var effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    lazy var colorView = UIView()

    lazy var backgroundImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleToFill
        return imageV
    }()

    lazy var shadowImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.backgroundColor = .black
        return imageV
    }()
    
    lazy var contentView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = .clear
        self.addSubview(contentView)
        self.addSubview(shadowImageView)
        [effectView, backgroundImageView, colorView].forEach {
            $0.isUserInteractionEnabled = false
            $0.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
            contentView.addSubview($0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
        effectView.frame = contentView.bounds
        backgroundImageView.frame = contentView.bounds
        colorView.frame = contentView.bounds
        
        let shadowImageH = 1.0 / UIScreen.main.scale
        shadowImageView.frame = CGRect(
            x: 0,
            y: self.bounds.height - shadowImageH,
            width: self.bounds.width,
            height: shadowImageH
        )
    }

    /// update to option
    func updateToOption(_ toOption: KMNavigationBarOption, preference: KMNavigationBarOption?) {
        self.effectView.isHidden = true
        self.backgroundImageView.isHidden = true
        self.colorView.isHidden = true
        let backgroundEffect = toOption.backgroundEffect
            ?? preference?.backgroundEffect
            ?? KMNavigationBarOption.default.backgroundEffect
        switch backgroundEffect {
        case .blur(let b):
            self.effectView.effect = UIBlurEffect(style: b)
            self.effectView.isHidden = false
        case .image(let i, let c):
            self.backgroundImageView.image = i
            self.backgroundImageView.contentMode = c
            self.backgroundImageView.isHidden = false
        case .color(let c):
            self.colorView.backgroundColor = c
            self.colorView.isHidden = false
        }
        
        // backgroundAlpha
        let toBackgroundAlpha = toOption._backgroundAlpha
            ?? preference?._backgroundAlpha
            ?? KMNavigationBarOption.default.backgroundAlpha
        contentView.alpha = toBackgroundAlpha

        // shadowImageAlpha
        let toShadowImageAlpha = toOption._shadowImageAlpha
            ?? preference?._shadowImageAlpha
            ?? KMNavigationBarOption.default.shadowImageAlpha
        shadowImageView.alpha = toShadowImageAlpha
    }
}

fileprivate extension UIView {
    func convertClassName() -> String {
        return self.classForCoder.description().replacingOccurrences(of: "_", with: "")
    }
    func isUIbarBackGround() -> Bool {
        let viewClassName = convertClassName()
        return viewClassName.contains("UIbarBackground")
            || viewClassName.contains("UIBarBackground")
        
    }
    func isUINavigationBarBackground() -> Bool {
        let viewClassName = convertClassName()
        return viewClassName.contains("UINavigationBarBackground")
    }
}
