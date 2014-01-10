//
//  AGAlertView.m
//  InBike
//
//  Created by Wesley Yang on 13-10-31.
//  Copyright (c) 2013年 Augmentum. All rights reserved.
//

#import "XAlertView.h"

@interface XAlertView()<UIAlertViewDelegate>

@property (nonatomic,copy) AGAlertCallBack callBack;

@end

@implementation XAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showWithCompletion:(AGAlertCallBack)completeBlock
{
    if (completeBlock) {
        self.callBack = completeBlock;
    }
    self.delegate = self;
    return [self show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.callBack) {
        self.callBack(buttonIndex);
        _callBack = nil;
    }
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+(void)showConfirm:(NSString*)title subTitle:(NSString*)subTitle okBtnText:(NSString*)okText cancelBtnText:(NSString*)cancelText completion:(AGAlertCallBack)completeBlock
{
    XAlertView *alert = [[XAlertView alloc] initWithTitle:title message:subTitle delegate:nil cancelButtonTitle:cancelText otherButtonTitles:okText, nil];
    
    [alert showWithCompletion:^(NSUInteger buttonIndex) {
        completeBlock(buttonIndex);
    }];
}

@end
