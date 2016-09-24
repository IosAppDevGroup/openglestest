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
    
    fileprivate var cube:Cube? = nil
    fileprivate var triangle: Triangle? = nil
    var glContext: EAGLContext?  = nil
    var pinchRecognizer: UIPinchGestureRecognizer?
    var panRecognizer: UIPanGestureRecognizer?
    var translateFromPoint : CGPoint = CGPoint()
    
    override func overrideTraitCollection(forChildViewController childViewController: UIViewController) -> UITraitCollection? {
        return super.overrideTraitCollection(forChildViewController: childViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredFramesPerSecond = 60;

        initGestureRecognizer()
        prepareGLContext()
        
        //cube = Cube()
    }

    // MARK: private function
    fileprivate func initGestureRecognizer(){
        
        // pinch
        self.view.isMultipleTouchEnabled = true
        self.view.isUserInteractionEnabled = true
        pinchRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(MyGLKViewController.onPinchEvent(_:)))
        self.view.addGestureRecognizer(pinchRecognizer!)
        
        // pan
        panRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(MyGLKViewController.onPanEvent(_:)))
        panRecognizer?.minimumNumberOfTouches = 1
        self.view.addGestureRecognizer(panRecognizer!)
    }
    
    func onPanEvent(_ panEvent: UIPanGestureRecognizer){
        print("onPanEvent = \(panEvent)\n")
        let currentLocation = panEvent.translation(in: self.view)
        //let velocity = panEvent.velocity(in: self.view)
        let movedVector = CGVector.init(dx: (currentLocation.x - self.translateFromPoint.x) / 100,
                                        dy: (currentLocation.y - self.translateFromPoint.y) / 100 )
        switch panEvent.state {
        case .began:
            translateFromPoint = panEvent.translation(in: self.view)
            break
        case .changed:
            updateTranslate(movedVector, false)
            //updateTranslate(CGVector.init(dx: 0.1, dy: 0.1), true)
            print(" currentLocation = \(currentLocation) movedVector = \(movedVector) velocity =" +
                " \(panEvent.velocity(in: self.view)) view.size = \(view.frame.size)\n")
            break
        case .cancelled:
            break
        case .ended:
            updateTranslate(movedVector, true)
            break
        default:
            break
        }
    }
    
    func onPinchEvent(_ pinchRecognizer: UIPinchGestureRecognizer){
        print("onPinchEvent pinchRecognizer = \(pinchRecognizer)\n")
        
        print("pinchRecognizer.scale = \(pinchRecognizer.scale)\n ")
        if(pinchRecognizer.state == .changed){
            updateScale(pinchRecognizer.scale.native,false)
        } else if (pinchRecognizer.state == .ended){
            updateScale(pinchRecognizer.scale.native,true)
        }
    }
    
    fileprivate func updateTranslate(_ vector: CGVector, _ isKeep: Bool){
       cube?.translate(vector,isKeep)
    }
    
    fileprivate func updateScale(_ scale: Double, _ isKeep: Bool){
        cube?.updateScale(scale, isKeep)
    }
    
    fileprivate func prepareGLContext(){
        let v = self.view as! GLKView
    
        glContext = createEAGLContext()
        
        v.context = glContext!
        v.drawableColorFormat = GLKViewDrawableColorFormat.RGBA8888
        v.drawableDepthFormat = GLKViewDrawableDepthFormat.format24
        v.drawableStencilFormat = GLKViewDrawableStencilFormat.format8
        v.drawableMultisample = GLKViewDrawableMultisample.multisample4X
        
    }
    
    fileprivate func createEAGLContext() -> EAGLContext{
        if let context = EAGLContext.init(api: EAGLRenderingAPI.openGLES3) {
            return context
        }
        else {
            return EAGLContext.init(api: EAGLRenderingAPI.openGLES2)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(" viewWillAppear ");
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(" viewWillTransitionToSize = \(size)")
        cube?.updateViewSize(Float(size.width), h: Float(size.height))
    }

    // MARK: Actions
    @IBAction func disMiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
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
