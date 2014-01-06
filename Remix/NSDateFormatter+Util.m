//
//  NSDateFormatter+Util.m
//  Remix
//
//  Created by Schiffer Li on 12/27/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import "NSDateFormatter+Util.h"

@implementation NSDateFormatter (Util)

+(NSDateFormatter *)dateFormatterWithString:(NSString *)fmt
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:fmt];
    return df;
}

+(NSDateFormatter *)defautlDateFormtter
{
    return [NSDateFormatter dateFormatterWithString:DEFAULT_DATE_FORMAT];
}

@end
