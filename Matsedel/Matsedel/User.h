//
//  User.h
//  Matsedel
//
//  Created by Iphone Appdev on 2015-11-09.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject

//!! man måste ha strong. Man behöver inte skriva (strong, nonatomic)  egentligen?? vi får prova utan sen.

@property (strong, nonatomic) NSNumber *the_id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;


//@property (strong, nonatomic) NSString *password; //Den ska man väl inte spara? :>


+ (void) userWithUserName:(NSString*) username withPassword:(NSString*) password completion:(void (^) (User*, int))the_block;

- (void) recipiesWithCompletion:(void (^) (NSArray*) )the_block withTheWeekOfThisDate:(NSDate *)d;

@end
