//
//  ResultItemCell.m
//  Remix
//
//  Created by Schiffer Li on 1/3/14.
//  Copyright (c) 2014 Schiffer Li. All rights reserved.
//

#import "ResultItemCell.h"
#import "Gobal.h"

@implementation ResultItemCell

-(void)setItem:(TodoItem *)item
{
    _item = item;
    self.title.text = item.name;
    self.subTitle.text = [item descriptionForResult];
    if (item.isFinished) {
        [self.stateIcon setImage:[UIImage imageNamed:@"red_flag.png"]];
    }else{
        [self.stateIcon setImage:[UIImage imageNamed:@"bell4.png"]];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
