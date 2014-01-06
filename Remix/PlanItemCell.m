//
//  PlanItemCell.m
//  Remix
//
//  Created by Schiffer Li on 12/29/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "PlanItemCell.h"
#import "ALDClock.h"
#import "Gobal.h"
#import "RNBlurModalView.h"

@interface PlanItemCell ()

@property(strong,nonatomic) ALDClock *clock;
@property (weak, nonatomic) IBOutlet UIView *clockContainer;
@property (weak, nonatomic) IBOutlet UILabel *planItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *planItemDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;

@end

@implementation PlanItemCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupClock];
}

-(void)setPlanItem:(TodoItem *)planItem
{
    _planItem = planItem;
    self.finishedBtn.selected = planItem.isFinished;
    self.planItemLabel.text = planItem.name;
    self.planItemDateLabel.text = [[NSDateFormatter defautlDateFormtter] stringFromDate:planItem.reminderTime];
    [self applyClockCustomisations];
}
- (IBAction)fdssfs:(UIButton*)sender {
    self.planItem.isFinished = !self.planItem.isFinished;
    sender.selected = self.planItem.isFinished;
    NSError *error = nil;
    if (![APP_DELEGATE.managedObjectContext save:&error]) {
        // Handle the error.
        [LOGGER trace:error];
    }
    
    
    if (self.planItem.isFinished) {
        RNBlurModalView *v = [[RNBlurModalView alloc] initWithTitle:@"Finished" message:@"恭喜您！这个任务您已经完成了！！！"];
        v.dismissButtonRight = YES;
        [v show];
    }else{
        RNBlurModalView *v = [[RNBlurModalView alloc] initWithTitle:@"Finished" message:@"这个任务已被你弄成未完成"];
        v.dismissButtonRight = YES;
        [v show];
    }
}


#pragma mark - Clock Setup Methods

- (void)setupClock
{
    if (self.clock) {
        return;
    }
    self.clock = [[ALDClock alloc] initWithFrame:self.clockContainer.bounds];
    // Add the clock to the view.
    [self.clockContainer addSubview:self.clock];
    self.clock.userInteractionEnabled = NO;
}

-(void)applyClockCustomisations
{
//    if (self.planItem.isFinished) {
//        self.clock.subtitle = @"√";
//    }
    if (self.planItem.isAllDayEvent) {
        self.clock.subtitle = @"全天事件";
    }
    self.clock.backgroundColor = [self.planItem itemThemeColor];
    // Add a title and subtitle to the clock face
    //    self.clock.title = @"ALDClock";
    //    self.clock.subtitle = @"By Andy Drizen";
    // When the time changes, call the the clockDidChangeTime: method.
    //    [self.clock addTarget:self action:@selector(clockDidChangeTime:) forControlEvents:UIControlEventValueChanged];
    //
    //    // When the user begins/ends manually changing the time, call these methods.
    //    [self.clock addTarget:self action:@selector(clockDidBeginDragging:) forControlEvents:UIControlEventTouchDragEnter];
    //    [self.clock addTarget:self action:@selector(clockDidEndDragging:) forControlEvents:UIControlEventTouchDragExit];
    // Set the initial time
    NSDate *d = self.planItem.reminderTime;
    [self.clock setHour:d.hour minute:d.minute animated:NO];
    // Change the clock's border color and width
    self.clock.borderColor = [UIColor brownColor];
    self.clock.borderWidth = 1.0f;
}

#pragma mark - Clock Callback Methods
- (void)clockDidChangeTime:(ALDClock *)clock
{
    NSLog(@"The time is: %02d:%02d", clock.hour, clock.minute);
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
