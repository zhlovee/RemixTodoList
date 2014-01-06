//
//  NSDateFormatter+Util.h
//  Remix
//
//  Created by Schiffer Li on 12/27/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_DATE_FORMAT @"yyyy/MM/dd HH:mm"

@interface NSDateFormatter (Util)

+(NSDateFormatter*)dateFormatterWithString:(NSString*)fmt;
+(NSDateFormatter*)defautlDateFormtter;

@end
