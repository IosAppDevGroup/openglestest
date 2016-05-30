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
        EAGLContext.setCurrentContext(eglContext)
        
        EAGLContext.setCurrentContext(nil)
    }
    
    class func createBestEAGLContext() -> EAGLContext{
        if let eglContext = EAGLContext.init(API: EAGLRenderingAPI.OpenGLES3){
            return eglContext
        }else{
            return EAGLContext.init(API: EAGLRenderingAPI.OpenGLES2)
        }
    }
    
    func  createViewContext(glContext:EAGLContext, view:GLKView) -> Void {
        
    }
}