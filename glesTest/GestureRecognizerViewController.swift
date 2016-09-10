//
//  GestureRecognizerViewController.swift
//  glesTest
//
//  Created by Flonly on 9/9/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import UIKit

class GestureRecognizerViewController: UIViewController {
    
    @IBOutlet weak var pinchView: UIView!
    
    var pinchRec = UIPinchGestureRecognizer()
    var tapRec = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initGestureRecognizer()
    }
   
    private func initGestureRecognizer(){
        
        // pinch
        self.view.multipleTouchEnabled = true
        self.view.userInteractionEnabled = true
        pinchRec.addTarget(self, action: #selector(GestureRecognizerViewController.onPinchEvent(_:)))
        self.view.addGestureRecognizer(pinchRec)
        
        pinchView.multipleTouchEnabled = true
        pinchView.userInteractionEnabled = true
        pinchView.addGestureRecognizer(pinchRec)
       
        
        // tap
//        tapRec.addTarget(self, action: #selector(GestureRecognizerViewController.onTap(_:)))
//        tapRec.numberOfTapsRequired = 1
//        pinchView.userInteractionEnabled = true
//        // pinchView.multipleTouchEnabled = true
//        pinchView.addGestureRecognizer(tapRec)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
//        pinchView.addGestureRecognizer(tap)
    }
    
    // MARK: IBActions
    @IBAction func dismis(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onPinchEvent(sender: UIPinchGestureRecognizer){
       print("onPinchEvent sender = \(sender)")
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer){
        print(" onTap sender =\(sender)")
    }
}
