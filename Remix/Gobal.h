//
//  Gobal.h
//  Episode
//
//  Created by Schiffer Li on 11/19/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//
#import "XLogger.h"
#import "UIView+Util.h"
#import "NSDateFormatter+Util.h"
#import "NSDate+convenience.h"
//#import "IIViewDeckController.h"
#import "RootViewController.h"
#import "UIView+AutoLayout.h"
#import "NaviController.h"
#import "AppDelegate.h"

#define APP_DELEGATE [AppDelegate sharedAppDelegate]

#ifndef Episode_Gobal_h
#define Episode_Gobal_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS7  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#endif
