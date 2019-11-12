//
//  ViewController.swift
//  KMNavigationBar
//
//  Created by km on 11/05/2019.
//  Copyright (c) 2019 km. All rights reserved.
//

import UIKit
import KMNavigationBar

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if AppDelegate.shared!.isRandomTintColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            self.navigationBarHelper.performUpdate { (op) in
                op.tintColor = color
            }
        }
        
        if AppDelegate.shared!.isRandomBackgroundColor {
            let color = AppDelegate.shared!.colors.randomElement()!
            self.navigationBarHelper.performUpdate { (op) in
                op.backgroundEffect = .color(color)
            }
        }
        if navigationController?.navigationProxy.delegate == nil {
            navigationController?.navigationProxy.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        debugPrint(#function)
    }
}
