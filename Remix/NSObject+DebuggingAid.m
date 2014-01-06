//
//  NSObject+DebuggingAid.m
//  Episode
//
//  Created by Schiffer Li on 11/21/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "NSObject+DebuggingAid.h"
#import <objc/runtime.h>

@implementation NSObject (DebuggingAid)

- (NSString*)dump
{
    if ([self isKindOfClass:[NSNumber class]] ||
        [self isKindOfClass:[NSString class]] ||
        [self isKindOfClass:[NSValue class]])
    {
        return [NSString stringWithFormat:@"%@", self];
    }
    
    Class class = [self class];
    u_int count;
    
    Ivar* ivars = class_copyIvarList(class, &count);
    NSMutableDictionary* ivarDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* ivarName = ivar_getName(ivars[i]);
        NSString *ivarStr = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
        id obj = [self valueForKey:ivarStr];
        if (obj == nil)
        {
            obj = [NSNull null];
        }
        [ivarDictionary setObject:obj forKey:ivarStr];
    }
    free(ivars);
    
    objc_property_t* properties = class_copyPropertyList(class, &count);
    NSMutableDictionary* propertyDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        NSString *propertyStr = [NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        id obj = [self valueForKey:propertyStr];
        if (obj == nil)
        {
            obj = [NSNull null];
        }
        [propertyDictionary setObject:obj forKey:propertyStr];
    }
    free(properties);
    
    NSDictionary* classDump = [NSDictionary dictionaryWithObjectsAndKeys:
                               ivarDictionary, @"ivars",
                               propertyDictionary, @"properties",
                               nil];
    NSString *dumpStr = [NSString stringWithFormat:@"%@", classDump];
    
    return dumpStr;
}
@end
