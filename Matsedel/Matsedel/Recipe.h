//
//  Recipe.h
//  Matsedel
//
//  Created by Iphone Appdev on 2015-11-09.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "User.h"

@interface Recipe : NSObject

@property NSInteger the_id;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *dishName;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSNumber *dayNumber;



+ (Recipe*) recipe;


- (void) saveWithCompletion:(void (^) (NSArray*) )the_block;

@end
