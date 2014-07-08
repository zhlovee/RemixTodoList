//
//  TodoItem+Util.m
//  Remix
//
//  Created by Schiffer Li on 12/28/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//
#import "Gobal.h"
#import "TodoItem+Util.h"

@implementation TodoItem (Util)

-(BOOL)isImportant
{
    return [self.important boolValue];
}
-(void)setIsImportant:(BOOL)isImportant
{
    self.important = [NSNumber numberWithBool:isImportant];
}
-(BOOL)isUrgency
{
    return [self.urgency boolValue];
}
-(void)setIsUrgency:(BOOL)isUrgency
{
    self.urgency = [NSNumber numberWithBool:isUrgency];
}
-(BOOL)isFinished
{
    return [self.finished boolValue];
}
-(void)setIsFinished:(BOOL)isFinished
{
    self.finished = [NSNumber numberWithBool:isFinished];
}
-(BOOL)isAllDayEvent
{
    return [self.allDayEvent boolValue];
}
-(void)setIsAllDayEvent:(BOOL)isAllDayEvent
{
    self.allDayEvent = [NSNumber numberWithBool:isAllDayEvent];
}

-(NSString *)reminderTimeDisplayText
{
    NSDateFormatter *df;
    if (self.isAllDayEvent) {
        df = [NSDateFormatter dateFormatterWithFormat:@"yyyy/MM/dd"];
    }else{
        df = [NSDateFormatter dateFormatterWithFormat:DEFAULT_DATE_FORMAT];
    }
    return [df stringFromDate:self.reminderTime];
}

-(NSString *)descriptionForResult
{
    NSDateComponents *dc = [self dateComponentFromEndDate];
    if ([self.reminderTime timeIntervalSinceNow]<=0) {
        if (self.isFinished) {
            return [NSString stringWithFormat:@"时间结束,您按时完成了该任务"];
        }else{
            if (self.isAllDayEvent&&self.reminderTime.day == [[NSDate new]day]) {
                return [NSString stringWithFormat:@"今天之内一定要完成哦~"];
            }else{
                return [NSString stringWithFormat:@"时间结束,您没有按时完成该任务"];
            }
        }
    }else{
        if (self.isFinished) {
            return [NSString stringWithFormat:@"哇，您提前了%@，完成了该任务",[self descriptionForDateComponent:dc]];
        }else{
            return [NSString stringWithFormat:@"距离结束还有:%@,加油吧！",[self descriptionForDateComponent:dc]];
        }
    }
}
-(NSString *)timeRemainsOfDeadLine
{
    if ([self.reminderTime timeIntervalSinceNow]>0) {
        NSDateComponents *dc = [self dateComponentFromEndDate];
        return [NSString stringWithFormat:@"剩余时间：%@",[self descriptionForDateComponent:dc]];
    }else{
        return [[NSDateFormatter dateFormatterWithFormat:DEFAULT_DATE_FORMAT] stringFromDate:self.reminderTime];
    }
}

-(NSString*)descriptionForDateComponent:(NSDateComponents*)dc
{
    if (dc.year>0) {
        return [NSString stringWithFormat:@"%d年%d月%d天",dc.year,dc.month,dc.day];
    }else if (dc.month>0){
        return [NSString stringWithFormat:@"%d月%d天",dc.month,dc.day];
    }else if (dc.day>0){
        return [NSString stringWithFormat:@"%d天%d小时",dc.day,dc.hour];
    }else{
        return [NSString stringWithFormat:@"%02.0f小时%02.0f分钟",(float)dc.hour,(float)dc.minute];
    }
}

-(NSDateComponents *)dateComponentFromEndDate
{
    NSCalendar *cld = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [cld components:unitFlags fromDate:[NSDate date] toDate:self.reminderTime options:0];
}

-(UIColor *)itemThemeColor
{
    if (self.isImportant && self.isUrgency) {
        return COLOR_HIGH_ENGRCY;
    }else if (self.isImportant && !self.isUrgency){
        return COLOR_HIGH;
    }else if (!self.isImportant && self.isUrgency){
        return COLOR_ENGRCY
    }else{
        return COLOR_NORMAL;
    }
}

@end
