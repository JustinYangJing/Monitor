### TextureRender

-----

> 使用opengl ，获取`SceneDelegate`的`UIWindow`,将其展示在另外一个`UIWindow`上

#### 渲染步骤

- 新建UIView子类，重写`layerClass`方法

  ```o
  +(Class)layerClass{
      return [CAEAGLLayer class];
  }
  ```

- 设置`CAEAGLLayer`的属性

  ```ob
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.opaque = NO;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:@(NO),
                                  kEAGLDrawablePropertyRetainedBacking,
                                  kEAGLColorFormatRGBA8,
                                  kEAGLDrawablePropertyColorFormat,nil];
  ```

- 设置`context` `fbo(FrameBuffer Object)` `rbo(RenderBuffer Object)`

  ```ob
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
  ```

  新建fbo后，要将rbo(这里使用的是rbo)或者纹理作为附件，与fbo管理起来， 因为fbo或者纹理才是真正分配存储空间的; fbo添加附件要符合一下要求

  - 我们必须往里面加入至少一个附件（颜色、深度、模板缓冲）。
  - 其中至少有一个是颜色附件。
  - 所有的附件都应该是已经完全做好的（已经存储在内存之中）。
  - 每个缓冲都应该有同样数目的样本。

- 初始化`VAO` `VBO`  读取`shader`到内存

  VBO是真实存储顶点数据的缓存；

  vertices数组存放顶点数据与该顶点对应的纹理坐标；数据中的顶点对应vertex shader(glsl.vert)的aPos数据，纹理坐标对应vertex shader 的textcoord变量; 纹理图像对应 Fragment shader(glsl.frag)的tex变量

- `CADisplayLink`的刷新函数中获取window的图像，并将其渲染到RBO对应的layer上

  - 先获取要监视的view的layer的图像，作为纹理数据

  - 绑定到已经初始化好的fbo与rbo

  - 绑定到已经初始化的vao

  - ` glDrawArrays(GL_TRIANGLES, 0, 6);`根据顶点画四边形，并使用纹理坐标与纹理映射到四边形的4个点

  - `[_context presentRenderBuffer:GLRENDERBUFFER]`在layer上呈现

    

    

