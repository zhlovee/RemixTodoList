//
//  ConfigViewController.m
//  Remix
//
//  Created by Schiffer Li on 1/6/14.
//  Copyright (c) 2014 Schiffer Li. All rights reserved.
//

#import "ConfigViewController.h"
#import "Gobal.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toggleLeftNavi:(id)sender {
    [ROOT_VC toggleLeftNavigationBar];
}

@end
