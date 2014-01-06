//
//  TodoViewController.m
//  Remix
//
//  Created by Schiffer Li on 12/4/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "TodoViewController.h"
#import "NewTodoItemViewController.h"
#import "Gobal.h"
#import "TodoViewCellController.h"

#define BIG_VIEW_SCALE 0.85

typedef enum{
    TodoViewCenterMode,
    TodoViewTopLeftMode,
    TodoViewTopRightMode,
    TodoViewBottomLeftMode,
    TodoViewBottomRightMode
} TodoViewMode;

@interface TodoViewController ()

@property (weak, nonatomic) IBOutlet UIView *topLeftView;
@property (weak, nonatomic) IBOutlet UIView *topRightView;
@property (weak, nonatomic) IBOutlet UIView *bottomLeftView;
@property (weak, nonatomic) IBOutlet UIView *bottomRightView;
@property (weak, nonatomic) IBOutlet UIScrollView *todoViewContainer;

@property(nonatomic,assign) TodoViewMode currentMode;
@property (weak, nonatomic) NSLayoutConstraint *cHeight;
@property (weak, nonatomic) NSLayoutConstraint *cWidth;

@property(nonatomic,strong) NSMutableArray *todoCellCtrls;

@end

@implementation TodoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.autoLayoutEnabled = YES;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bodyView.cornerRadius = 5;

    [self setupDefaultConstrains];

    self.todoCellCtrls = [NSMutableArray new];
    [self addTodoViewCell:self.topLeftView important:YES urgency:YES];
    [self addTodoViewCell:self.topRightView important:YES urgency:NO];
    [self addTodoViewCell:self.bottomLeftView important:NO urgency:YES];
    [self addTodoViewCell:self.bottomRightView important:NO urgency:NO];
}

-(void)addTodoViewCell:(UIView*) container important:(BOOL)important urgency:(BOOL)urgency
{
    TodoViewCellController *todoCtrl = [TodoViewCellController new];
    todoCtrl.important = important;
    todoCtrl.urgency = urgency;
    [self addChildViewController:todoCtrl];
    [container addSubview:todoCtrl.view];
    todoCtrl.view.translatesAutoresizingMaskIntoConstraints = NO;
    [todoCtrl.view pinToSuperviewEdges:JRTViewPinAllEdges inset:0];

    [_todoCellCtrls addObject:todoCtrl];
//    [_todoCellDic setObject:todoCtrl forKey:[NSNumber numberWithUnsignedInteger:level]];
}

-(void)setupDefaultConstrains
{
    self.cWidth = [NSLayoutConstraint constraintWithItem:self.topLeftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.todoViewContainer attribute:NSLayoutAttributeWidth multiplier:0.5 constant:-1];
    self.cHeight = [NSLayoutConstraint constraintWithItem:self.topLeftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.todoViewContainer attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-1];

    [self.todoViewContainer addConstraints:@[self.cWidth,self.cHeight]];
}

- (IBAction)toggleHomeView:(id)sender {
//    [self.viewDeckController toggleLeftView];
    [ROOT_VC toggleLeftNavigationBar];
}

- (IBAction)showComposeView:(id)sender {
    NewTodoItemViewController *c = [NewTodoItemViewController new];
    [ROOT_VC.naviController pushViewController:c animated:YES];
}

- (IBAction)showBigView:(UITapGestureRecognizer *)rg
{
    if (self.currentMode == rg.view.tag) {
        self.currentMode = TodoViewCenterMode;
        
        [self.todoViewContainer removeConstraints:@[self.cWidth,self.cHeight]];

        [self setupDefaultConstrains];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            [self.todoCellCtrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [(TodoViewCellController*)obj setBigView:NO];
            }];
        }];
    }else{
        if (self.currentMode == TodoViewCenterMode) {
            [self.todoViewContainer removeConstraints:@[self.cWidth,self.cHeight]];
            self.cWidth = [self.topLeftView constrainWidthWithMutiplier:BIG_VIEW_SCALE];
            self.cHeight = [self.topLeftView constrainHeightWithMutiplier:BIG_VIEW_SCALE];
        }
        self.currentMode = rg.view.tag;

        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            [_todoViewContainer scrollRectToVisible:rg.view.frame animated:NO];
            [self.todoCellCtrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [(TodoViewCellController*)obj setBigView:YES];
            }];
        }];
    }
}

@end
