//
//  MyGLKViewController.swift
//  glesTest
//
//  Created by Flonly on 5/30/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import Foundation
import GLKit

class MyGLKViewController: GLKViewController {
    override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection? {
        return super.overrideTraitCollectionForChildViewController(childViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredFramesPerSecond = 60;
    }
}