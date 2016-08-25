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
    
    override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection? {
        return super.overrideTraitCollectionForChildViewController(childViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredFramesPerSecond = 60;

        prepareGLContext()
        
        cube = Cube()
    }

    // MARK: private function

    private func prepareGLContext(){
        let v = self.view as! GLKView
    
        v.context = createEAGLContext()
        
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

    // MARK: Actions
    @IBAction func disMiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        cube?.draw()
    }
    
}