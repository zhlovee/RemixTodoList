//
//  NewTodoItemViewController.h
//  Episode
//
//  Created by Schiffer Li on 10/22/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBaseViewController.h"
#import "TodoItem.h"

@interface NewTodoItemViewController : XBaseViewController

@property(nonatomic,strong) TodoItem *item;

@end
