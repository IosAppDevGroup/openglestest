//
//  Cube.swift
//  glesTest
//
//  Created by Flonly on 8/20/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import Foundation
import GLKit

class Cube {

    private var vertex_data: [GLfloat] = [
        -1.0, -1.0, -1.0,
        -1.0, -1.0, 1.0,
        1.0, -1.0, 1.0,
        1.0, -1.0, -1.0,
        -1.0, 1.0, -1.0,
        -1.0, 1.0, 1.0,
        1.0, 1.0, 1.0,
        1.0, 1.0, -1.0
    ]

    private var vertex_color : [GLfloat] = [
        0.583,  0.771,  0.014,
        0.609,  0.115,  0.436,
        0.327,  0.483,  0.844,
        0.822,  0.569,  0.201,
        0.435,  0.602,  0.223,
        0.310,  0.747,  0.185,
        0.597,  0.770,  0.761,
        0.559,  0.436,  0.730,
        0.359,  0.583,  0.152,
        0.483,  0.596,  0.789,
        0.559,  0.861,  0.639,
        0.195,  0.548,  0.859,
        0.014,  0.184,  0.576,
        0.771,  0.328,  0.970,
        0.406,  0.615,  0.116,
        0.676,  0.977,  0.133,
        0.971,  0.572,  0.833,
        0.140,  0.616,  0.489,
        0.997,  0.513,  0.064,
        0.945,  0.719,  0.592,
        0.543,  0.021,  0.978,
        0.279,  0.317,  0.505,
        0.167,  0.620,  0.077,
        0.347,  0.857,  0.137,
        0.055,  0.953,  0.042,
        0.714,  0.505,  0.345,
        0.783,  0.290,  0.734,
        0.722,  0.645,  0.174,
        0.302,  0.455,  0.848,
        0.225,  0.587,  0.040,
        0.517,  0.713,  0.338,
        0.053,  0.959,  0.120,
        0.393,  0.621,  0.362,
        0.673,  0.211,  0.457,
        0.820,  0.883,  0.371,
        0.982,  0.099,  0.879
    ]
    private var vertex_index1: [GLubyte] = [
        0,1,2,
        0,2,3,
        0,1,5,
        0,4,5,
        1,2,6,
        1,5,6,
        2,3,7,
        2,6,7,
        0,3,4,
        0,3,7,
        4,5,6,
        5,6,7
    ]
    
    private var vertex_index: [GLubyte] = [
        0,1,2,
        0,2,3,
        0,1,5,
        0,4,5,
        2,3,6,
        3,6,7,
        0,3,7,
        0,4,7,
        1,2,6,
        1,5,6,
        4,5,6,
        4,7,6
    ]

    
    private var vertexShaderCode:String = "attribute vec4 Position;"
            + "attribute vec4 SourceColor;"
            + "varying vec4 DestinationColor;"
            + "uniform mat4 mvpMatrix; "
            + "void main(void) {"
            + "     DestinationColor = SourceColor;"
//            + "     //DestinationColor = (1.0, 0.0, 0.0, 1.0);"
            + "     gl_Position = mvpMatrix * Position;"
//            + "     gl_Position = Position;"
            + "}"
    
    private var fragmentShaderCode:String = "varying lowp vec4 DestinationColor;"
            + "void main(void) { "
            + "    gl_FragColor = DestinationColor; "
//            + "    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); "
            + "}"
    
    var viewWidth: Float = 1.0
    var viewHeight: Float = 1.0
    
    //private var vertexShader
    var vertexBuffer:GLuint = 0
    var colorBuffer: GLuint = 0
    var indexBuffer :GLuint = 0
    var vertexShader : GLuint = 0
    var fragmentShader: GLuint = 0
    var glProgram: GLuint = 0
    
    // MARK: shader attributes
    var glPostionSlot: GLuint = 0
    var glColorSlot : GLuint = 0
    var glMvp : GLuint = 0
    
    // MARK: MVP
    var perspectivMatrix : GLKMatrix4 = GLKMatrix4MakePerspective(45, 4/3, 0.1, 100.0)
    var viewMatrix : GLKMatrix4 = GLKMatrix4MakeLookAt(4, 3, 3, 0, 0, 0, 0, 1, 0)
    var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
    var mvpMatrix : GLKMatrix4? = nil
    
    // MARK: construct
    init(width:Float, height: Float) {
        viewWidth = width
        viewHeight = height
        GLWrapper.checkGlError("initVertexBuffer_S")
        initVertexBuffer()
        GLWrapper.checkGlError("initVertexBuffer_E")
        createProgram()
        GLWrapper.checkGlError("createProgram_E")
        initMVP()
    }
    
    private func initMVP(){
        modelMatrix = GLKMatrix4RotateWithVector3(modelMatrix, 20, GLKVector3(v:(1,1,0)))
        //print( " viewWidth = \(viewWidth)  viewHeight = \(viewHeight)")
        perspectivMatrix = GLKMatrix4MakePerspective(45, viewWidth/viewHeight, 0.1, 100.0)
        mvpMatrix = GLKMatrix4Multiply(perspectivMatrix, GLKMatrix4Multiply(viewMatrix, modelMatrix))
    }
    
    private func updateMVP(){
        //modelMatrix = GLKMatrix4RotateWithVector3(modelMatrix, 1, GLKVector3(v:(1 , 0, 0)))
        modelMatrix = GLKMatrix4RotateX(modelMatrix, 0.01)
        modelMatrix = GLKMatrix4RotateY(modelMatrix, 0.01)
        modelMatrix = GLKMatrix4RotateZ(modelMatrix, 0.01)
        //print( " viewWidth = \(viewWidth)  viewHeight = \(viewHeight)")
        perspectivMatrix = GLKMatrix4MakePerspective(45, viewWidth/viewHeight, 0.1, 100.0)
        mvpMatrix = GLKMatrix4Multiply(perspectivMatrix, GLKMatrix4Multiply(viewMatrix, modelMatrix))
    }
    
    func updateViewSize(w:Float, h: Float){
        viewWidth   = w
        viewHeight  = h
    }
    
    func createProgram(){
//        vertexShader = loadShader(vertexShaderCode, shaderType: GLenum(GL_VERTEX_SHADER))
//        fragmentShader = loadShader(fragmentShaderCode, shaderType: GLenum(GL_FRAGMENT_SHADER))
//        glProgram = glCreateProgram()
//        glAttachShader(glProgram,vertexShader)
//        glAttachShader(glProgram, fragmentShader)
//        glLinkProgram(glProgram)
//        
//        var linkSuccess: GLint = GL_TRUE
//        glGetProgramiv(glProgram, GLenum(GL_LINK_STATUS), &linkSuccess)
//        if linkSuccess == GL_FALSE {
//            var message:[GLchar] = [GLchar]()
//            message.reserveCapacity(256)
//            var logLength:GLint = 0;
//            glGetProgramInfoLog(glProgram, GLint(message.capacity), &logLength, &message)
//            print(" link program err : \(message)\n")
//        }
        var ret:Bool = false
        (ret , glProgram, vertexShader, fragmentShader) = GLWrapper.loadShader(vertexShaderCode, fragmentShader: fragmentShaderCode)
        if !ret {
            print(" Cube createProgram failed ")
            return
        }
        
        glUseProgram(glProgram)
        
        glPostionSlot = GLuint(glGetAttribLocation(glProgram, "Position"))
        glColorSlot = GLuint(glGetAttribLocation(glProgram, "SourceColor"))
//        glMvp  = GLuint(glGetUniformLocation(glProgram, "mvp"))
        
        glEnableVertexAttribArray(GLuint(glPostionSlot))
        glEnableVertexAttribArray(GLuint(glColorSlot))
        
    }
    
//    func loadShader(code: String, shaderType: GLenum) -> GLuint{
//        let shaderName: GLuint = glCreateShader(shaderType)
//        let codeNString = code as NSString
//        var sourceCode: UnsafePointer<GLchar> = codeNString.UTF8String
//        glShaderSource(shaderName, 1, &sourceCode, nil)
//        glCompileShader(shaderName)
//        var status: GLint = GL_TRUE
//        glGetShaderiv(shaderName, GLenum(GL_COMPILE_STATUS), &status)
//        if status == GL_FALSE {
//            var message:[GLchar] = [GLchar]()
//            var msgLength: GLint = 0;
//            message.reserveCapacity(256)
//            glGetShaderInfoLog(shaderName, GLint(message.capacity), &msgLength, &message)
//            print(" init shader type = \(shaderType) failed, msgLength = \(msgLength) err: \(String.fromCString(&message)) \n");
//            exit(-1)
//        }
//        
//        return shaderName
//    }
    
    func initVertexBuffer(){
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertex_data.count * sizeof(GLfloat), vertex_data, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(1, &colorBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertex_color.count * sizeof(GLfloat), vertex_color, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(1, &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), vertex_index.count*sizeof(GLshort), vertex_index, GLenum(GL_STATIC_DRAW))
    }
    
    func draw(view: GLKView, drawInRect rect: CGRect){
        if(glProgram == 0){
            return
        }
        
        GLWrapper.checkGlError("Draw_S")
        glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0)
        glEnable(GLenum(GL_DEPTH_TEST))
        glDepthFunc(GLenum(GL_LESS))
        glClear(GLenum(GL_COLOR_BUFFER_BIT) | GLenum(GL_DEPTH_BUFFER_BIT))

        //glViewport(0, 0, 200,400)
        updateMVP()
        glUseProgram(glProgram)
        GLWrapper.setUniformMatrix4fv(glProgram, name: "mvpMatrix", x: mvpMatrix!.array)
        //glUniformMatrix4fv(GLint(glMvp), 1, GLboolean(GL_FALSE), mvpMatrix!.array)
        GLWrapper.checkGlError("Draw_1")
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glVertexAttribPointer(glPostionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, UnsafePointer<Int>(bitPattern:0))
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBuffer)
        glVertexAttribPointer(glColorSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, UnsafePointer<Int>(bitPattern:0))
        
        // glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
        GLWrapper.checkGlError("Draw_2")

        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        GLWrapper.checkGlError("Draw_3")
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(vertex_index.count), GLenum(GL_UNSIGNED_BYTE), UnsafePointer<Int>(bitPattern:0))
        //print("vertex_index.count = \(vertex_index.count)\n")
        
        GLWrapper.checkGlError("Draw_4")
    }

}