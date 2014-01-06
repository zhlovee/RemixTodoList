//
//  TodoItemCell.h
//  Remix
//
//  Created by Schiffer Li on 12/18/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"

@class TodoItemCell;

@protocol TodoItemCellDelegate <NSObject>

-(void)todoItemCellDidRadioBtn1Pressed:(TodoItemCell*)cell;
-(void)todoItemCellDidRadioBtn2Pressed:(TodoItemCell*)cell;

@end

@interface TodoItemCell : UITableViewCell

@property(nonatomic,strong) TodoItem *item;
@property(nonatomic,weak) IBOutlet id<TodoItemCellDelegate> delegate;

@end
