//
//  AGAlertView.h
//
//  Created by Wesley Yang on 13-10-31.
//  Copyright (c) 2013年 Augmentum. All rights reserved.

#import <UIKit/UIKit.h>

typedef void (^AGAlertCallBack) (NSUInteger buttonIndex);

@interface XAlertView : UIAlertView

//不需要delegate回调的清况. 只有个OKbutton的Alert
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;


//不用delegate,采用回调
-(void)showWithCompletion:(AGAlertCallBack)completeBlock;

+(void)showConfirm:(NSString*)title subTitle:(NSString*)subTitle okBtnText:(NSString*)okText cancelBtnText:(NSString*)cancelText completion:(AGAlertCallBack)completeBlock;

@end