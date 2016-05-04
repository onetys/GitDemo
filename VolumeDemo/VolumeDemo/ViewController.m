//
//  ViewController.m
//  VolumeDemo
//
//  Created by MR.KING on 16/5/4.
//  Copyright © 2016年 Tmp. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    [self.view addSubview:[ViewController getSystemVolumSlider]];
    self.stepper.value = [ViewController getSystemVolumValue];
}
- (IBAction)change:(UIStepper*)sender {
    [ViewController setSysVolumWith:sender.value];
    self.slider.value = sender.value;
}
- (IBAction)slider:(UISlider*)sender {
    [ViewController setSysVolumWith:sender.value];
    self.stepper.value = sender.value;
}

/** 改变铃声 的 通知
 
 "AVSystemController_AudioCategoryNotificationParameter" = Ringtone;    // 铃声改变
 "AVSystemController_AudioVolumeChangeReasonNotificationParameter" = ExplicitVolumeChange; // 改变原因
 "AVSystemController_AudioVolumeNotificationParameter" = "0.0625";  // 当前值
 "AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" = 0; 最小值
 
 
 改变音量的通知
 "AVSystemController_AudioCategoryNotificationParameter" = "Audio/Video"; // 音量改变
 "AVSystemController_AudioVolumeChangeReasonNotificationParameter" = ExplicitVolumeChange; // 改变原因
 "AVSystemController_AudioVolumeNotificationParameter" = "0.3";  // 当前值
 "AVSystemController_UserVolumeAboveEUVolumeLimitNotificationParameter" = 0; 最小值
 */
-(void)volumeChange:(NSNotification*)notifi{
    NSString * style = [notifi.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
    CGFloat value = [[notifi.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
    if ([style isEqualToString:@"Ringtone"]) {
        NSLog(@"铃声改变");
    }else if ([style isEqualToString:@"Audio/Video"]){
        NSLog(@"音量改变 当前值:%f",value);
        self.stepper.value = value;
        self.slider.value = value;
    }
}


#pragma mark - 音量控制
/*
 *获取系统音量滑块
 */
+(UISlider*)getSystemVolumSlider{
    static UISlider * volumeViewSlider = nil;
    if (volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
        
        for (UIView* newView in volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)newView;
                break;
            }
        }
    }
    
    return volumeViewSlider;
}


/*
 *获取系统音量大小
 */
+(CGFloat)getSystemVolumValue{
    return [[self getSystemVolumSlider] value];
}
/*
 *设置系统音量大小
 */
+(void)setSysVolumWith:(double)value{
    [self getSystemVolumSlider].value = value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
