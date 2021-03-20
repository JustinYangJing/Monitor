//
//  ViewController.m
//  TextureRender
//
//  Created by JustinYang on 2021/3/18.
//

#import "ViewController.h"
#import "MonitorHandle.h"
#import "RecordHandle.h"
#import "SceneDelegate.h"
@interface ViewController ()
@property (nonatomic,strong) RecordHandle *recordHandle;
@property (nonatomic,strong) MonitorHandle *monitorHandle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    UIView * animatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    [self.view addSubview:animatorView];
    animatorView.backgroundColor = UIColor.purpleColor;
   
    CABasicAnimation *positionA = [CABasicAnimation animationWithKeyPath:@"position"];
    
    positionA.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    positionA.toValue =  [NSValue valueWithCGPoint:CGPointMake(200, 160)];
    positionA.duration = 3;
    positionA.repeatCount = MAXFLOAT;
    positionA.autoreverses = YES;
    [animatorView.layer addAnimation:positionA forKey:nil];

    self.recordHandle = [RecordHandle new];
    self.monitorHandle = [MonitorHandle new];
    
    SceneDelegate *delegate = (SceneDelegate *)([[[UIApplication sharedApplication] connectedScenes] allObjects].firstObject.delegate);
   UIWindow *win =  [self.monitorHandle showMonitorNewWindowWithView:delegate.window windowSize:CGSizeMake(300, 400)];
    win.center = self.view.center;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  
//
}
- (IBAction)startRecord:(id)sender {
    SceneDelegate *delegate = (SceneDelegate *)([[[UIApplication sharedApplication] connectedScenes] allObjects].firstObject.delegate);
    [self.recordHandle startRecordWithFileName:@"test.mp4" recordView:delegate.window];
}
- (IBAction)stopRecord:(id)sender {
    [self.recordHandle stopRecord];
}
- (IBAction)saveAblum:(id)sender {
    [self.recordHandle saveVideoToAlbum];
}

@end
