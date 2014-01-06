//
//  UIView+Overlayer.m
//  InBike
//
//  Created by Schiffer Li on 11/27/13.
//  Copyright (c) 2013 Augmentum. All rights reserved.
//
#import "Gobal.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Util.h"


@implementation UIView (Util)

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}
-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(void)showOverlay
{
    UIView *view = [self viewWithTag:OVERLAY_VIEW_TAG];
    if (!view) {
        view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self addSubview:view];
        view.tag = OVERLAY_VIEW_TAG;
    }
}

-(void)removeOverlay
{
    [[self viewWithTag:OVERLAY_VIEW_TAG] removeFromSuperview];
}

-(void)startRolling
{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[self viewWithTag:ROLLING_INDICATOR_TAG];
    if (!aiv) {
        aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aiv.tag = ROLLING_INDICATOR_TAG;
        aiv.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:aiv];
    }
    [self showOverlay];
//    [LOGGER tracePoint:aiv.center];
    [aiv startAnimating];
}
-(void)endRolling
{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[self viewWithTag:ROLLING_INDICATOR_TAG];
    [aiv stopAnimating];
    [aiv removeFromSuperview];
    [self removeOverlay];
}

-(void)showNoDataViewWithTitle:(NSString *)titile
{
    UILabel *l = (UILabel*)[self viewWithTag:NO_DATA_VIEW_TAG];
    if (!l) {
        l = [[UILabel alloc]init];
        l.tag = NO_DATA_VIEW_TAG;
    }
    l.text = titile;
    [l sizeToFit];
    l.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//    [LOGGER traceRect:self.bounds];
//    [LOGGER tracePoint:l.center];
    [self addSubview:l];
}
-(void)removeNoDataView
{
    [[self viewWithTag:NO_DATA_VIEW_TAG] removeFromSuperview];
}

-(void)placeAt:(UIView*)view
{
    self.frame = view.bounds;
    [view addSubview:self];
}
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
-(void)setSizeWidth:(CGFloat)sizeWidth
{
    CGRect r = self.frame;
    r.size.width = sizeWidth;
    self.frame = r;
}
-(CGFloat)sizeWidth
{
    return self.frame.size.width;
}
-(void)setSizeHeight:(CGFloat)sizeHeight
{
    CGRect r = self.frame;
    r.size.height = sizeHeight;
    self.frame = r;
}
-(CGFloat)sizeHeight
{
    return self.frame.size.height;
}

-(void)setOriginX:(CGFloat)originX
{
    CGRect r = self.frame;
    r.origin.x = originX;
    self.frame = r;
}
-(CGFloat)originX
{
    return self.frame.origin.x;
}
-(void)setOriginY:(CGFloat)originY
{
    CGRect r = self.frame;
    r.origin.y = originY;
    self.frame = r;
}
-(CGFloat)originY
{
    return self.frame.origin.y;
}

-(CGFloat)boundsHeight
{
    return self.bounds.size.height;
}
-(void)setBoundsHeight:(CGFloat)boundsHeight
{
    CGRect r = self.bounds;
    r.size.height = boundsHeight;
    self.bounds = r;
}
-(CGFloat)boundsWidth
{
    return self.bounds.size.width;
}
-(void)setBoundsWidth:(CGFloat)boundsWidth
{
    CGRect r = self.bounds;
    r.size.width = boundsWidth;
    self.bounds = r;
}
-(CGFloat)boundsX
{
    return self.bounds.origin.x;
}
-(void)setBoundsX:(CGFloat)boundsX
{
    CGRect r = self.bounds;
    r.origin.x = boundsX;
    self.bounds = r;
}
-(CGFloat)boundsY
{
    return self.bounds.origin.y;
}
-(void)setBoundsY:(CGFloat)boundsY
{
    CGRect r = self.bounds;
    r.origin.y = boundsY;
    self.bounds = r;
}

@end
