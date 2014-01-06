//
//  XSegmentedButton.m
//  Remix
//
//  Created by Schiffer Li on 12/24/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "XSegmentedButton.h"

@interface XSegmentedButton ()

@property(nonatomic,strong) UIColor *normalBGColor;
@property(nonatomic,strong) UIColor *selectedBGColor;

@end

@implementation XSegmentedButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.subviews enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            if (obj.selected) {
                self.selectedBGColor = obj.backgroundColor;
            }else{
                self.normalBGColor = obj.backgroundColor;
            }
        }
    }];
}

-(void)selectWithTag:(NSUInteger)tag
{
    [self.subviews enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            //remove all selected button
            [obj setSelected:NO];
            obj.backgroundColor = self.normalBGColor;
            if (obj.tag == tag) {
                [obj setSelected:YES];
                obj.backgroundColor = self.selectedBGColor;
            }
        }
    }];
}

-(void)selectWithTag:(NSUInteger)tag normalBackgroundColor:(UIColor *)color selectedBackGroundColor:(UIColor *)color2
{
    [self.subviews enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            //remove all selected button
            [obj setSelected:NO];
            obj.backgroundColor = color;
            if (obj.tag == tag) {
                [obj setSelected:YES];
                obj.backgroundColor = color2;
            }
            
        }
    }];
    
}

@end
