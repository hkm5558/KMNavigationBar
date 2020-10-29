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

    deinit {
        debugPrint(classForCoder.description(), #function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        navigationItem.title = "ViewController"

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

        let button = UIButton(type: .custom)
        button.frame = .init(x: 0, y: 0, width: 44, height: 44)
        button.setTitle("present", for: .normal)
        button.addTarget(self, action: #selector(presentNextViewController), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func presentNextViewController() {
        let vc = AppDelegate.shared!.mainVc!
        let navVc = UINavigationController(rootViewController: vc, preference: nil)
        navVc.modalPresentationStyle = .fullScreen
        self.present(navVc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        debugPrint(self, #function)
    }
}
