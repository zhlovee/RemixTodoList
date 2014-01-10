//
//  XSegmentedButton.h
//  Remix
//
//  Created by Schiffer Li on 12/24/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#define XSEG_DEFAULT_SELECTED_BUTTON_TAG 123
@interface XSegmentedButton : UIView

-(NSUInteger)currentSelectedIndex;
-(void)selectWithTag:(NSUInteger)tag;
-(void)selectWithTag:(NSUInteger)tag normalBackgroundColor:(UIColor*)color selectedBackGroundColor:(UIColor*)color2;

@end
