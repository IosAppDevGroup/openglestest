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
            1.0, -1.0, -1.0,
            1.0, 1.0, -1.0,
            -1.0, 1.0, -1.0,
            -1.0, -1.0, 1.0,
            1.0, -1.0, 1.0,
            1.0, 1.0, 1.0,
            -1.0, 1.0, 1.0
    ]

    private var vertex_index: [GLshort] = [
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
    
    private var vertexShaderCode:String = "attribute vec4 Position;"
            + "attribute vec4 SourceColor;"
            + "varying vec4 DestinationColor;"
            + "void main(void) {"
            + "     DestinationColor = SourceColor;"
//            + "     //DestinationColor = (1.0, 0.0, 0.0, 1.0);"
            + "     gl_Position = Position;"
            + "}"
    
    private var fragmentShaderCode:String = "varying lowp vec4 DestinationColor;"
            + "void main(void) { "
            + "    gl_FragColor = DestinationColor; "
            + "    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); "
            + "}"
    
    //private var vertexShader
    var vertexBuffer:GLuint = 0;
    var indexBuffer :GLuint = 0;
    var vertexShader : GLuint = 0;
    var fragmentShader: GLuint = 0;
    var glProgram: GLuint = 0;
    
    // MARK: shader attributes
    var glPostionSlot: GLuint = 0;
    var glColorSlot :GLuint = 0;
    
    // MARK: construct
    init() {
        GLWrapper.checkGlError("initVertexBuffer_S")
        initVertexBuffer()
        GLWrapper.checkGlError("initVertexBuffer_E")
        createProgram()
        GLWrapper.checkGlError("createProgram_S")
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
        //glColorSlot = GLuint(glGetAttribLocation(glProgram, "SourceColor"))
        glEnableVertexAttribArray(GLuint(glPostionSlot))
        //glEnableVertexAttribArray(GLuint(glColorSlot))
        
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
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertex_data.count * sizeof(GLfloat), &vertex_data, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(1, &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), vertex_index.count*sizeof(GLshort), &vertex_index, GLenum(GL_STATIC_DRAW))
    }
    
    func draw(view: GLKView, drawInRect rect: CGRect){
        if(glProgram == 0){
            return
        }
        GLWrapper.checkGlError("Draw_S")
        glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT))
        //glViewport(0, 0, 200,400)
        
        GLWrapper.checkGlError("Draw_1")
        glEnableVertexAttribArray(glPostionSlot)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        // glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
        glVertexAttribPointer(glPostionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, UnsafePointer<Int>(bitPattern:0))
        
        // glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
        GLWrapper.checkGlError("Draw_2")

        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        GLWrapper.checkGlError("Draw_3")
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(vertex_index.count), GLenum(GL_SHORT), UnsafePointer<Int>(bitPattern:0))
        print("vertex_index.count = \(vertex_index.count)\n")
        
        
        GLWrapper.checkGlError("Draw_4")
    }

}