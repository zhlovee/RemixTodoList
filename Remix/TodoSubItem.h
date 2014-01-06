//
//  TodoSubItem.h
//  Remix
//
//  Created by Schiffer Li on 12/27/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TodoItem;

@interface TodoSubItem : NSManagedObject

@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TodoItem *superItem;

@end
