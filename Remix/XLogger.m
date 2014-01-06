//
//  XLogger.m
//  Episode
//
//  Created by Schiffer Li on 11/20/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "XLogger.h"
#import "NSObject+DebuggingAid.h"

typedef enum{
    Level_Debug,
    Level_Info,
    Level_Warning,
    Level_Error
}LOG_LEVEL;

NSArray *LogLevelNames(){
    static  NSArray *logLevels = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logLevels = [NSArray arrayWithObjects:@"DEBUG",@"INFO",@"WARNING",@"ERROR", nil];
    });
    return logLevels;
}
NSString *nameOfLevel(LOG_LEVEL level){
    return LogLevelNames()[level];
}
LOG_LEVEL levelOfName(NSString *str){
    return [LogLevelNames() indexOfObject:str];
}

void _Log(NSString *prefix, const char *functionName, int lineNumber, NSString *format,...){
    if (levelOfName(prefix) < levelOfName(CURRENT_LOG_LEVEL)) {
        return;
    }
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
    va_end (ap);
    fprintf(stderr,"[%s]%s:-----%d----\n%s",[prefix UTF8String], functionName, lineNumber, [msg UTF8String]);
}
@interface XLogger ()

@property LOG_LEVEL currentLevel;

@end

@implementation XLogger

static XLogger *instance;
+(XLogger *)shared
{
    @synchronized([XLogger class]) {
        if (instance == nil) {
            instance = [XLogger new];
            instance.currentLevel = levelOfName(CURRENT_LOG_LEVEL);
        }
    }

    return instance;
}

-(void)debug:(NSString *)msg
{
    if (self.currentLevel >= Level_Debug) {
        [self log:msg withLevel:Level_Debug];
    }
}

-(void)info:(NSString *)msg
{
    if (self.currentLevel >= Level_Info) {
        [self log:msg withLevel:Level_Info];
    }
}

-(void)warn:(NSString *)msg
{
    if (self.currentLevel >= Level_Warning) {
        [self log:msg withLevel:Level_Warning];
    }
}

-(void)error:(NSString *)msg
{
    if (self.currentLevel >= Level_Warning) {
        [self log:msg withLevel:Level_Error];
    }
}

-(void)log:(NSString *)msg withLevel:(LOG_LEVEL)level
{
    fprintf(stderr,"\n----[%s] %s---%s\n%s",[nameOfLevel(level) UTF8String],[[[NSDate date] description]UTF8String],[self.prefix UTF8String], [msg UTF8String]);
//    NSLog(@"---------[%@]--------\n %@",nameOfLevel(level), msg);
}

-(void)trace:(id)target
{
    if ([target isKindOfClass:[NSString class]]) {
        [self debug:target];
    }else{
        [self debug:[target dump]];
    }
}
-(void)tracePoint:(CGPoint)point
{
    [self debug:[NSString stringWithFormat:@"x = %f, y = %f",point.x,point.y]];
}
-(void)traceRect:(CGRect)rect
{
    [self debug:[NSString stringWithFormat:@"frame = (%f %f; %f %f)", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height]];
}
-(void)traceBool:(BOOL)value
{
    [self debug:[NSString stringWithFormat:@"%@", value ? @"YES" : @"NO"]];
}
-(void)traceDouble:(double)value
{
    [self debug:[NSString stringWithFormat:@"%f",value]];
}
-(void)traceFloat:(float)value
{
    [self debug:[NSString stringWithFormat:@"%f",value]];
}
-(void)traceInt:(int)value
{
    [self debug:[NSString stringWithFormat:@"%d",value]];
}
-(void)traceLong:(long)value
{
    [self debug:[NSString stringWithFormat:@"%ld",value]];
}
@end