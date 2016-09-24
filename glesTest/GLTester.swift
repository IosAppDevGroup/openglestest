//
//  GLTester.swift
//  glesTest
//
//  Created by Flonly on 5/30/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class GLTester{
    var eglContext : EAGLContext
    
    internal init(){
        eglContext = GLTester.createBestEAGLContext()
    }
    
    internal func test(){
        
    }
    
    func baseTest() -> Void {
        //eglContext = createBestEAGLContext();
        EAGLContext.setCurrent(eglContext)
        
        EAGLContext.setCurrent(nil)
    }
    
    class func createBestEAGLContext() -> EAGLContext{
        if let eglContext = EAGLContext.init(api: EAGLRenderingAPI.openGLES3){
            return eglContext
        }else{
            return EAGLContext.init(api: EAGLRenderingAPI.openGLES2)
        }
    }
    
    func  createViewContext(_ glContext:EAGLContext, view:GLKView) -> Void {
        
    }
}
