//
//  MainViewController.m
//  Remix
//
//  Created by Schiffer Li on 12/4/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "RootViewController.h"
#import "PreviewViewController.h"
#import "ResultViewController.h"
#import "TodoViewController.h"
#import "NewTodoItemViewController.h"
#import "XSegmentedButton.h"
#import "ConfigViewController.h"
#import "NaviController.h"
#import "ClockViewController.h"
#import "Gobal.h"

#define LEFT_NAV_SCALE 0.2

@interface RootViewController (){
    BOOL isLeftOpened;
}

@property (weak, nonatomic) IBOutlet UIView *leftNaviBar;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *leftCwidth;
@property (weak, nonatomic) IBOutlet XSegmentedButton *leftNaviItems;

@property(nonatomic,strong) TodoViewController *todoVC;
@property(nonatomic,strong) PreviewViewController *planVC;
@property(nonatomic,strong) ResultViewController *resultVC;
@property(nonatomic,strong) ConfigViewController *settingVC;

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
- (IBAction)doLeftNaviSwiped:(UIPanGestureRecognizer*)grz {
    CGFloat offestX = [grz translationInView:self.view].x;
    [grz setTranslation:CGPointZero inView:self.view];
//    [LOGGER traceFloat:offestX];
    static BOOL doSwipe = NO;
    switch (grz.state) {
        case UIGestureRecognizerStateBegan:{
            if (isLeftOpened && offestX<0) {
                //allow swipe right to close left navi
                doSwipe = YES;
                self.leftCwidth.constant += offestX;
                [self.view layoutIfNeeded];
            }else if (!isLeftOpened && offestX>0){
                //allow swipe left to open left navi
                doSwipe = YES;
                self.leftCwidth.constant += offestX;
                [self.view layoutIfNeeded];
            }
//            NSLog(@"1");
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (doSwipe) {
                self.leftCwidth.constant += offestX;
                if (self.leftCwidth.constant<0) {
                    self.leftCwidth.constant = 0;
                }else if (self.leftCwidth.constant>60){
                    self.leftCwidth.constant = 60;
                }
                [self.view layoutIfNeeded];
            }
//            NSLog(@"2");
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            doSwipe = NO;
            if (self.leftCwidth.constant>30) {
                self.leftCwidth.constant = 60;
                isLeftOpened = YES;
            }else{
                self.leftCwidth.constant = 0;
                isLeftOpened = NO;
            }
            [self.view layoutIfNeededWithDuriation:.3];
//            [self.view layoutIfNeeded];
            
//            NSLog(@"3");
            break;
        }
        default:{
            break;
        }
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bodyView.layer.shadowColor = [[UIColor blackColor] CGColor];
    [self.bodyView.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.bodyView.layer setShadowOpacity:1.0];
    [self.bodyView.layer setShadowRadius:1.0];

    [self setDefaultConstraints];
    [self initLeftNaviControllers];
}

-(void)initLeftNaviControllers
{
    self.todoVC = [TodoViewController new];
    self.todoVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.todoVC];
    self.planVC = [PreviewViewController new];
    self.planVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.planVC];
    self.resultVC = [ResultViewController new];
    self.resultVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.resultVC];
    self.settingVC = [ConfigViewController new];
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

- (IBAction)showResultView:(UIButton*)sender {
    [self.leftNaviItems selectWithTag:sender.tag];
    [self changeMainViewControllerTo:self.resultVC];
    [self toggleLeftNavigationBar];
}

- (IBAction)showPlanView:(UIButton*)sender {
    [self.leftNaviItems selectWithTag:sender.tag];
    [self changeMainViewControllerTo:self.planVC];
    [self toggleLeftNavigationBar];
}
- (IBAction)showSettingView:(UIButton*)sender {
    [self.leftNaviItems selectWithTag:sender.tag];
    [self changeMainViewControllerTo:self.settingVC];
    [self toggleLeftNavigationBar];
}

- (IBAction)doPresentClockVC:(id)sender {
    ClockViewController *vc = [ClockViewController new];
    [self.naviController pushViewController:vc animation:ViewAnimationFlip intent:nil];
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
- (IBAction)closeLeftNavi:(id)sender {
    if (isLeftOpened) {
        [self toggleLeftNavigationBar];
    }
}

-(void)setDefaultConstraints
{
//    self.leftCwidth = [self.leftNaviBar constrainWidthBySuperview:self.view multiplier:0];
    [self.bodyView constrainWidthBySuperview:self.view multiplier:1];
    isLeftOpened = NO;
}

-(void)toggleLeftNavigationBar
{
    isLeftOpened = !isLeftOpened;
    self.leftCwidth.constant = isLeftOpened?60:0;
    [self.view layoutIfNeededWithDuriation:.3];
}

@end