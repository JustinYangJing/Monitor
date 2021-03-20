//
//  RecordHandle.h
//  TextureRender
//
//  Created by JustinYang on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

/// RecordHandle对象不能函数中的局部变量，因为函数结束时，该变量会销毁
@interface RecordHandle : NSObject

/// 开始录屏函数
/// @param name 文件名称需要带.mp4的后缀
/// @param view 要录的view, 可以传入uiwidow，但在录制过程中，要保证view(window)的frame大小不变
-(void)startRecordWithFileName:(NSString *)name recordView:(UIView *)view;

/// 停止录制
-(void)stopRecord;

/// 视频存到相册，请确保info.plist加入了Privacy - Photo Library Additions Usage Description的说明
-(void)saveVideoToAlbum;
@end

NS_ASSUME_NONNULL_END
