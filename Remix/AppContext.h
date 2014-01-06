//
//  AppContext.h
//  Remix
//
//  Created by Schiffer Li on 12/4/13.
//  Copyright (c) 2013 Schiffer Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIViewDeckController.h"

@interface AppContext : NSObject

+(void)init;
+(IIViewDeckController *)sharedDeckView;

@end
