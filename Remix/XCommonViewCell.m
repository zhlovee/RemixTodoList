//
//  XCommonViewCell.m
//  Remix
//
//  Created by Schiffer Li on 12/18/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "XCommonViewCell.h"

@implementation XCommonViewCell

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
