//
//  XBaseViewController.m
//  Remix
//
//  Created by Schiffer Li on 12/12/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "XBaseViewController.h"
#import "Gobal.h"

@interface XBaseViewController ()

@end

@implementation XBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
    if (self.bodyView) {
        if (self.autoLayoutEnabled) {
            [self.bodyView pinToSuperviewEdges:JRTViewPinTopEdge inset:0 usingLayoutGuidesFrom:self];
        }else{
            CGFloat statusBarHight = IOS7?20:0;
            self.bodyView.frame = CGRectMake(self.bodyView.originX, self.view.originY+statusBarHight, self.bodyView.sizeWidth, self.view.sizeHeight-statusBarHight);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
