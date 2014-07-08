//
//  UIView+Overlayer.h
//  InBike
//
//  Created by Schiffer Li on 11/27/13.
//  Copyright (c) 2013 Augmentum. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NO_DATA_VIEW_TAG 3945
#define ROLLING_INDICATOR_TAG 2025
#define OVERLAY_VIEW_TAG 1657

@interface UIView (Util)

@property(nonatomic,assign) CGFloat originX;
@property(nonatomic,assign) CGFloat originY;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;
@property(nonatomic,assign) CGFloat sizeWidth;
@property(nonatomic,assign) CGFloat sizeHeight;
@property(nonatomic,assign) CGFloat boundsWidth;
@property(nonatomic,assign) CGFloat boundsHeight;
@property(nonatomic,assign) CGFloat boundsX;
@property(nonatomic,assign) CGFloat boundsY;
@property(nonatomic,assign) CGFloat cornerRadius;

-(void)showNoDataViewWithTitle:(NSString *)titile;
-(void)removeNoDataView;
-(void)startRolling;
-(void)endRolling;

-(void)placeAt:(UIView*)view;
@end


typedef void (^SmartAlertCallback) (NSUInteger buttonIndex);

@interface UIAlertView (Util)

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
//不需要delegate回调的清况. 只有个OKbutton的Alert
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
//不用delegate,采用回调
-(void)showWithCompletion:(SmartAlertCallback)completeBlock;

@end
