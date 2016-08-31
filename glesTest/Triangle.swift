//
//  Triangle.swift
//  glesTest
//
//  Created by Flonly on 8/30/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import Foundation
import GLKit

class Triangle {
    
    static var vertexBufferData:[GLfloat] = [
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0,
            0.0, 1.0, 0.0
        ]
    
    static let vertexShaderCode: String = " "
        + "attribute vec4 vPosition;"
        + "void main(){"
        + "     gl_Position = vPosition;"
        + "}"
    
    static let fragShaderCode: String = " "
        + "void main(){"
        + "     gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);"
        + "}"
    
    // MARK: gl buffers
    var glVertexBuffer:GLuint   = 0
    var glProgram : GLuint      = 0
    var glVertexShader: GLuint  = 0
    var glFragShader: GLuint    = 0
    
    // MARK: shader variable
    var vPosition:GLuint = 0;
    
    init(){
        initVBOs()
        var ret:Bool = false
        (ret, glProgram, glVertexShader, glFragShader) = GLWrapper.loadShader(Triangle.vertexShaderCode, fragmentShader: Triangle.fragShaderCode)
        if !ret {
            print(" create program error");
            return
        }
        vPosition = GLuint(glGetAttribLocation(glProgram, "vPosition"))
    }
    
    private func initVBOs(){
        GLWrapper.checkGlError("initVBOs_S")
        glGenBuffers(1, &glVertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), glVertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), Triangle.vertexBufferData.count*sizeof(GLfloat), &(Triangle.vertexBufferData), GLenum(GL_STATIC_DRAW))
        GLWrapper.checkGlError("initVBOs_E")
    }
    
    func draw(){
        glClear(GLenum(GL_COLOR_BUFFER_BIT) | GLenum(GL_DEPTH_BUFFER_BIT));
//        print(" glProgram = \(glProgram)")
        glUseProgram(glProgram)
        GLWrapper.checkGlError("draw_S")
        glEnableVertexAttribArray(vPosition)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), glVertexBuffer)
        glVertexAttribPointer(vPosition, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0,UnsafePointer<Void>(bitPattern: 0))
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        glDisableVertexAttribArray(vPosition)
        
        GLWrapper.checkGlError("draw_E")
    }
}