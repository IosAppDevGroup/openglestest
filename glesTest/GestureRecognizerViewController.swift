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
   
    fileprivate func initGestureRecognizer(){
        
        // pinch
        self.view.isMultipleTouchEnabled = true
        self.view.isUserInteractionEnabled = true
        pinchRec.addTarget(self, action: #selector(GestureRecognizerViewController.onPinchEvent(_:)))
//        self.view.addGestureRecognizer(pinchRec)
        
        pinchView.isMultipleTouchEnabled = true
        pinchView.isUserInteractionEnabled = true
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
    @IBAction func dismis(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPinchEvent(_ sender: UIPinchGestureRecognizer){
       print("onPinchEvent sender = \(sender)")
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer){
        print(" onTap sender =\(sender)")
    }
}
