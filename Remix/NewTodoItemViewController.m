//
//  NewTodoItemViewController.m
//  Episode
//
//  Created by Schiffer Li on 10/22/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "NewTodoItemViewController.h"
#import "Gobal.h"
#import "TodoSubItem.h"
#import "TodoItem+Util.h"
#import "RNBlurModalView.h"

@interface NewTodoItemViewController ()<UITableViewDataSource,UITextFieldDelegate,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *itemStateView;
@property(nonatomic,assign) BOOL editing;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UISwitch *highSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *urgency;
@property (weak, nonatomic) IBOutlet UITextField *subItemName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *reminderView;

@property (weak, nonatomic) IBOutlet UIButton *remindTimeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *bodyViewContent;
@property (weak, nonatomic) IBOutlet UIDatePicker *remindDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *remindSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *allDaySwitch;
@end

@implementation NewTodoItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.autoLayoutEnabled = YES;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.item) {
        self.item = [NSEntityDescription insertNewObjectForEntityForName:@"TodoItem" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
        self.editing = NO;
        self.item.reminderTime = [NSDate new];
    }else{
        self.allDaySwitch.on = self.item.isAllDayEvent;
        self.highSwitch.on = self.item.isImportant;
        self.urgency.on = self.item.isUrgency;
        self.nameText.text = self.item.name;
        self.editing = YES;
        if (self.item.reminderTime) {
            self.remindSwitch.on = NO;
            self.remindTimeLabel.hidden = NO;
            [self.remindTimeLabel setTitle:self.item.reminderTimeDisplayText forState:UIControlStateNormal];
        }else{
            self.remindSwitch.on = NO;
        }
    }
    self.tableView.editing = YES;
    [self.remindDatePicker setMinimumDate:[NSDate new]];

    if (!self.editing) {
        [self.nameText becomeFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)datePickerValueChanged:(UIDatePicker*)sender {
    self.item.reminderTime = sender.date;
    self.item.isAllDayEvent = self.allDaySwitch.on;
    [self.remindTimeLabel setTitle:self.item.reminderTimeDisplayText forState:UIControlStateNormal];
}

- (IBAction)toggleRemindView:(UIButton*)sender {
    sender.tag = !sender.tag;
    if (sender.tag) {
        [self.bodyViewContent scrollRectToVisible:self.reminderView.frame animated:YES];
        self.datePickHeightConstraint.constant += self.reminderView.sizeHeight;
    }else{
        self.datePickHeightConstraint.constant -= self.reminderView.sizeHeight;
    }
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)addReminder:(UISwitch*)sender {
//    self.remindTimeLabel.hidden = !sender.on;
//    if (!sender.on) {
//        self.item.reminderTime = nil;
//    }else{
        self.item.reminderTime = self.remindDatePicker.date;
        self.item.isAllDayEvent = self.allDaySwitch.on;
        [self.remindTimeLabel setTitle:self.item.reminderTimeDisplayText forState:UIControlStateNormal];
//    }
//    self.remindTimeLabel.enabled = sender.on;
}

- (IBAction)allDaySwitched:(UISwitch*)sender {
    if (sender.on) {
        self.remindDatePicker.datePickerMode = UIDatePickerModeDate;
    }else{
        self.remindDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    self.item.isAllDayEvent = sender.on;
}

- (IBAction)highLevel:(UISwitch*)sender {
    self.item.isImportant = sender.on;
    self.itemStateView.backgroundColor = [self.item itemThemeColor];
}

- (IBAction)urgencyLevel:(UISwitch*)sender {
    self.item.isUrgency = sender.on;
    self.itemStateView.backgroundColor = [self.item itemThemeColor];
}

- (IBAction)textFieldValueChanged:(UITextField*)sender {
    self.item.name = sender.text;
}

-(IBAction)handleCancel:(id)sender
{
    [APP_DELEGATE.managedObjectContext reset];
//    if (self.editing) {
        [self.naviController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

- (IBAction)addSubItem:(id)sender {
    if (self.subItemName.text) {
        [self.subItemName resignFirstResponder];
        TodoSubItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"TodoSubItem" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
        item.name = self.subItemName.text;

        NSError *error = nil;
        if (![APP_DELEGATE.managedObjectContext save:&error]) {
            [NSObject trace:error];
        }
        item.superItem = self.item;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.item.subItems.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(IBAction)handleSave:(id)sender
{
    if (!self.item.name) {
        [APP_DELEGATE.managedObjectContext reset];
    }else{
        self.item.createDate = [NSDate new];
        NSError *error = nil;
        if (![APP_DELEGATE.managedObjectContext save:&error]) {
            [NSObject trace:error];
        }
        if (self.remindSwitch.on) {
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil) {
                notification.fireDate=self.item.reminderTime; //触发通知的时间
//                if (self.item.isAllDayEvent) {
//                    notification.repeatInterval = kCFCalendarUnitHour;
//                }else{
                    notification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
//                }
                notification.timeZone=[NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.alertBody= [NSString stringWithFormat:@"[TODO]你有一个待办事项%@",self.item.name];
                
                notification.alertAction = @"打开";  //提示框按钮
                notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
                
                notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
                
                //下面设置本地通知发送的消息，这个消息可以接受
                NSDictionary* infoDic = [NSDictionary dictionaryWithObject:self.item.name forKey:@"todo"];
                notification.userInfo = infoDic;
                //发送通知
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
    }
//    if (self.editing) {
        [self.naviController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoSubItem *item = [self.item.subItems objectAtIndex:indexPath.row];

    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
    }

    cell.textLabel.text = item.name;
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item.subItems.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object at the given index path.
        TodoSubItem *toDeleteSubItem = [self.item.subItems objectAtIndex:indexPath.row];
        [APP_DELEGATE.managedObjectContext deleteObject:toDeleteSubItem];

        // Commit the change.
        NSError *error = nil;
        if (![APP_DELEGATE.managedObjectContext save:&error]) {
            // Handle the error.
        }
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [tableView reloadData];
    }
}

@end