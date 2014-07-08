//
//  ClockViewController.m
//  Remix
//
//  Created by lizhenghao on 7/7/14.
//  Copyright (c) 2014 Schiffer Li. All rights reserved.
//

#import "ClockViewController.h"
#import "NaviController.h"
#import "ALDClock.h"
#import "Gobal.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ClockViewController ()

//@property (weak, nonatomic) IBOutlet UISegmentedControl *sxSegBtn;
@property (weak, nonatomic) IBOutlet UISwitch *cfSwitch;
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property(strong,nonatomic) ALDClock *clock;

@property(nonatomic,strong)UILocalNotification *localNotify;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation ClockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"不闹的钟";
        self.autoLayoutEnabled = YES;
    }
    return self;
}

static UIView *obj;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.clock = [[ALDClock alloc]initWithFrame:_clockView.bounds];
    [self.clock addTarget:self action:@selector(clockDidChangeTime:) forControlEvents:UIControlEventValueChanged];
    
    [_clockView addSubview:_clock];
    NSDate *now = [NSDate date];
    [self.clock setHour:now.hour minute:now.minute animated:NO];
    self.clock.subtitle = now.hour >= 12 ? @"下午" : @"上午";
    
    [self findCurrentClock];
}
-(void)findCurrentClock
{
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArr = [app scheduledLocalNotifications];
    if (localArr) {
        for (UILocalNotification *noti in localArr) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                if ([[dict objectForKey:@"key"] isEqualToString:@"clock"]) {
                    _localNotify = noti;
                    [self setCurrentClockText:noti.fireDate isEveryDay:[[dict objectForKey:@"everyday"] boolValue]];
                    break;
                }
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doNaviBack:(id)sender {
    [self.naviController popViewControllerWithAnimation:ViewAnimationCurlUp];
}
- (IBAction)saveCurrentSetting:(id)sender {
    if (!_localNotify) {
        //不存在 初始化
        _localNotify = [[UILocalNotification alloc] init];
    }else{
        //存在 取消推送
        [[UIApplication sharedApplication] cancelLocalNotification:_localNotify];
    }
    
    _localNotify.fireDate = [self createNotifyDate]; //触发通知的时间

    _localNotify.repeatInterval = _cfSwitch.on ? NSCalendarUnitDay : NSCalendarUnitEra; //循环次数，kCFCalendarUnitWeekday一周一次
    //                }
    _localNotify.timeZone=[NSTimeZone defaultTimeZone];
    _localNotify.soundName = UILocalNotificationDefaultSoundName;
    _localNotify.alertBody= [NSString stringWithFormat:@"[闹钟]你该起床啦"];

    _localNotify.alertAction = @"打开";  //提示框按钮
    _localNotify.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失

    _localNotify.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
    
    //下面设置本地通知发送的消息，这个消息可以接受
    _localNotify.userInfo = @{@"key": @"clock",
                              @"everyday":@(_cfSwitch.on)};
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotify];

    [self setCurrentClockText:_localNotify.fireDate isEveryDay:_cfSwitch.on];
    [UIAlertView showAlertWithTitle:@"本地闹钟保存成功！！！" message:@"没错"];
}

-(void)setCurrentClockText:(NSDate*)date isEveryDay:(BOOL)everyday
{
    if (everyday) {
        _descLabel.text = [NSString stringWithFormat:@"当前闹钟：每天%@%d点%d分",date.hour>= 12?@"下午":@"上午",date.hour,date.minute];
    }else{
        _descLabel.text = [NSString stringWithFormat:@"当前闹钟：%@%d点%d分",date.hour>= 12?@"下午":@"上午",date.hour,date.minute];
    }
}

-(NSDate *)createNotifyDate
{
//    NSDate *date = [[NSDate alloc]init];
    NSDateComponents *cp = [[NSDateComponents alloc]init];
    cp.hour = self.clock.hour;
    cp.minute = self.clock.minute;
    return [[NSCalendar currentCalendar]dateFromComponents:cp];
}

#pragma mark - Clock Callback Methods
- (void)clockDidChangeTime:(ALDClock *)clock
{
    self.clock.title = [NSString stringWithFormat:@"%ld:%ld",(long)clock.hour,(long)clock.minute];
    self.clock.subtitle = clock.hour >= 12 ? @"下午" : @"上午";
    AudioServicesPlaySystemSound(1057);
}

- (void)clockDidBeginDragging:(ALDClock *)clock
{
    //    clock.borderColor = [UIColor colorWithRed:0.78 green:0.22 blue:0.22 alpha:1.0];
}

- (void)clockDidEndDragging:(ALDClock *)clock
{
    //    clock.borderColor = [UIColor colorWithRed:0.22 green:0.78 blue:0.22 alpha:1.0];
}

@end
