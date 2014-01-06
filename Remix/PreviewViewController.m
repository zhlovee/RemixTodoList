//
//  HomeViewController.m
//  Remix
//
//  Created by Schiffer Li on 12/4/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "PreviewViewController.h"
#import "VRGCalendarView.h"
#import "Gobal.h"
#import "TodoItem+Util.h"
#import "PlanItemCell.h"

@interface PreviewViewController ()<VRGCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *calendarContainer;
@property (strong,nonatomic) VRGCalendarView *vrgCalendar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarCHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UITableView *amPlanItemList;
@property (weak, nonatomic) IBOutlet UITableView *pmPlanItemList;
@property(strong,nonatomic) NSMutableArray *items;
@property(strong,nonatomic) NSMutableArray *currentDayAMEvents;
@property(strong,nonatomic) NSMutableArray *currentDayPMEvents;
@end

@implementation PreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.autoLayoutEnabled = YES;
        // Custom initialization
        self.currentDayPMEvents = [NSMutableArray new];
        self.currentDayAMEvents = [NSMutableArray new];
    }
    return self;
}

- (IBAction)FDS:(id)sender {
    [ROOT_VC toggleLeftNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vrgCalendar = [[VRGCalendarView alloc]init];
    self.vrgCalendar.delegate = self;
    [self.calendarContainer addSubview:self.vrgCalendar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[APP_DELEGATE.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        [LOGGER trace:error];
    }
    self.items = mutableFetchResults;
    NSMutableArray *markDays = [NSMutableArray new];
    [self.items enumerateObjectsUsingBlock:^(TodoItem *obj, NSUInteger idx, BOOL *stop) {
        if (obj.reminderTime) {
            [markDays addObject:obj.reminderTime];
        }
    }];
    [self.vrgCalendar markDates:markDays];
    
    [self calendarView:self.vrgCalendar dateSelected:[NSDate dateStartOfDay:[NSDate new]]];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
//    [self.items enumerateObjectsUsingBlock:^(TodoItem* obj, NSUInteger idx, BOOL *stop) {
//        [self.vrgCalendar markDates:@[obj.reminderTime]];
//    }];
    self.calendarCHeight.constant = targetHeight;
    [self.view layoutIfNeededWithDuriation:0.3];
    [self.amPlanItemList reloadData];
    [self.pmPlanItemList reloadData];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    [self.currentDayAMEvents removeAllObjects];
    [self.currentDayPMEvents removeAllObjects];
    [self.items enumerateObjectsUsingBlock:^(TodoItem* obj, NSUInteger idx, BOOL *stop) {
        double offset = [obj.reminderTime timeIntervalSinceDate:date];
        if (offset>0 && offset<43200) {
            [self.currentDayAMEvents addObject:obj];
        }else if(offset >= 43200 & offset<86400 ){
            [self.currentDayPMEvents addObject:obj];
        }
    }];
    [self.amPlanItemList reloadData];
    [self.pmPlanItemList reloadData];
//    self.calendarCHeight.constant = 60;
//    [self.view layoutIfNeededWithDuriation:0.3];
//    NSLog(@"%@",self.currentDayEvents);
}

- (IBAction)refresh:(id)sender {
//    [self.view startRolling];
}

- (IBAction)amBtnPressed:(id)sender {
    self.amViewWidthConstraint.constant = 270;
    self.calendarCHeight.constant = 60;

    [self.view layoutIfNeededWithDuriation:0.3];
}

- (IBAction)pmBtnPressed:(id)sender {
    self.amViewWidthConstraint.constant = 50;
    self.calendarCHeight.constant = 60;

    [self.view layoutIfNeededWithDuriation:0.3];
}

#pragma mark - todo item table list
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.amPlanItemList) {
        return self.currentDayAMEvents.count;
    }else{
        return self.currentDayPMEvents.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoItem *item;
    if (tableView == self.amPlanItemList) {
        item = [self.currentDayAMEvents objectAtIndex:indexPath.row];
    }else{
        item = [self.currentDayPMEvents objectAtIndex:indexPath.row];
    }
    PlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanItemCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.planItem = item;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end