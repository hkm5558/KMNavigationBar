//
//  UINavigationController+KMNaviagtionBar.swift
//  KMNavigationBarDemo
//
//  Created by KM on 2019/10/22.
//  Copyright © 2019 KM. All rights reserved.
//

import UIKit

public extension UINavigationController {
    typealias SettingNavigation = ((KMNavigationBarOption) -> Void)
    /// init with preference option
    convenience init(preference: SettingNavigation?) {
        self.init(viewControllers: [], toolbarClass: nil, preference: preference)
    }
    
    /// init with rootViewController and preference option
    convenience init(rootViewController: UIViewController, preference: SettingNavigation?) {
        self.init(viewControllers: [rootViewController], toolbarClass: nil, preference: preference)
    }
    
    /// init with viewControllers and preference option
    convenience init(viewControllers: [UIViewController], preference: SettingNavigation?) {
        self.init(viewControllers: viewControllers, toolbarClass: nil, preference: preference)
    }
    
    /// init with viewControllers, toolbarClass and preference option
    convenience init(viewControllers: [UIViewController], toolbarClass: AnyClass?, preference: SettingNavigation?) {
        // init
        self.init(navigationBarClass: KMNavigationBar.self, toolbarClass: toolbarClass)
        
        // config
        self.viewControllers = viewControllers
        preference?(self.preference)
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        (self.navigationBar as? KMNavigationBar)?.preference = self.preference
        _ = self.navigationProxy
    }
}

extension UINavigationController {
    
    public var navigationProxy: KMNaviagtionBarProxy {
        if let proxy: KMNaviagtionBarProxy = associatedObject(for: &UINavigationController.navigationProxyKey) {
            return proxy
        } else {
            let proxy = KMNaviagtionBarProxy(navigationController: self)
            setAssociatedObject(proxy, forKey: &UINavigationController.navigationProxyKey, policy: .retainNonatomic)
            return proxy
        }
    }
    
    var transitionHelper: KMNavigationTransitionHelper {
        if let helper: KMNavigationTransitionHelper = associatedObject(for: &UINavigationController.transitionHelperKey) {
            return helper
        } else {
            let helper = KMNavigationTransitionHelper(navigationController: self)
            setAssociatedObject(helper, forKey: &UINavigationController.transitionHelperKey, policy: .retainNonatomic)
            return helper
        }
    }
    
    public var preference: KMNavigationBarOption {
        if let option: KMNavigationBarOption = associatedObject(for: &UINavigationController.preferenceKey) {
            return option
        } else {
            let option = KMNavigationBarOption.default.option()
            setAssociatedObject(option, forKey: &UINavigationController.preferenceKey, policy: .retainNonatomic)
            return option
        }
    }
    /// preferenceOptionKey
    private static var preferenceKey: Void?
    /// navigationProxyKey
    private static var navigationProxyKey: Void?
    /// transitionHelperKey
    private static var transitionHelperKey: Void?
}
