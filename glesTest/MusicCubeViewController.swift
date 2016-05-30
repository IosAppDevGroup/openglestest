//
//  MusicCubeViewController.swift
//  glesTest
//
//  Created by Flonly on 5/30/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

struct BaseEffect {
	var effect: GLKBaseEffect
	var vertexArray: GLuint
	var vertexBuffer: GLuint
	var normalBuffer: GLuint
};

class MusicCubeViewController: GLKViewController {
	var innerCircle: BaseEffect?
	var outerCircle: BaseEffect?
	var teaport: BaseEffect?
	var cube: [Int] = [Int](count: 3, repeatedValue: 0)

	var context: EAGLContext?

	var mode: GLuint = 0;
	// teaport
	var rot: GLfloat = 0.0;
	// cube
	var cubePos: [GLfloat] = [GLfloat](count: 3, repeatedValue: 0.0)
	var cubeRot: GLfloat = 0.0;

	var cubeTexture: GLuint = 0;

	override func viewDidLoad() {
		super.viewDidLoad()
        context = EAGLContext.init(API:EAGLRenderingAPI.OpenGLES3)
        if(context==nil || !EAGLContext.setCurrentContext(context)){
            NSLog("Failed to create ES Context")
        }
        
        let view:GLKView = self.view as! GLKView
        view.context = context!
        view.drawableDepthFormat = GLKViewDrawableDepthFormat.Format16
        
        mode = 1
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
	}
}
