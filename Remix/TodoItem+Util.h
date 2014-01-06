//
//  TodoItem+Util.h
//  Remix
//
//  Created by Schiffer Li on 12/28/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "TodoItem.h"

//color
#define COLOR_HIGH_ENGRCY [UIColor colorWithHue:0.99 saturation:.28 brightness:1 alpha:1];
#define COLOR_HIGH [UIColor colorWithHue:0.59 saturation:.28 brightness:1 alpha:1];
#define COLOR_ENGRCY [UIColor colorWithHue:0.25 saturation:.28 brightness:1 alpha:1];
#define COLOR_NORMAL [UIColor colorWithHue:0.81 saturation:.28 brightness:1 alpha:1];

@interface TodoItem (Util)

@property(nonatomic,assign) BOOL isImportant;
@property(nonatomic,assign) BOOL isUrgency;
@property(nonatomic,assign) BOOL isFinished;
@property(nonatomic,assign) BOOL isAllDayEvent;

@property(nonatomic,readonly) NSString * reminderTimeDisplayText;
-(NSString *)descriptionForResult;
-(NSString*)timeRemainsOfDeadLine;
-(UIColor*)itemThemeColor;

@end
