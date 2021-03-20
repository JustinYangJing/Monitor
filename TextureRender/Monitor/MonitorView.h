//
//  MonitorView.h
//  TextureRender
//
//  Created by JustinYang on 2021/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorView : UIView
-(void)startMonitorWithView:(UIView *)view;
-(void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
