//
//  UserManager.m
//  Matsedel
//
//  Created by Iphone Appdev on 2015-11-11.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (UserManager*)sharedManager {
    static UserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}


@end
