//
//  UserManager.h
//  Matsedel
//
//  Created by Iphone Appdev on 2015-11-11.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"



@interface UserManager : NSObject

@property User* signedInUser;

+ (UserManager*)sharedManager ;

@end
