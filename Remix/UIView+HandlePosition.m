//
//  UIView+HandlePosition.m
//  Episode
//
//  Created by Schiffer Li on 11/22/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "UIView+HandlePosition.h"

@implementation UIView (HandlePosition)

-(void)setCenterX:(CGFloat)x
{
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}
-(void)setCenterY:(CGFloat)y
{
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}
-(CGFloat)centerX
{
    return self.center.x;
}
-(CGFloat)centerY
{
    return self.center.y;
}


@end
