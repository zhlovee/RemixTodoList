//
//  XLogger.h
//  Episode
//
//  Created by Schiffer Li on 11/20/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define XLOG(fmt, ...) NSLog((@"%s [Line %d] --- \n  " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define PTLOG(args...) _Log(@"INFO", __PRETTY_FUNCTION__,__LINE__ ,args );
#define LogError(args...)  _Log(@"ERROR",__PRETTY_FUNCTION__,__LINE__,args);
#define LogWarning(args...)  _Log(@"WARNING",__PRETTY_FUNCTION__,__LINE__,args);
#define LogDebug(args...)  _Log(@"DEBUG",__PRETTY_FUNCTION__,__LINE__,args);
#define LogInfo(args...) _Log(@"INFO",__PRETTY_FUNCTION__,__LINE__,args);

#define LOGGER [XLogger shared]

#define CURRENT_LOG_LEVEL @"DEBUG"

@interface XLogger : NSObject
void _Log(NSString *prefix, const char *functionName, int lineNumber, NSString *format,...);

+(XLogger *)shared;

@property(nonatomic,strong) NSString* prefix;
-(void)debug:(NSString *)msg;
-(void)info:(NSString *)msg;
-(void)warn:(NSString *)msg;
-(void)error:(NSString *)msg;
-(void)trace:(id) target;
-(void)tracePoint:(CGPoint)point;
-(void)traceRect:(CGRect)rect;
-(void)traceBool:(BOOL)value;
-(void)traceInt:(int)value;
-(void)traceLong:(long)value;
-(void)traceFloat:(float)value;
-(void)traceDouble:(double)value;
@end