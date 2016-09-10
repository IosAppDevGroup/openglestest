//
//  ViewController.swift
//  glesTest
//
//  Created by Flonly on 5/25/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var pinchRecognizer: UIPinchGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGestureRecognizer()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initGestureRecognizer(){
        
        print( " self.view.userInteractionEnabled = \(self.view.userInteractionEnabled)")
        print("self.view.multipleTouchEnabled  = \(self.view.multipleTouchEnabled)")
        self.view.userInteractionEnabled = true
        self.view.multipleTouchEnabled = true
        
    }
    
    // MARK: gesture recognizer's handlers
    @IBAction func onPinchEvent(sender: UIPinchGestureRecognizer) {
        print(" ViewController onPinchEvent \n")
    }
}

