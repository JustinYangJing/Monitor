//
//  MonitorHandle.m
//  TextureRender
//
//  Created by JustinYang on 2021/3/20.
//

#import "MonitorHandle.h"
#import "MonitorView.h"
@interface MonitorHandle()
@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,weak) MonitorView *presentView;
@end
@implementation MonitorHandle
-(UIWindow *)showMonitorNewWindowWithView:(UIView *)view windowSize:(CGSize)size{

    NSAssert(size.width != 0, @"渲染的尺寸不能为0");
    NSAssert(size.height != 0, @"渲染的尺寸不能为0");
    
    UIWindow *win = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    win.windowScene = [UIApplication sharedApplication].windows.firstObject.windowScene;
    win.windowLevel = [UIApplication sharedApplication].windows.firstObject.windowLevel + 1;
    win.backgroundColor = [UIColor blueColor];
    win.hidden = NO;
    self.window = win;
    
    MonitorView *monitor = [[MonitorView alloc] initWithFrame:CGRectMake(0, 0, size.width  , size.height)];
    self.presentView =  monitor;
    [win addSubview:monitor];
    [monitor startMonitorWithView:view];
    return win;
}
-(void)stopMonitor{
    [self.presentView stopMonitor];
}
-(UIView *)monitorView{
    return  self.presentView;
}
@end
