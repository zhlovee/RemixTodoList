//
//  MainViewController.m
//  Remix
//
//  Created by Schiffer Li on 12/4/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "TodoViewController.h"
#import "NewTodoItemViewController.h"
#import "XSegmentedButton.h"
#import "Gobal.h"

#define LEFT_NAV_SCALE 0.2

@interface RootViewController (){
    BOOL isLeftOpened;
}

@property (weak, nonatomic) IBOutlet UIView *leftNaviBar;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property(nonatomic,strong) NSLayoutConstraint *leftCwidth;
@property (weak, nonatomic) IBOutlet XSegmentedButton *leftNaviItems;

@property(nonatomic,strong) TodoViewController *todoVC;
@property(nonatomic,strong) HomeViewController *homeVC;
@property(nonatomic,strong) SettingViewController *settingVC;

@property(nonatomic,weak) UIViewController *currentVC;

@end

@implementation RootViewController

static RootViewController* instance;
+(RootViewController*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [RootViewController new];
    });
    return instance;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bodyView.layer.shadowColor = [[UIColor blackColor] CGColor];
    [self.bodyView.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.bodyView.layer setShadowOpacity:1.0];
    [self.bodyView.layer setShadowRadius:2.0];

    [self setDefaultConstraints];
    [self initLeftNaviControllers];
}

-(void)initLeftNaviControllers
{
    self.todoVC = [TodoViewController new];
    self.todoVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.todoVC];
    self.homeVC = [HomeViewController new];
    self.homeVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.homeVC];
    self.settingVC = [SettingViewController new];
    self.settingVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.settingVC];
    
    //default view
    [self changeMainViewControllerTo:self.todoVC];
}

- (IBAction)showTodoView:(UIButton*)sender {
    [self.leftNaviItems selectWithTag:sender.tag];
    [self changeMainViewControllerTo:self.todoVC];
    [self toggleLeftNavigationBar];
}
- (IBAction)showSettingView:(UIButton*)sender {
    [self.leftNaviItems selectWithTag:sender.tag];
    [self changeMainViewControllerTo:self.settingVC];
    [self toggleLeftNavigationBar];
}
- (IBAction)showHomeView:(UIButton*)sender {
    [self.leftNaviItems selectWithTag:sender.tag];
    [self changeMainViewControllerTo:self.homeVC];
    [self toggleLeftNavigationBar];
}

-(void)changeMainViewControllerTo:(UIViewController *)toCtrl
{
    if (self.currentVC != toCtrl) {
        [self.bodyView addSubview:toCtrl.view];
        [toCtrl.view pinToSuperviewEdges:JRTViewPinAllEdges inset:0];
        [UIView transitionFromView:self.currentVC.view toView:toCtrl.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            
            [self.currentVC.view removeFromSuperview];
            [self.currentVC removeFromParentViewController];
            self.currentVC = toCtrl;
//            [self.currentVC didMoveToParentViewController:self];
        }];
    }
}

-(void)setDefaultConstraints
{
    self.leftCwidth = [self.leftNaviBar constrainWidthBySuperview:self.view multiplier:0];
    [self.bodyView constrainWidthBySuperview:self.view multiplier:1];
    isLeftOpened = NO;
}

-(void)toggleLeftNavigationBar
{
    [self.view removeConstraint:self.leftCwidth];
    isLeftOpened = !isLeftOpened;
    self.leftCwidth = [self.leftNaviBar constrainWidthBySuperview:self.view multiplier: LEFT_NAV_SCALE * isLeftOpened];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end