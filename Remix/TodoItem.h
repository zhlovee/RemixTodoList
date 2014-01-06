//
//  TodoItem.h
//  Remix
//
//  Created by Schiffer Li on 12/28/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TodoSubItem;

@interface TodoItem : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * important;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * urgency;
@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSNumber * allDayEvent;
@property (nonatomic, retain) NSDate * reminderTime;
@property (nonatomic, retain) NSOrderedSet *subItems;
@end

@interface TodoItem (CoreDataGeneratedAccessors)

- (void)insertObject:(TodoSubItem *)value inSubItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubItemsAtIndex:(NSUInteger)idx;
- (void)insertSubItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubItemsAtIndex:(NSUInteger)idx withObject:(TodoSubItem *)value;
- (void)replaceSubItemsAtIndexes:(NSIndexSet *)indexes withSubItems:(NSArray *)values;
- (void)addSubItemsObject:(TodoSubItem *)value;
- (void)removeSubItemsObject:(TodoSubItem *)value;
- (void)addSubItems:(NSOrderedSet *)values;
- (void)removeSubItems:(NSOrderedSet *)values;
@end
