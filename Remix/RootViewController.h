//
//  MainViewController.h
//  Remix
//
//  Created by Schiffer Li on 12/4/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem+Util.h"
#define ROOT_VC [RootViewController sharedInstance]

@interface RootViewController : UIViewController

+(RootViewController*)sharedInstance;
-(void)toggleLeftNavigationBar;

@end
