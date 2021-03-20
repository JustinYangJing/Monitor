//
//  MonitorHandle.h
//  TextureRender
//
//  Created by JustinYang on 2021/3/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

/// 请自行持有MonitorHandle
@interface MonitorHandle : NSObject

/// 展示监控的view
@property (nonatomic, readonly) UIView *monitorView;

/// 在一个新的window上展示监控的view
/// @param view 被监控的view(window)
/// @param size view(window)的尺寸
/// @return 返回新的window,可以调整window的位置
-(UIWindow *)showMonitorNewWindowWithView:(UIView *)view windowSize:(CGSize)size;

/// 停止监控
-(void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
