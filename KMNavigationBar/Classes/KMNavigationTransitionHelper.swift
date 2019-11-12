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
        guard   let preference = navigationController?.preference else { return }
        guard   let bar = navigationController?.navigationBar as? KMNavigationBar else {
                return
        }
        guard   let coordinator = navigationController?.transitionCoordinator else {
            bar.updateToOption(viewController.navigationBarHelper.option)
                return
        }
        coordinator.animate(alongsideTransition: { (ctx) in
            guard   let fromVc = ctx.viewController(forKey: .from),
                    let toVc = ctx.viewController(forKey: .to) else {
                    return
            }
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
            if ctx.isCancelled, let fromVc = ctx.viewController(forKey: .from)  {
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
