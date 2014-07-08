//
//  Gobal.h
//  Episode
//
//  Created by Schiffer Li on 11/19/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//
#import "SmartUtility.h"
//#import "NSDate+convenience.h"
//#import "IIViewDeckController.h"
#import "RootViewController.h"
#import "UIView+AutoLayout.h"
#import "NaviController.h"
#import "AppDelegate.h"

#define DEFAULT_DATE_FORMAT @"yyyy/MM/dd HH:mm"


//#define APP_STORE_URL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=786937916"
#define APP_STORE_URL @"https://itunes.apple.com/cn/app/todo-list/id786937916?mt=8"

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
