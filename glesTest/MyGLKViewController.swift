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
    
    private var cube:Cube? = nil
    private var triangle: Triangle? = nil
    var glContext: EAGLContext?  = nil
    var pinchRecognizer: UIPinchGestureRecognizer? = nil
    
    override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection? {
        return super.overrideTraitCollectionForChildViewController(childViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredFramesPerSecond = 60;

        initGestureRecognizer()
        prepareGLContext()
        
        //cube = Cube()
    }


    // MARK: private function
    private func initGestureRecognizer(){
        pinchRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(MyGLKViewController.onPinchEvent(_:)))
        self.view.addGestureRecognizer(pinchRecognizer!)
        
    }
    
    @IBAction func onPinchEvent(pinchRecognizer: UIPinchGestureRecognizer){
        print("onPinchEvent\n")
    }

    private func prepareGLContext(){
        let v = self.view as! GLKView
    
        glContext = createEAGLContext()
        
        v.context = glContext!
        v.drawableColorFormat = GLKViewDrawableColorFormat.RGBA8888
        v.drawableDepthFormat = GLKViewDrawableDepthFormat.Format24
        v.drawableStencilFormat = GLKViewDrawableStencilFormat.Format8
        v.drawableMultisample = GLKViewDrawableMultisample.Multisample4X
        
    }
    
    private func createEAGLContext() -> EAGLContext{
        if let context = EAGLContext.init(API: EAGLRenderingAPI.OpenGLES3) {
            return context
        }
        else {
            return EAGLContext.init(API: EAGLRenderingAPI.OpenGLES2)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(" viewWillAppear ");
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print(" viewWillTransitionToSize = \(size)")
        cube?.updateViewSize(Float(size.width), h: Float(size.height))
    }

    // MARK: Actions
    @IBAction func disMiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        //cube!.draw(view, drawInRect:rect)
//        if triangle == nil {
//            triangle = Triangle()
//        }
        if( cube == nil) {
            cube = Cube(width: Float(rect.width), height: Float(rect.height))
        }
        cube!.draw(view, drawInRect: rect)
        //triangle!.draw()
        //glContext!.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
}