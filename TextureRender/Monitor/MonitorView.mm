//
//  MinMapView.m
//  TextureRender
//
//  Created by JustinYang on 2021/3/18.
//

#import "MonitorView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/EAGL.h>
#include "Shader.hpp"

#import <Masonry/Masonry.h>
@interface MonitorView()
@property(nonatomic, strong) CADisplayLink *link;
@property(nonatomic,weak) UIView *monitorView;
@end

@implementation MonitorView
{
    GLuint _fbo;
    GLuint _rbo;
    EAGLContext *_context;
    Shader  *_glsl;
    unsigned int _VAO;
    unsigned int _VBO;
    unsigned int _textureID;
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layerInit];
      
        [self setFBOAndRBO];
        
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self layerInit];
       
        [self setFBOAndRBO];
    }
    return  self;
}
-(void)layerInit{
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    
    layer.opaque = NO;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:@(NO),
                                kEAGLDrawablePropertyRetainedBacking,
                                kEAGLColorFormatRGBA8,
                                kEAGLDrawablePropertyColorFormat,nil];
}

-(void)setFBOAndRBO{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    _context.multiThreaded = YES;
    [EAGLContext setCurrentContext:_context];
    
    
    glGenFramebuffers(1, &_fbo);
    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), _fbo);
    
    glGenRenderbuffers(1, &_rbo);
    glBindRenderbuffer(GLenum(GL_RENDERBUFFER), _rbo);
    
    glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), _rbo);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    
    NSAssert(glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) == GLenum(GL_FRAMEBUFFER_COMPLETE), @"初始化fbo出错");
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    
}
-(void)startMonitorWithView:(UIView *)view{
    self.monitorView = view;
    NSString *vertPath = [[NSBundle mainBundle] pathForResource:@"glsl" ofType:@"vert"];
    NSString *fragPath = [[NSBundle mainBundle] pathForResource:@"glsl" ofType:@"frag"];
    
    _glsl = new Shader(vertPath.UTF8String,fragPath.UTF8String);
   
    GLfloat vertices[] = {
        -1.0f, -1.0f, 0.0f, 0.0f, 0.0f,
        1.0f, 1.0f, 0.0f , 1.0f, 1.0f,
        1.0f, -1.0f, 0.0f , 1.0f, 0.0f,

        1.0f, 1.0f, 0.0f , 1.0f, 1.0f,
        -1.0f, -1.0f, 0.0f , 0.0f, 0.0f,
        -1.0f, 1.0f, 0.0f , 0.0f, 1.0f,
    };
    
    
    glGenTextures(1, &_textureID);
    
    
    glGenVertexArrays(1,&_VAO);
    glGenBuffers(1, &_VBO);
    glBindVertexArray(_VAO);
    glBindBuffer(GL_ARRAY_BUFFER,_VBO);

    glBufferData(GL_ARRAY_BUFFER,sizeof(vertices), vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5* sizeof(float), (void *)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5*sizeof(float), (void *)(3 *sizeof(float)));
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
  
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)stopMonitor{
    [self.link invalidate];
    self.link = nil;
}
-(void)display{
    if (self.monitorView == nil) {
        [self stopMonitor];
        return;
    }
    CGSize size = self.monitorView.bounds.size;
    GLubyte *pixelBuffer = (GLubyte *)malloc(
                                   4 *
                                   size.width *
                                   size.height);

    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context =
        CGBitmapContextCreate(pixelBuffer,
                              size.width, size.height,
                              8, 4*size.width,
                              colourSpace,
                              kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colourSpace);

    [self.monitorView.layer.presentationLayer renderInContext:context];



    glBindTexture(GL_TEXTURE_2D, _textureID);
    glTexImage2D(GL_TEXTURE_2D, 0,
                 GL_RGBA,
                 size.width, size.height, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, pixelBuffer);

    glGenerateMipmap(GL_TEXTURE_2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    

    glBindFramebuffer(GL_FRAMEBUFFER,_fbo);
    glBindRenderbuffer(GL_RENDERBUFFER, _rbo);
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    float scale = [UIScreen mainScreen].scale;
    glViewport(0, 0, self.frame.size.width * scale, self.frame.size.height * scale);
   
    
    _glsl->use();

    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    _glsl->setInt("tex", 0);
    
    
    glBindVertexArray(_VAO);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

   
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindFramebuffer(GL_FRAMEBUFFER,0);
    
    
    CGContextRelease(context);
    free(pixelBuffer);
}

@end
