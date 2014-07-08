//
//  Smart Utility
//
//  Created by Schiffer Li on 11/27/13.
//  Last Update by Schiffer Li on 2014/04/02
//  Copyright (c) 2014 李正浩. All rights reserved.
//

////////////////////////// debug framework  ///////////////////////
//@"DEBUG",@"INFO",@"WARNING",@"ERROR",@"NONE"
#define LOG_LEVEL           @"INFO"

#define LOG_TO_FILE         1
#define LOG_TO_CONSOLE      1
#define PTLOG(args...) X_Log(@"INFO", __PRETTY_FUNCTION__,__LINE__ ,args );
#define XLogError(args...)  X_Log(@"ERROR",__PRETTY_FUNCTION__,__LINE__,args);
#define XLogWarning(args...)  X_Log(@"WARNING",__PRETTY_FUNCTION__,__LINE__,args);
#define XLogDebug(args...)  X_Log(@"DEBUG",__PRETTY_FUNCTION__,__LINE__,args);
#define XLogInfo(args...) X_Log(@"INFO",__PRETTY_FUNCTION__,__LINE__,args);

//////////////////////////Smart Categroy/////////////////////////

//Change this tag if occured crashed
#define NO_DATA_VIEW_TAG 394534
#define ROLLING_INDICATOR_TAG 231025
#define OVERLAY_VIEW_TAG 1652457
#define BG_IMAGE_TAG 5858241
#define VC_BUSY_HUD_TAG 421251

void X_Log(NSString *prefix, const char *funcName,int lineNumber, NSString *format,...);
@interface UIView (Util)

@property(nonatomic,assign) CGFloat originX;
@property(nonatomic,assign) CGFloat originY;
@property(nonatomic,assign) CGPoint originPoint;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;
@property(nonatomic,assign) CGFloat sizeWidth;
@property(nonatomic,assign) CGFloat sizeHeight;
@property(nonatomic,assign) CGSize sizeWH;
@property(nonatomic,assign) CGFloat cornerRadius;
@property(nonatomic,assign,readonly) CGPoint rightBottomCorner;
@property(nonatomic,assign) UIImage *backgroundImage;
@property(nonatomic,assign) UIView *overlayer;

-(void)showNoDataViewWithTitle:(NSString *)titile;
-(void)removeNoDataView;
-(void)showOverlay;
-(void)showOverlayWithBackgroundColor:(UIColor*)color;
-(void)removeOverlay;
-(void)startRolling;
-(void)endRolling;

-(void)placeAt:(UIView*)view;
-(void)dumpView;
-(NSString *)dumpString;
-(void)highlightSubviews;

+(UIView*)viewWithFrame:(CGRect)frame;

@end

@interface UILabel (Util)

+(UILabel*)labelWithText:(NSString*)text fontSize:(int)size color:(UIColor*)color;

@end

@interface UIColor (Util)

+(UIColor *)randomColor;
+(UIColor *)color255WithRed:(int)red green:(int)green blue:(int)blue;

@end

@interface UIImage (Util)

+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle;
+ (UIImage *)bundleImageNamed:(NSString *)name;
+(UIImage*)resizedImageNamed:(NSString*)name;
-(void)resizeImageByCenterStretch;

@end
@interface NSString (Util)
-(NSString*)safeString;
-(NSString*)cnNumber;
@end
@interface NSObject (Trace)

+(void)trace:(id) target;
+(void)tracePoint:(CGPoint)point;
+(void)traceSize:(CGSize)size;
+(void)traceRect:(CGRect)rect;
+(void)traceBool:(BOOL)value;
+(void)traceInt:(int)value;
+(void)traceLong:(long)value;
+(void)traceFloat:(float)value;
+(void)traceDouble:(double)value;
-(void)swizzlingWithOriginalSEL:(SEL)origin targetSEL:(SEL)target;
//insert callback function before the selector executed
-(void)swizzlingOriginalSEL:(SEL)origin withBlock:(void (^)(void))callback;

@end

@interface UIImageView (Util)

-(void)setImageWithUrlString:(NSString*)urlStr;
-(void)setImageWithUrlString:(NSString*)urlStr placeHolderImage:(UIImage*)img;

@end

typedef void (^SmartAlertCallback) (NSUInteger buttonIndex);

@interface UIAlertView (Util)

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
//不需要delegate回调的清况. 只有个OKbutton的Alert
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
//不用delegate,采用回调
-(void)showWithCompletion:(SmartAlertCallback)completeBlock;

@end

@interface UIScrollView (Layout)
@property(nonatomic,assign)CGFloat contentInsetTop;
-(void)setContentInsetTop:(CGFloat)contentInsetTop animated:(BOOL)animated;
@end


typedef void (^SmartButtonCallback) (UIButton *sv);
@interface UIButton (Util)

-(void)bindTouchUpInsideEventCallback:(SmartButtonCallback)fn;

@end

@interface UIViewController (Util)

-(void)showBusyIndicatorHud;
-(void)hideBusyIndicatorHud;
-(UINavigationController*)wrapperedNavigationController;
-(void)presentToViewController:(UIViewController*)toVc;

@end

//@protocol SmartViewDelegate <NSObject>
//
//-(void)smartViewDidTouchHighlight:(SmartView*)sv;
//-(void)smartViewDidEndTouchHighlight:(SmartView*)sv;
//
//@end
@class SmartView;
typedef void (^SmartViewCallback) (SmartView *sv);
@interface SmartView : UIView

-(void)bindTouchStartCallback:(SmartViewCallback)fn1 touchEndCallback:(SmartViewCallback)fn2 touchCancelCallback:(SmartViewCallback)fn3;
+(SmartView*)smartViewWithSuperView:(UIView*)view;

@end
@interface NSDateFormatter (Util)
+(NSDateFormatter*)dateFormatterWithFormat:(NSString*)format;
@end
//
//  NSDate+convenience.h
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//
@interface NSDate (Convenience)

-(NSString*)descriptionFromNow;
-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(int)numDaysInMonth;
-(int)firstWeekDayInMonth;
-(int)year;
-(int)month;
-(int)day;
-(int)hour;
-(int)minute;
-(int)second;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;

@end

//---------------------------------------------------------------------------------------------
//  ARC Helper
//
//  Version 1.3
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325

#import <UIKit/UIKit.h>

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) (x)
#define AH_RELEASE(x) (void)(x)
#define AH_AUTORELEASE(x) (x)
#define AH_SUPER_DEALLOC (void)(0)
#define __AH_BRIDGE __bridge
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [(x) retain]
#define AH_RELEASE(x) [(x) release]
#define AH_AUTORELEASE(x) [(x) autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#define __AH_BRIDGE
#endif
#endif

//  Weak reference support

#ifndef AH_WEAK

#if defined __IPHONE_OS_VERSION_MIN_REQUIRED

#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_4_3

#define __AH_WEAK __weak

#define AH_WEAK weak

#else

#define __AH_WEAK __unsafe_unretained

#define AH_WEAK unsafe_unretained

#endif

#elif defined __MAC_OS_X_VERSION_MIN_REQUIRED

#if __MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_6

#define __AH_WEAK __weak

#define AH_WEAK weak

#else

#define __AH_WEAK __unsafe_unretained

#define AH_WEAK unsafe_unretained

#endif

#endif

#endif
//  ARC Helper ends
