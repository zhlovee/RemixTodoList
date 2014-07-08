//
//  UIView+Overlayer.m
//  InBike
//
//  Created by Schiffer Li on 11/27/13.
//  Copyright (c) 2013 Augmentum. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "SmartUtility.h"

/////////////////////////Log utiltiy
static void append(NSString *msg){
    // get path to Documents/somefile.txt
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"logfile.txt"];
    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        fprintf(stderr,"Creating file at %s",[path UTF8String]);
        [[NSData data] writeToFile:path atomically:YES];
    }
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}
void X_Log(NSString *prefix, const char *funcName,int lineNumber, NSString *format,...) {
    NSArray *loglevels = [NSArray arrayWithObjects:@"DEBUG",@"INFO",@"WARNING",@"ERROR",@"NONE", nil];
    long ind = [loglevels indexOfObject:prefix];
    long currentLogLevel = [loglevels indexOfObject:LOG_LEVEL];
    if (ind<currentLogLevel) {
        return;
    }
    
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
    va_end (ap);
    if (LOG_TO_CONSOLE) {
        fprintf(stderr,"%s[%s]%s:%d->%s",[[[NSDate date] description] UTF8String],[prefix UTF8String], funcName, lineNumber, [msg UTF8String]);
    }
    if (LOG_TO_FILE) {
        NSDateFormatter* dateFormatter = AH_AUTORELEASE([[NSDateFormatter alloc] init]);
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *messageToFile = [NSString stringWithFormat:@"%s[%@]%s[%d]%@",[dateString UTF8String],prefix,funcName,lineNumber,msg];
        append(messageToFile);
    }
    
    AH_RELEASE(msg);
}
@implementation UIView (Util)

/////////////////////Overlayer/////////////////
-(UIView *)overlayer
{
    UIView *v = objc_getAssociatedObject(self, @selector(overlayer));
    return v;
}
-(void)setOverlayer:(UIView *)overlayer
{
    objc_setAssociatedObject(self, @selector(overlayer), overlayer, OBJC_ASSOCIATION_ASSIGN);
    [self addSubview:overlayer];
}

/////////////////////Background image///////////////////
-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *view = (UIImageView *)[self viewWithTag:BG_IMAGE_TAG];
    if (!view) {
        UIImageView *v = AH_AUTORELEASE([[UIImageView alloc] initWithImage:backgroundImage]);
        v.frame = self.bounds;
        v.tag = BG_IMAGE_TAG;
        [self addSubview:v];
    }else{
        view.frame = self.bounds;
        [view setImage:backgroundImage];
    }
}
-(UIImage *)backgroundImage
{
    return [(UIImageView*)[self viewWithTag:BG_IMAGE_TAG] image];
}

/////////////////////Rolling Indicator///////////////
-(void)showOverlayWithBackgroundColor:(UIColor*)color
{
    UIView *view = [self viewWithTag:OVERLAY_VIEW_TAG];
    if (!view) {
        view = AH_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
        view.backgroundColor = color;
        view.alpha = 0.5;
        [self addSubview:view];
        view.tag = OVERLAY_VIEW_TAG;
    }
}
-(void)showOverlay
{
    [self showOverlayWithBackgroundColor:[UIColor whiteColor]];
}
-(void)removeOverlay
{
    [[self viewWithTag:OVERLAY_VIEW_TAG] removeFromSuperview];
}
-(void)startRolling
{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[self viewWithTag:ROLLING_INDICATOR_TAG];
    [self showOverlayWithBackgroundColor:[UIColor blackColor]];
    if (!aiv) {
        aiv = AH_AUTORELEASE([[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
        aiv.tag = ROLLING_INDICATOR_TAG;
        aiv.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:aiv];
    }
    [aiv startAnimating];
}
-(void)startRollingWithY:(CGFloat)y
{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[self viewWithTag:ROLLING_INDICATOR_TAG];
    [self showOverlayWithBackgroundColor:[UIColor blackColor]];
    if (!aiv) {
        aiv = AH_AUTORELEASE([[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
        aiv.tag = ROLLING_INDICATOR_TAG;
        aiv.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        aiv.centerY = y;
        [self addSubview:aiv];
    }
    [aiv startAnimating];
}
-(void)endRolling
{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[self viewWithTag:ROLLING_INDICATOR_TAG];
    [aiv stopAnimating];
    [aiv removeFromSuperview];
    [self removeOverlay];
}

////////////// edge insets///////////

/////////////////////No data label
-(void)showNoDataViewWithTitle:(NSString *)titile
{
    UILabel *l = (UILabel*)[self viewWithTag:NO_DATA_VIEW_TAG];
    if (!l) {
        l = AH_AUTORELEASE([[UILabel alloc]init]);
        l.tag = NO_DATA_VIEW_TAG;
    }
    l.text = titile;
    l.textColor = [UIColor grayColor];
    l.font = [UIFont systemFontOfSize:14];
    [l sizeToFit];
    l.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self addSubview:l];
}
-(void)removeNoDataView
{
    [[self viewWithTag:NO_DATA_VIEW_TAG] removeFromSuperview];
}

////////////////Stable Code///////////////////
-(void)placeAt:(UIView*)view
{
    self.frame = view.bounds;
    [view addSubview:self];
}
-(void)setCenterX:(CGFloat)x
{
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}
-(void)setCenterY:(CGFloat)y
{
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}
-(CGFloat)centerX
{
    return self.center.x;
}
-(CGFloat)centerY
{
    return self.center.y;
}
-(void)setSizeWidth:(CGFloat)sizeWidth
{
    CGRect r = self.frame;
    r.size.width = sizeWidth;
    self.frame = r;
}
-(CGFloat)sizeWidth
{
    return self.frame.size.width;
}
-(void)setSizeHeight:(CGFloat)sizeHeight
{
    CGRect r = self.frame;
    r.size.height = sizeHeight;
    self.frame = r;
}
-(CGFloat)sizeHeight
{
    return self.frame.size.height;
}
-(void)setOriginX:(CGFloat)originX
{
    CGRect r = self.frame;
    r.origin.x = originX;
    self.frame = r;
}
-(CGFloat)originX
{
    return self.frame.origin.x;
}
-(void)setOriginY:(CGFloat)originY
{
    CGRect r = self.frame;
    r.origin.y = originY;
    self.frame = r;
}
-(CGFloat)originY
{
    return self.frame.origin.y;
}
-(void)dumpView
{
    //    for (UIView *view in self.subviews) {
    //        if (view) {
    ////            printf("%s",[NSStringFromClass(view.superview.class) UTF8String]);
    //            for (int i=0; i<deep; i++) {
    //                printf("%s",line);
    //            }
    //            printf("%s\n",[[view description]UTF8String]);
    //            if (view.subviews && view.subviews.count>0) {
    //                [view dumpView];
    //            }
    //        }
    //    }
    //    if (self.subviews && self.subviews.count>0) {
    //        deep++;
    //    }else{
    //        deep--;
    //    }
    //抄代码的同时，膜拜一下大神~!~
    printf("%s\n",[[self tx_recursiveLayoutDescription] UTF8String]);
}
-(NSString *)dumpString
{
    return [self tx_recursiveDescription];
}
- (NSString *)tx_recursiveDescription
{
    NSMutableString *s = [NSMutableString string];
    
    typedef void (^block_t)(UIView *view, int depth);
    
    __weak __block block_t recurse;
    block_t block;
    recurse = block = ^(UIView *view, int depth)
    {
        NSString *theIndent = [@"" stringByPaddingToLength:depth * 4 withString:@"   |" startingAtIndex:0];
        [s appendFormat:@"%@%@\n", theIndent, [view description]];
        for (UIView *theSubview in view.subviews)
        {
            recurse(theSubview, depth + 1);
        }
    };
    block(self, 0);
    
    return(s);
}
- (NSString *)tx_recursiveLayoutDescription
{
    NSMutableString *s = [NSMutableString string];
    
    typedef void (^block_t)(UIView *view, int depth);
    
    __weak __block block_t recurse;
    block_t block;
    recurse = block = ^(UIView *view, int depth)
    {
        NSString *theIndent = [@"" stringByPaddingToLength:depth * 4 withString:@"   |" startingAtIndex:0];
        [s appendFormat:@"%@%@\n", theIndent, [view description]];
        for (NSLayoutConstraint *theConstraint in view.constraints)
        {
            [s appendFormat:@"%@   * %@\n", theIndent, [theConstraint description]];
        }
        for (UIView *theSubview in view.subviews)
        {
            recurse(theSubview, depth + 1);
        }
    };
    block(self, 0);
    
    return(s);
}
-(void)highlightSubviews
{
    for (UIView *view in self.subviews) {
        //use boder wrappered
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [[UIColor randomColor] CGColor];
        
        //        view.backgroundColor = [UIColor randomColor];
        //        view.alpha = .5;
        
        if (self.subviews.count>0) {
            [view highlightSubviews];
        }
    }
}
-(CGSize)sizeWH
{
    return self.frame.size;
}
-(void)setSizeWH:(CGSize)sizeWH
{
    CGRect r = self.frame;
    r.size = sizeWH;
    self.frame = r;
}
-(CGPoint)originPoint
{
    return self.frame.origin;
}
-(void)setOriginPoint:(CGPoint)originPoint
{
    CGRect r = self.frame;
    r.origin = originPoint;
    self.frame = r;
}
-(CGPoint)rightBottomCorner
{
    return CGPointMake(self.originX + self.sizeWidth, self.originY + self.sizeHeight);
}
+(UIView *)viewWithFrame:(CGRect)frame
{
    return AH_AUTORELEASE([[UIView alloc]initWithFrame:frame]);
}
-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}
-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}
@end

@implementation UILabel (Util)

+(UILabel*)labelWithText:(NSString*)text fontSize:(int)size color:(UIColor*)color
{
    UILabel *label = AH_AUTORELEASE([[UILabel alloc] init]);
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    return label;
}
@end
@implementation UIColor (Util)
+(UIColor *)color255WithRed:(int)red green:(int)green blue:(int)blue
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}
+(UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
@end

@implementation UIImage (Util)
+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle
{
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[bundle bundlePath], name]];
}
+ (UIImage *)bundleImageNamed:(NSString *)name
{
	return [self imageNamed:name bundle:[NSBundle mainBundle]];
}
+(UIImage*)resizedImageNamed:(NSString*)name
{
    UIImage *img = [UIImage imageNamed:name];
    
    CGSize size=img.size;
    CGFloat x=ceilf(size.width*.5);
    CGFloat y=ceilf(size.height*.5);
    if([img respondsToSelector:@selector(resizableImageWithCapInsets:)])
        img=[img resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y+1, x+1)];
    else
        img=[img stretchableImageWithLeftCapWidth:x topCapHeight:y];
    
    return img;
}
-(void)resizeImageByCenterStretch
{
    //TODO Not Implemented yet
    //    CGSize size=self.size;
    //    CGFloat x=ceilf(size.width*.5);
    //    CGFloat y=ceilf(size.height*.5);
    //    if([self respondsToSelector:@selector(resizableImageWithCapInsets:)])
    //        self=[self resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y+1, x+1)];
    //    else
    //        self=[self stretchableImageWithLeftCapWidth:x topCapHeight:y];
}
@end
@implementation UIImageView (Util)
-(void)setImageWithUrlString:(NSString *)urlStr
{
    //    [self startRolling];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURL * url = [NSURL URLWithString:urlStr];
        NSData * data = AH_AUTORELEASE([[NSData alloc]initWithContentsOfURL:url]);
        UIImage *image = [UIImage imageWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self endRolling];
                self.image = image;
            });
        }else{
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [self endRolling];
            //            });
        }
    });
}
-(void)setImageWithUrlString:(NSString *)urlStr placeHolderImage:(UIImage *)img
{
    self.image = img;
    [self setImageWithUrlString:urlStr];
}
@end

@implementation UIButton (Util)
-(void)bindTouchUpInsideEventCallback:(SmartButtonCallback)fn
{
    [self setCallBack:fn];
    [self addTarget:self action:@selector(invokeCallback) forControlEvents:UIControlEventTouchUpInside];
}
-(void)invokeCallback
{
    __block UIButton *btn = self;
    self.callback(btn);
}
-(void)setCallBack:(SmartButtonCallback)callBack
{
    objc_setAssociatedObject(self, @selector(callback), callBack, OBJC_ASSOCIATION_COPY);
}
-(SmartButtonCallback)callback
{
    return objc_getAssociatedObject(self, @selector(callback));
}
@end

@implementation UIAlertView (Util)
-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    return [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
}
-(void)setCallBack:(SmartAlertCallback)callBack
{
    objc_setAssociatedObject(self, @selector(callBack), callBack, OBJC_ASSOCIATION_COPY);
}
-(SmartAlertCallback)callBack
{
    return objc_getAssociatedObject(self, @selector(callBack));
}
-(void)showWithCompletion:(SmartAlertCallback)completeBlock
{
    if (completeBlock) {
        self.callBack = completeBlock;
    }
    self.delegate = self;
    [self show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.callBack) {
        self.callBack(buttonIndex);
        //released resources when the call back invoked
        self.callBack = nil;
    }
}
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    AH_RELEASE(alert);
}
@end
@implementation UIScrollView (Layout)
-(void)handleScrollWithTarget:(UIScrollView *)target
{
    if ([target isKindOfClass:self.class]) {
        
    }
}
-(CGFloat)contentInsetTop
{
    return self.contentInset.top;
}
-(void)setContentInsetTop:(CGFloat)contentInsetTop
{
    UIEdgeInsets inst = self.contentInset;
    inst.top = contentInsetTop;
    self.contentInset = inst;
}
-(void)setContentInsetTop:(CGFloat)contentInsetTop animated:(BOOL)animated
{
    if (animated) {
        UIEdgeInsets inst = self.contentInset;
        inst.top = contentInsetTop;
        [UIView animateWithDuration:.5 animations:^{
            self.contentInset = inst;
        }];
    }else{
        [self setContentInsetTop:contentInsetTop];
    }
}
@end
static void *SUSwizzlingBlockKey = "SUSwizzlingBlockKey";
@implementation NSObject (Trace)
-(void)swizzlingWithOriginalSEL:(SEL)origin targetSEL:(SEL)target
{
    Method m1 = class_getInstanceMethod([self class], origin);
    Method m2 = class_getInstanceMethod([self class], target);
    method_exchangeImplementations(m1, m2);
}
static dispatch_once_t onceToken;
-(void)swizzlingOriginalSEL:(SEL)origin withBlock:(void (^)(void))callback
{
    void (^block)(void) = objc_getAssociatedObject(self, SUSwizzlingBlockKey);
    if (block) {
        AH_RELEASE(block);
        objc_removeAssociatedObjects(block);
    }
    objc_setAssociatedObject(self, SUSwizzlingBlockKey, callback, OBJC_ASSOCIATION_COPY);
    
    dispatch_once(&onceToken, ^{
        Method m1 = class_getInstanceMethod([self class], origin);
        Method m2 = class_getInstanceMethod([self class], @selector(swizzlingInvocation));
        method_exchangeImplementations(m1, m2);
    });
}
-(void)swizzlingInvocation
{
    void (^block)(void) = objc_getAssociatedObject(self, SUSwizzlingBlockKey);
    if (block) {
        block();
        //make sure it has been swizzled
        if (onceToken) {
            [self swizzlingInvocation];
        }
    }
}
+(void)trace:(id)target
{
    NSLog(@"%@",target);
}
+(void)traceBool:(BOOL)value
{
    if (value) {
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
}
+(void)traceDouble:(double)value
{
    NSLog(@"%f",value);
}
+(void)traceFloat:(float)value
{
    NSLog(@"%f",value);
}
+(void)traceInt:(int)value
{
    NSLog(@"%d",value);
}
+(void)traceLong:(long)value
{
    NSLog(@"%ld",value);
}
+(void)tracePoint:(CGPoint)point
{
    NSLog(@"x = %f, y = %f",point.x,point.y);
}
+(void)traceSize:(CGSize)size
{
    NSLog(@"width = %f, heihg = %f",size.width,size.height);
}
+(void)traceRect:(CGRect)rect
{
    NSLog(@"frame = (%f %f; %f %f)", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}
@end

@implementation NSString (Util)
-(NSString*)safeString
{
    return self?self:@"";
}
-(NSString*)cnNumber
{
    long num = [self intValue];
    NSMutableString *rst = [NSMutableString string];
    if (num/100000000 >= 1) {
        NSString *str = [NSString stringWithFormat:@"%ld亿",num/100000000];
        [rst appendString:str];
        
        num = num % 100000000;
        if (num/10000 >= 1) {
            [rst appendFormat:@"%ld万",num/10000];
        }
    }else{
        num = num % 100000000;
        if (num/10000 >= 1) {
            [rst appendFormat:@"%ld万",num/10000];
        }else{
            return [NSString stringWithFormat:@"%ld元",num];
        }
    }
    return rst;
}
@end

@interface SmartView ()
@property(nonatomic,copy)SmartViewCallback startCallback;
@property(nonatomic,copy)SmartViewCallback endCallback;
@property(nonatomic,copy)SmartViewCallback cancelCallback;
@end
@implementation SmartView

-(void)dealloc
{
    self.startCallback = nil;
    self.endCallback = nil;
    self.cancelCallback = nil;

    AH_SUPER_DEALLOC;
}

+(SmartView*)smartViewWithSuperView:(UIView *)view
{
    SmartView *sv = AH_AUTORELEASE([[SmartView alloc]initWithFrame:view.bounds]);
    [view addSubview:sv];
    return sv;
}

-(void)bindTouchStartCallback:(SmartViewCallback)fn1 touchEndCallback:(SmartViewCallback)fn2 touchCancelCallback:(SmartViewCallback)fn3
{
    self.startCallback = fn1;self.endCallback = fn2;self.cancelCallback = fn3;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.startCallback) {
        self.startCallback(self);
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (self.cancelCallback) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block SmartView *sv = self;
            self.cancelCallback(sv);
        });
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.endCallback) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block SmartView *sv = self;
            self.endCallback(sv);
        });
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

@end

@implementation UIViewController (Util)

-(void)showBusyIndicatorHud
{
    UIView *hud = [self.view viewWithTag:VC_BUSY_HUD_TAG];
    if (hud) {
        return;
    }

    UIView *hudWrapper = AH_AUTORELEASE([[UIView alloc]init]);
    hudWrapper.backgroundColor = [UIColor clearColor];
    hudWrapper.sizeWH = CGSizeMake(105, 90);
    hudWrapper.tag = VC_BUSY_HUD_TAG;
    
    hud = AH_AUTORELEASE([[UIView alloc]initWithFrame:hudWrapper.bounds]);
    hud.backgroundColor = [UIColor blackColor];
    hud.alpha = .5;
    hud.cornerRadius = 12;
    hud.layer.masksToBounds = YES;
    [hudWrapper addSubview:hud];
    
    UILabel *label = [UILabel labelWithText:@"正在加载..." fontSize:13 color:[UIColor whiteColor]];
    label.center = CGPointMake(hudWrapper.sizeWidth/2, hudWrapper.sizeHeight/2+20);
    [hudWrapper addSubview:label];
    
    [self.view addSubview:hudWrapper];
    hudWrapper.center = CGPointMake(self.view.sizeWidth/2, self.view.sizeHeight/2);
    [hud startRollingWithY:hud.sizeHeight/2-label.sizeHeight+5];
}
-(void)hideBusyIndicatorHud
{
    UIView *hud = [self.view viewWithTag:VC_BUSY_HUD_TAG];
    if (hud) {
        [hud performSelectorOnMainThread:@selector(endRolling) withObject:nil waitUntilDone:YES];
        [hud performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    }
}
-(void)presentToViewController:(UIViewController*)toVc
{
    if([self.navigationController respondsToSelector:@selector(presentViewController:animated:completion:)])
        [self.navigationController presentViewController:toVc animated:YES completion:nil];
    else
        [self.navigationController presentModalViewController:toVc animated:YES];
    
}
-(UINavigationController *)wrapperedNavigationController
{
    UINavigationController *nav = AH_AUTORELEASE([[UINavigationController alloc]initWithRootViewController:self]);
    return nav;
}
@end

@implementation NSDateFormatter (Util)

+(NSDateFormatter*)dateFormatterWithFormat:(NSString *)format
{
    NSDateFormatter *df = AH_AUTORELEASE([[NSDateFormatter alloc]init]);
    [df setDateFormat:format];
    return df;
}

@end
//
//  NSDate+convenience.m
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  update by Schiffer Li 2014/06
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//
@implementation NSDate (Convenience)
-(NSString *)descriptionFromNow
{
    if ([self timeIntervalSinceNow]>0) {
        NSDateComponents *dc = [self dateComponentFromEndDate];
        return [self descriptionForDateComponent:dc];
    }else{
        return nil;
    }
}

-(NSDateComponents *)dateComponentFromEndDate
{
    NSCalendar *cld = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [cld components:unitFlags fromDate:[NSDate date] toDate:self options:0];
}

-(NSString*)descriptionForDateComponent:(NSDateComponents*)dc
{
    if (dc.year>0) {
        return [NSString stringWithFormat:@"%d年%d月%d天",dc.year,dc.month,dc.day];
    }else if (dc.month>0){
        return [NSString stringWithFormat:@"%d月%d天",dc.month,dc.day];
    }else if (dc.day>0){
        return [NSString stringWithFormat:@"%d天%02.0f小时",dc.day,(float)dc.hour];
    }else if (dc.hour>0){
        return [NSString stringWithFormat:@"%2.0f小时%02.0f分",(float)dc.hour,(float)dc.minute];
    }else{
        return [NSString stringWithFormat:@"%2.0f分%02.0f秒",(float)dc.minute,(float)dc.second];
    }
}


-(NSCalendar*)_defaultCalendar_q
{
    return AH_AUTORELEASE([[NSCalendar alloc]
                           initWithCalendarIdentifier:NSGregorianCalendar]);
}

-(int)year {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}
-(int)month {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}
-(int)day {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:self];
    return [components day];
}
-(int)hour {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    NSDateComponents *components = [gregorian components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}
-(int)minute {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    NSDateComponents *components = [gregorian components:NSMinuteCalendarUnit fromDate:self];
    return [components minute];
}
-(int)second {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    NSDateComponents *components = [gregorian components:NSSecondCalendarUnit fromDate:self];
    return [components second];
}
-(int)firstWeekDayInMonth {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    [gregorian setFirstWeekday:2]; //monday is first day
    //[gregorian setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"]];
    
    //Set date to first of month
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:newDate];
}

-(NSDate *)offsetMonth:(int)numMonths {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = AH_AUTORELEASE([[NSDateComponents alloc] init]);
    [offsetComponents setMonth:numMonths];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetHours:(int)hours {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = AH_AUTORELEASE([[NSDateComponents alloc] init]);
    //[offsetComponents setMonth:numMonths];
    [offsetComponents setHour:hours];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

-(NSDate *)offsetDay:(int)numDays {
    NSCalendar *gregorian = [self _defaultCalendar_q];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = AH_AUTORELEASE([[NSDateComponents alloc] init]);
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}



-(int)numDaysInMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

+(NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = AH_AUTORELEASE([[NSCalendar alloc]
                                            initWithCalendarIdentifier:NSGregorianCalendar]);
    
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: date];
    return [gregorian dateFromComponents:components];
}

+(NSDate *)dateStartOfWeek {
    NSCalendar *gregorian = AH_AUTORELEASE([[NSCalendar alloc]
                                            initWithCalendarIdentifier:NSGregorianCalendar]);
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *componentsToSubtract = AH_AUTORELEASE([[NSDateComponents alloc] init]);
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}

+(NSDate *)dateEndOfWeek {
    NSCalendar *gregorian = AH_AUTORELEASE([[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]);
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    
    NSDateComponents *componentsToAdd = AH_AUTORELEASE([[NSDateComponents alloc] init]);
    [componentsToAdd setDay: + (((([components weekday] - [gregorian firstWeekday])
                                  + 7 ) % 7))+6];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: endOfWeek];
    
    //gestript
    endOfWeek = [gregorian dateFromComponents: componentsStripped];
    return endOfWeek;
}
@end

