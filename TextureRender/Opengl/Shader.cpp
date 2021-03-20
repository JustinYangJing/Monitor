//
//  Shader.cpp
//  iyinxiu
//
//  Created by JustinYang on 2021/3/18.
//  Copyright © 2021 yinxiu. All rights reserved.
//

#include "Shader.hpp"

using namespace std;
Shader::Shader(const char* vertexPath, const char* fragmentPath,const char* geometryPath){
    string vertexCode;
    string fragmentCode;
    string geometryCode;
    ifstream vShaderFile;
    ifstream fShaderFile;
    ifstream gShaderFile;
    
    vShaderFile.exceptions(ifstream::failbit | ifstream::badbit);
    fShaderFile.exceptions(ifstream::failbit | ifstream::badbit);
    gShaderFile.exceptions(ifstream::failbit | ifstream::badbit);
    
    try {
        vShaderFile.open(vertexPath);
        fShaderFile.open(fragmentPath);
        std::stringstream vShaderStream, fShaderStream;
        vShaderStream << vShaderFile.rdbuf();
        fShaderStream << fShaderFile.rdbuf();
        vShaderFile.close();
        fShaderFile.close();
        
        vertexCode = vShaderStream.str();
        fragmentCode = fShaderStream.str();
        
//        if (geometryPath != nullptr) {
//            gShaderFile.open(geometryPath);
//            std::stringstream gShaderStream;
//            gShaderStream << gShaderFile.rdbuf();
//            gShaderFile.close();
//            geometryCode = gShaderStream.str();
//        }
    } catch (std::ifstream::failure e ) {
        std::cout << "ERROR::shader::file_not_succesfully_read" << std::endl;
    }
    //读出了shader代码
    const char * vShderCode = vertexCode.c_str();
    const char * fShaderCode = fragmentCode.c_str();
    
    //编译shader
    unsigned int vertex, fragment;
    vertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex,1,&vShderCode, NULL);
    glCompileShader(vertex);
    checkCompileErrors(vertex, "VERTEX");
    
    fragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment,1, &fShaderCode, NULL);
    glCompileShader(fragment);
    checkCompileErrors(fragment, "FRAGMENT");
    
//    unsigned int geometry = 0;
//    if (geometryPath != nullptr) {
//        const char * gShaderCode = geometryCode.c_str();
//        geometry = glCreateShader(GL_GEOMETRY_SHADER);
//        glShaderSource(geometry,1, &gShaderCode,NULL);
//        glCompileShader(geometry);
//        checkCompileErrors(geometry, "GEOMETRY");
//    }
    
    ID = glCreateProgram();
    glAttachShader(ID, vertex);
    glAttachShader(ID, fragment);
//    if (geometryPath != nullptr) {
//        glAttachShader(ID, geometry);
//    }
    glLinkProgram(ID);
    checkCompileErrors(ID, "PROGRAM");
    glDeleteShader(vertex);
    glDeleteShader(fragment);
    
//    if(geometryPath != nullptr)
//        glDeleteShader(geometry);
    
}

void Shader::checkCompileErrors(GLuint shader, std::string type){
    GLint success;
    GLchar infoLog[1024];
    if (type != "PROGRAM") {
        glGetShaderiv(shader,GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(shader, 1024, NULL, infoLog);
            std::cout << "ERROR::SHADER_COMPILATION_ERROR of type: " << type << "\n" << infoLog << "\n -- --------------------------------------------------- -- " << std::endl;
        }
    }else{
        glGetProgramiv(shader, GL_LINK_STATUS, &success);
        if (!success) {
            glGetProgramInfoLog(shader,1024, NULL, infoLog);
            std::cout << "ERROR::PROGRAM_LINKING_ERROR of type: " << type << "\n" << infoLog << "\n -- --------------------------------------------------- -- " << std::endl;
        }
    }
}

void Shader::use(){
    glUseProgram(ID);
}

void Shader::setBool(const std::string &name, bool value) const{
    glUniform1i( glGetUniformLocation(ID,name.c_str()), (int)value);
}

void Shader::setInt(const std::string &name, int value) const{
    glUniform1i( glGetUniformLocation(ID,name.c_str()), value);
}


