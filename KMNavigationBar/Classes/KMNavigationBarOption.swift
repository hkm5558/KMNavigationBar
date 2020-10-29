//
//  KMNavigationBarOption.swift
//  KMNavigationBarDemo
//
//  Created by KM on 2019/10/22.
//  Copyright © 2019 KM. All rights reserved.
//

import UIKit

public class KMNavigationBarOption {

    public struct `default` {
        static var backgroundEffect: KMNavigationBarOption.Effect = .blur(.light)
        static var backgroundAlpha: CGFloat = 1
        static var tintColor: UIColor = .black
        static var isWhiteBarStyle: Bool = false
        static var shadowImageAlpha: CGFloat = 0.5
        static var alpha: CGFloat = 1
        static func option() -> KMNavigationBarOption {
            let op = KMNavigationBarOption()
            op.backgroundEffect = `default`.backgroundEffect
            op.backgroundAlpha = `default`.backgroundAlpha
            op.tintColor = `default`.tintColor
            op.isWhiteBarStyle = `default`.isWhiteBarStyle
            op.shadowImageAlpha = `default`.shadowImageAlpha
            op.alpha = `default`.alpha
            return op
        }
    }

    /// set navigationBar.fakeBar's backgroundEffect, default: .blur(.light)
    public var backgroundEffect: KMNavigationBarOption.Effect? {
        get { return self._backgroundEffect }
        set { self._backgroundEffect = newValue }
    }

    /// set navigationBar.fakeBar's backgroundAlpha, default: 1
    public var backgroundAlpha: CGFloat? {
        get { return self._backgroundAlpha }
        set {
            if let nv = newValue {
                if nv > 1 {
                    self._backgroundAlpha = 1
                } else if nv < 0 {
                    self._backgroundAlpha = 0
                } else {
                    self._backgroundAlpha = nv
                }
            } else {
                self._backgroundAlpha = nil
            }
        }
    }

    /// set navigationBar's tintColor, default: black
    public var tintColor: UIColor? {
        get { return self._tintColor }
        set { self._tintColor = newValue }
    }

    /// set navigationBar's isWhiteBarStyle, default: false
    public var isWhiteBarStyle: Bool? {
        get { return self._isWhiteBarStyle }
        set { self._isWhiteBarStyle = newValue }
    }

    /// set navigationBar's shadowImageAlpha, default: 0.5
    public var shadowImageAlpha: CGFloat? {
        get { return self._shadowImageAlpha }
        set {
            if let nv = newValue {
                if nv > 1 {
                    self._shadowImageAlpha = nv
                } else if nv < 0 {
                    self._shadowImageAlpha = 0
                } else {
                    self._shadowImageAlpha = nv
                }
            } else {
                self._shadowImageAlpha = nil
            }
        }
    }

    /// set navigationBar's alpha, default: 1
    public var alpha: CGFloat? {
        get { return self._alpha }
        set {
            if let nv = newValue {
                if nv > 1 {
                    self._alpha = 1
                } else if nv < 0 {
                    self._alpha = 0
                } else {
                    self._alpha = nv
                }
            } else {
                self._alpha = nil
            }
        }
    }

    // MARK: - Internal
    var _backgroundEffect: KMNavigationBarOption.Effect?
    var _backgroundAlpha: CGFloat?
    var _tintColor: UIColor?
    var _isWhiteBarStyle: Bool?
    var _shadowImageAlpha: CGFloat?
    var _alpha: CGFloat?

    /// init
    internal init() { }
}

extension KMNavigationBarOption: NSCopying, NSMutableCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return copyObj()
    }
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        return copyObj()
    }
    private func copyObj() -> KMNavigationBarOption {
        let model = KMNavigationBarOption()

        model._backgroundEffect = self._backgroundEffect
        model._backgroundAlpha = self._backgroundAlpha
        model._tintColor = self._tintColor
        model._isWhiteBarStyle = self._isWhiteBarStyle
        model._shadowImageAlpha = self._shadowImageAlpha
        model._alpha = self._alpha
        
        model.backgroundEffect = self.backgroundEffect
        model.backgroundAlpha = self.backgroundAlpha
        model.tintColor = self.tintColor
        model.isWhiteBarStyle = self.isWhiteBarStyle
        model.shadowImageAlpha = self.shadowImageAlpha
        model.alpha = self.alpha

        return model
    }
}

extension KMNavigationBarOption {
    static func isSameOption(lhs: KMNavigationBarOption, rhs: KMNavigationBarOption, preference: KMNavigationBarOption) -> Bool {
        // alpha
        let alphaL = lhs._alpha
            ?? preference._alpha
            ?? KMNavigationBarOption.default.alpha
        let alphaR = rhs._alpha
            ?? preference._alpha
            ?? KMNavigationBarOption.default.alpha

        // backgroundEffect
        let backgroundEffectL = lhs._backgroundEffect
            ?? preference._backgroundEffect
            ?? KMNavigationBarOption.default.backgroundEffect
        let backgroundEffectR = rhs._backgroundEffect
            ?? preference._backgroundEffect
            ?? KMNavigationBarOption.default.backgroundEffect

        // backgroundAlpha
        let backgroundAlphaL = lhs._backgroundAlpha
            ?? preference._backgroundAlpha
            ?? KMNavigationBarOption.default.backgroundAlpha
        let backgroundAlphaR = rhs._backgroundAlpha
            ?? preference._backgroundAlpha
            ?? KMNavigationBarOption.default.backgroundAlpha

        let isSameAlpha = alphaL == alphaR
        let isSameEffect = backgroundEffectL == backgroundEffectR
        let isSameBackgroundAlpha = backgroundAlphaL == backgroundAlphaR

        // check is same option
        return isSameAlpha && isSameEffect && isSameBackgroundAlpha
    }
}

/// KMNavigationBarOption (Effect)
public extension KMNavigationBarOption {

    /// Effect
    enum Effect: Equatable {

        /// blur effect
        case blur(UIBlurEffect.Style)

        /// image
        case image(UIImage?, UIView.ContentMode)

        /// color
        case color(UIColor)

        /// ==
        public static func == (lhs: Effect, rhs: Effect) -> Bool {
            if case .blur(let styleL) = lhs, case .blur(let styleR) = rhs {
                return styleL == styleR
            }
            else if case .image(let imageL, let modeL) = lhs, case .image(let imageR, let modeR) = rhs {
                return imageL?.pngData() == imageR?.pngData() && modeL == modeR
            }
            else if case .color(let colorL) = lhs, case .color(let colorR) = rhs {
                return colorL == colorR
            }
            else {
                return false
            }
        }
    }
}
