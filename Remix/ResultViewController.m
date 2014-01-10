//
//  SettingViewController.m
//  Remix
//
//  Created by Schiffer Li on 12/4/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "ResultViewController.h"
#import "TodoItem+Util.h"
#import "RNBlurModalView.h"
#import "XSegmentedButton.h"
#import "ResultItemCell.h"
#import "XAlertView.h"
#import "Gobal.h"

@interface ResultViewController ()<UITableViewDelegate,UITableViewDataSource,ResultItemCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *unFinishedViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishedViewBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowConstraint;
@property (weak, nonatomic) IBOutlet XSegmentedButton *topPanel;

@property(nonatomic,strong) NSMutableArray *items;
@property(nonatomic,strong) NSMutableArray *finishedItems;
@property(nonatomic,strong) NSMutableArray *unfinishedItems;
@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.autoLayoutEnabled = YES;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.finishedViewBtn.cornerRadius = 5;
    self.unFinishedViewBtn.cornerRadius = 5;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.arrowConstraint.constant = self.finishedViewBtn.centerX-7.5;
    [self.view layoutIfNeededWithDuriation:.3];
    
    self.finishedItems = [self fetchItems:YES];
    self.unfinishedItems = [self fetchItems:NO];
    
    [self updateItemText];
    
    self.items = self.finishedItems;
    [self.tableView reloadData];
}

-(void)updateItemText
{
    NSString *text = [NSString stringWithFormat:@"%d个任务已完成",self.finishedItems.count];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%d",self.finishedItems.count]];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:range];
    if (self.finishedItems.count != 0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    [self.finishedViewBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    
    text = [NSString stringWithFormat:@"%d个任务未完成",self.unfinishedItems.count];
    range = [text rangeOfString:[NSString stringWithFormat:@"%d",self.unfinishedItems.count]];
    attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:range];
    if (self.unfinishedItems.count != 0) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    [self.unFinishedViewBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
}

-(NSMutableArray*)fetchItems:(BOOL)finished
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TodoItem" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == %d",finished];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[APP_DELEGATE.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        [LOGGER trace:error];
    }
    return mutableFetchResults;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodoItem *item = [self.items objectAtIndex:indexPath.row];
    ResultItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultItemCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ResultItemCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.item = item;
    cell.delegate = self;
    return cell;
}

- (IBAction)finishedBtnPressed:(UIButton*)sender {
    [self.topPanel selectWithTag:sender.tag];
    self.arrowConstraint.constant = sender.centerX-7.5;
    [self.view layoutIfNeededWithDuriation:.3];

    if (sender == self.finishedViewBtn) {
        self.items = self.finishedItems;
    }else{
        self.items = self.unfinishedItems;
    }
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoItem *item = [self.items objectAtIndex:indexPath.row];
    NSString *msg;
    if (item.isFinished) {
        msg = @"这个任务您之前已经搞定了！！！";
    }else{
        msg = @"这个任务还没弄完要加油了哦~";
    }
    
    RNBlurModalView *v = [[RNBlurModalView alloc] initWithTitle:item.name message:msg];
    v.dismissButtonRight = YES;
    [v showWithDuration:0 delay:0 options:kNilOptions completion:nil];
}

- (IBAction)fdsbfc:(id)sender {
    [ROOT_VC toggleLeftNavigationBar];
}

-(void)resultItemCellDidRadioBtnPressed:(ResultItemCell *)cell
{
    [XAlertView showConfirm:@"确认" subTitle:@"确定要删除这条事项吗？" okBtnText:@"OK" cancelBtnText:@"Cancel" completion:^(NSUInteger buttonIndex) {
        if (buttonIndex) {
            [APP_DELEGATE.managedObjectContext deleteObject:cell.item];
            // Commit the change.
            NSError *error = nil;
            if (![APP_DELEGATE.managedObjectContext save:&error]) {
                // Handle the error.
                [LOGGER trace:error];
            }else{
                if (self.topPanel.currentSelectedIndex) {
                    self.unfinishedItems = [self fetchItems:NO];
                    self.items = self.unfinishedItems;
                }else{
                    self.finishedItems = [self fetchItems:YES];
                    self.items = self.finishedItems;
                }
                [self updateItemText];
                [self.tableView reloadData];
            }
        }
    }];
}


@end
