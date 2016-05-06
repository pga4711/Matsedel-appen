//
//  Recipe.m
//  Matsedel
//
//  Created by Iphone Appdev on 2015-11-09.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

//Häftig funktion, gustavfn får berätta mer.


- (NSString *)description {
    return [NSString stringWithFormat: @"Recipe; the_id: %zd, userID:%@, dishName:%@, date:%@, dayNumber:%@", self.the_id, self.user.the_id, self.dishName, self.date, self.dayNumber];
}


+ (Recipe*) recipe { return [[Recipe alloc] init];}





////Den här kanske borde heta saveDishesWithCompletion
- (void) saveWithCompletion:(void (^) (NSArray*) )the_block
{
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    
    //YEAR-WEEK-WEEKDAY är kanske bättre T ex 2015-40-0 : måndag vecka 40.
    //istället för  YEAR-MONTH-DATE
    
    NSString * string = [NSString stringWithFormat:@"http://work.skaggbyran.se/inkop/saverecipe.php?userID=%@&dishName=%@&date=%@&recipeID=%zd", self.user.the_id, self.dishName, self.date , self.the_id];
    
    NSLog(@"Här är URLWithString-saken: %@", string);
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    
    
    NSLog(@"Innan vi gör Task-etableringen");
    
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSLog(@"Error i Recipe.m, saveWithCompletion: %@", error);
        NSLog(@"THIS IS DATA: %@", data);
        
        
        if (error != nil) //Om error är nil är det bra
        {
            NSLog(@" OMG, error is not nil, error contains something: ");
            NSLog(@"NSUrl string: %@", string);
            NSLog(@"error: %@", error);
            NSLog(@"response: %@,", response);
            NSLog(@"Alltså vi kör inte the_block");
        }
        else if (data == nil) //om data är nil är det inte bra.
        {
            NSLog(@" OMG, data is nil, the latest text input is invalid. ");
            NSLog(@"NSUrl string: %@", string);
            NSLog(@"error: %@", error);
            NSLog(@"response: %@,", response);
            NSLog(@"Alltså vi kör inte the_block");
     
        }
        else
        {
            NSArray* parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSDictionary* parsedDataNSDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];//Jag kör en test här 22/2-2016
            // NSMutableArray* recipiesArray = [[NSMutableArray alloc] init];
            
            
            NSLog(@"parsedDataNSDictinary: %@", parsedDataNSDictionary);
            NSLog(@"Lite space");
            NSLog(@"parsedData: %@", parsedData);
            
            //Äsch, vi vet inte riktigt vad vi ska ha här ännu. JO NU VET VI. VI MÅSTE ÅTMINSTONE TA HAND OM DET ID:t SOM KOM FRÅN DATABASEN.
            
            
            
            the_block(parsedData);
            
        }
        
    }];
    
    NSLog(@"Nu är vi innan task resume");
    [task resume];
    NSLog(@"Nu är vi efter task resume");
    
    //Den returnerar inget, det den gör är att den skickar saker till singeltonnen om användare hittades.
    //Annars så kommer det vara nil i singeltonnen.
    
    return;
    
    
    
}




@end
