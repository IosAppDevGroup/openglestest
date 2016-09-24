//
//  GLWrapper.swift
//  glesTest
//
//  Created by Flonly on 8/26/16.
//  Copyright © 2016 Flonly. All rights reserved.
//

import Foundation
import GLKit

extension GLKMatrix4 {
    var array: [Float] {
        return (0..<16).map { i in
            self[i]
        }
    }
}

class GLWrapper {
    
    class func loadShader(_ vertexShader: String, fragmentShader: String) -> (Bool, GLuint, GLuint, GLuint) {
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        
        var program = glCreateProgram()
        print(" glCreateProgram  \(program)")
        if !GLWrapper.compileShader(&vertShader, type: UInt32(GL_VERTEX_SHADER), sourceString: vertexShader) {
            
            print("Failed to compile vertex shader")
            return (false, program, vertShader, fragShader)
        }
        
        if !GLWrapper.compileShader(&fragShader, type: UInt32(GL_FRAGMENT_SHADER), sourceString: fragmentShader) {
            
            print("Failed to compile fragment shader")
            return (false, program, vertShader, fragShader)
        }
        
        glAttachShader(program, vertShader)
        glAttachShader(program, fragShader)
        
        if !GLWrapper.linkProgram(program) {
            print("Failed to link program \(program)")
            
            glDeleteShader(vertShader)
            glDeleteShader(fragShader)
            glDeleteProgram(program)
            program = 0
            return (false, program, vertShader, fragShader)
        }
        return (true, program, vertShader, fragShader)
    }
    
    class func compileShader(_ shader: UnsafeMutablePointer<GLuint>, type: GLenum, sourceString: String?) -> Bool {
        
        if let _sourceString = sourceString  {
            
            let sourceNString = _sourceString as NSString
            
            var source: UnsafePointer<GLchar>? = sourceNString.utf8String!
            var sourceLen: GLint = GLint(sourceNString.length)
            
            shader.pointee = glCreateShader(type)
            print(" glCreateShader type = \(type) shader = \(shader.pointee)")
            glShaderSource(shader.pointee, 1, &source, &sourceLen);
            glCompileShader(shader.pointee);
            
            var status: GLint = GL_FALSE;
            glGetShaderiv(shader.pointee, UInt32(GL_COMPILE_STATUS), &status)
            print( "compileShader status = \(status), GL_FALSE = \(GL_FALSE)")
            if status == GL_FALSE {
                let infoLog = UnsafeMutablePointer<GLchar>.allocate(capacity: 256)
                var infoLogLength = GLsizei()
                
                glGetShaderInfoLog(shader.pointee, GLsizei(256), &infoLogLength, infoLog)
                NSLog(" compileShader():  glCompileShader() failed:  %@, %@", String(describing: infoLog), " just test")
                infoLog.deallocate(capacity: 256)
                glDeleteShader(shader.pointee)
                return false
            }
            else {
                
                return true
            }
        }
        else {
            
            print("Failed to load vertex shader: Empty source string");
            return false
        }
    }
    
    class func linkProgram(_ prog: GLuint) -> Bool {
        
        glLinkProgram(prog)
        
        var status: GLint = GL_FALSE
        glGetProgramiv(prog, UInt32(GL_LINK_STATUS), &status)
        
        if status == GL_FALSE {
            let infoLog = UnsafeMutablePointer<GLchar>.allocate(capacity: 256)
            var infoLogLength = GLsizei()
            glGetProgramInfoLog(prog, GLsizei(256), &infoLogLength, infoLog)
            NSLog(" linkProgram(): failed:  %@, %@", String(describing: infoLog), " just test")
            infoLog.deallocate(capacity: 256)
            return false
        }
        
        return true
    }
}

extension GLWrapper {
    
    class func setUniform1f(_ program: GLuint, name: String, x: GLfloat) {
        let location = glGetUniformLocation(program, name)
        glUniform1f(location, x)
    }
    
    class func setUniform1fv(_ program: GLuint, name: String, x: [GLfloat]) {
        let location = glGetUniformLocation(program, name)
        glUniform1fv(location, GLsizei(x.count), x)
    }
    
    class func setUniform1i(_ program: GLuint, name: String, x: GLint) {
        let location = glGetUniformLocation(program, name)
        glUniform1i(location, x)
    }
    
    class func setUniform1iv(_ program: GLuint, name: String, x: [GLint]) {
        let location = glGetUniformLocation(program, name)
        glUniform1iv(location, GLsizei(x.count), x)
    }
    
    class func setUniformMatrix4fv(_ program: GLuint, name: String, x: [GLfloat]) {
        let location = glGetUniformLocation(program, name)
        glUniformMatrix4fv(location, 1, GLboolean(GL_FALSE), x)
    }
    
    class func setUniform4fv(_ program: GLuint, name: String, x: [GLfloat]) {
        let location = glGetUniformLocation(program, name)
        glUniform4fv(location, 1, x)
    }
}

extension GLWrapper {
    
    class func bindTexture(_ index: GLenum, targe: GLenum, texture: GLuint) {
        glActiveTexture(index)
        glBindTexture(targe, texture)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
    }
}

extension GLWrapper {
    /**
     * Checks to see if a GLES error has been raised.
     */
    class func checkGlError(_ op: String) -> Void {
        let error:GLenum = glGetError()
        if error != GLenum(GL_NO_ERROR) {
            //print(" error = \(error)\n")
            let msg: String = op + ": glError " + getGlStringError(error)
            print(msg + "\n")
        }
    }
    
    class func getGlStringError(_ error: GLenum) -> String {
        switch (error) {
        case GLenum(GL_INVALID_ENUM):
            /*Given when an enumeration parameter is not a legal enumeration for that function.
             This is given only for local problems; if the spec allows the enumeration in certain circumstances,
             where other parameters or state dictate those circumstances, then GL_INVALID_OPERATION is the result instead.*/
            return "GL_INVALID_ENUM";
        case GLenum(GL_INVALID_VALUE):
            /*Given when a value parameter is not a legal value for that function. This is only given for local problems;
             if the spec allows the value in certain circumstances, where other parameters or state dictate those circumstances,
             then GL_INVALID_OPERATION is the result instead.*/
            return "GL_INVALID_VALUE";
        case GLenum(GL_INVALID_OPERATION):
            /*Given when the set of state for a command is not legal for the parameters given to that command.
             It is also given for commands where combinations of parameters define what the legal parameters are.*/
            return "GL_INVALID_OPERATION";
        case GLenum(GL_STACK_OVERFLOW):
            /*Given when a stack pushing operation cannot be done because it would overflow the limit of that stack's size.*/
            return "GL_STACK_OVERFLOW";
        case GLenum(GL_STACK_UNDERFLOW):
            /*Given when a stack popping operation cannot be done because the stack is already at its lowest point.*/
            return "GL_STACK_UNDERFLOW";
        case GLenum(GL_OUT_OF_MEMORY):
            /*Given when performing an operation that can allocate memory, and the memory cannot be allocated.
             The results of OpenGL functions that return this error are undefined; it is allowable for partial operations to happen.*/
            return "GL_OUT_OF_MEMORY";
        case GLenum(GL_INVALID_FRAMEBUFFER_OPERATION):
            /*Given when doing anything that would attempt to read from or write/render to a framebuffer that is not complete.*/
            return "GL_INVALID_FRAMEBUFFER_OPERATION";
//        case 507:
//            /*Given if the OpenGL context has been lost, due to a graphics card reset.*/
//            return "GL_CONTEXT_LOST";
//        case 8031, GLenum(GL_TABLE_TOO_LARGE):
//            /*Part of the ARB_imaging extension.*/
//            return "GL_TABLE_TOO_LARGE";
        default:
            return "";
        }
    }
}
