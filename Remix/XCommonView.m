//
//  CommonView.m
//  Episode
//
//  Created by Schiffer Li on 10/17/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "XCommonView.h"
#import "Gobal.h"

@interface XCommonView (){
    float edge;
    float corner;
}

//@property(strong, nonatomic) NSMutableDictionary *positionMapping;

@end

@implementation XCommonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        _positionMapping = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        _positionMapping = [NSMutableDictionary dictionary];
    }
    return self;
}

//util method
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"corner"]) {
        if (value) {
            corner = [value floatValue];
        }else{
            corner = 0;
        }
        self.cornerRadius = corner;
        self.layer.masksToBounds = YES;
    }
}

//memory view
//-(void)storeCurrentPositionWithKey:(NSString *)key
//{
//    [self addPositionWithRect:self.frame withKey:key];
//}
//-(void)addPositionWithRect:(CGRect) frame withKey:(NSString *)key
//{
//    [_positionMapping setObject:[NSValue valueWithCGRect:frame] forKey:key];
//}
//
//-(void)recoverPositionWithKey:(NSString *)key
//{
//    CGRect f = [self positionInMemoryWithKey:key];
//    if (!CGRectIsNull(f)) {
//        self.frame = f;
//    }
//}
//
//-(CGRect)positionInMemoryWithKey:(NSString *)key
//{
//    NSValue *value = [_positionMapping objectForKey:key];
//    return value.CGRectValue;
//}

@end
