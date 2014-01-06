//
//  XBaseViewController.h
//  Remix
//
//  Created by Schiffer Li on 12/12/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property(nonatomic,assign) BOOL autoLayoutEnabled;

@end
