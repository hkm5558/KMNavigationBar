//
//  KMNavigationTransitionHelper.swift
//  KMNavigationBarDemo
//
//  Created by KM on 2019/10/22.
//  Copyright © 2019 KM. All rights reserved.
//

import UIKit

class KMNavigationTransitionHelper: NSObject {
    
    weak var navigationController: UINavigationController?
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func transitionWillShow(viewController: UIViewController) {
        guard  let preference = navigationController?.preference else {
            return
        }
        guard  let bar = navigationController?.navigationBar as? KMNavigationBar else {
                return
        }
        guard  let coordinator = navigationController?.transitionCoordinator else {
            bar.updateToOption(viewController.navigationBarHelper.option)
                return
        }
        coordinator.animate(alongsideTransition: { (ctx) in
            guard   var fromVc = ctx.viewController(forKey: .from),
                    var toVc = ctx.viewController(forKey: .to) else {
                    return
            }

            fromVc = fromVc.excludeNavigationController()
            toVc = toVc.excludeNavigationController()

            let fromOption = fromVc.navigationBarHelper.option
            let toOption = toVc.navigationBarHelper.option
            let isSameOption = KMNavigationBarOption.isSameOption(lhs: fromOption, rhs: toOption, preference: preference)
            if isSameOption == false {
                // add fromFakeBar to fromVc
                bar.addFromFakeBar(to: fromVc)
                
                // add toFakeBar to toVc
                bar.addToFakeBar(to: toVc)
                
                // hidden backgroundFakeBar
                bar.isBackgroundFakeBarHidden = true
            }
                bar.updateToOption(toOption)
        }) { (ctx) in
            if ctx.isCancelled, var fromVc = ctx.viewController(forKey: .from)  {

                fromVc = fromVc.excludeNavigationController()
      
                // rollback navigationBar and fakeBar option if transition is cancelled
                bar.updateToOption(fromVc.navigationBarHelper.option)
            }
            // remove fromFakeBar and toFakeBar from superview
            bar.removeTransitionFakeBar()
            // show fakeBar
            bar.isBackgroundFakeBarHidden = false
        }
    }
}
fileprivate extension UIViewController {
    func excludeNavigationController() -> UIViewController {
        guard let naviVc = self as? UINavigationController, let vc = naviVc.viewControllers.last else { return self }
        return vc
    }
}
