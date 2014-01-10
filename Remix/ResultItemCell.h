//
//  ResultItemCell.h
//  Remix
//
//  Created by Schiffer Li on 1/3/14.
//  Copyright (c) 2014 Schiffer Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem+Util.h"
@class ResultItemCell;

@protocol ResultItemCellDelegate <NSObject>

-(void)resultItemCellDidRadioBtnPressed:(ResultItemCell*)cell;

@end

@interface ResultItemCell : UITableViewCell

@property(nonatomic,strong) TodoItem *item;

@property(nonatomic,weak) IBOutlet UIImageView *stateIcon;
@property(nonatomic,weak) IBOutlet UILabel *title;
@property(nonatomic,weak) IBOutlet UILabel *subTitle;
@property(nonatomic,weak) IBOutlet id<ResultItemCellDelegate> delegate;

@end

