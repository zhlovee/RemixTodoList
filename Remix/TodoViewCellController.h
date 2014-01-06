//
//  TodoViewCellControllerViewController.h
//  Remix
//
//  Created by Schiffer Li on 12/17/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "XBaseViewController.h"
#import "TodoItem.h"

@interface TodoViewCellController : XBaseViewController
@property(nonatomic,assign) BOOL important;
@property(nonatomic,assign) BOOL urgency;
@property(nonatomic,assign) BOOL bigView;
@end
