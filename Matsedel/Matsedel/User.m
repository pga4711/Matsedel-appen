//
//  User.m
//  Matsedel
//
//  Created by Iphone Appdev on 2015-11-09.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//

#import "User.h"
#import "Recipe.h"

@implementation User

//kanske getUserByUsername
+ (void) userWithUserName:(NSString*) username withPassword:(NSString*) password completion:(void (^) (User*, int))the_block{
 
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSString * string = [NSString stringWithFormat:@"http://work.skaggbyran.se/inkop/login.php?username=%@&password=%@", username, password];
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        User* obj = nil; //Vi ska inte slösa onödig dataplats
       
        NSLog(@"error när servern är nere!!: %@", error);

        
        NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
       
        //Nu ska vi göra ett fint User-objekt:
        NSNumber* status = parsedData[@"status"];
        
        
        //Öppna php-filen såhär: sudo nano /var/www/html/inkop/login.php
        
        
        //if ([[parsedData[@"status"] intValue] == 1)  //Kan man göra typ såhär?
        if ([status intValue] == 1)
        {
            //NSLog(@"Status är ok, nu lägger vi in saker i obj");
            obj = [[User alloc] init];
            obj.the_id = parsedData[@"userid"];  //gustav skrev i php att det heter userid
            obj.username = parsedData[@"username"];
            obj.email = parsedData[@"email"];
           
        }
        else { NSLog(@"Status var inte så bra");}
        
        
        
       // obj.the_id parsedData
        
        the_block(obj, [status intValue]);
        
    }];
    
    
    [task resume];
    
  
    //En whitelist imorrn. Vi la den i Info.plist
    

    
    //Den returnerar inget, det den gör är att den skickar saker till singeltonnen om användare hittades.
    //Annars så kommer det vara nil i singeltonnen.
    return;
    
    
    
}

//Vi borde göra en slags DataStorage-objekt som User och Recipe (Och ingridient på lång sikt), sparar i . Istället för att själva objekten vet hur de ska sparas. :/ eller?


//Den här ska initiera alla recept som en användare har idag (pga now() i sql) när han loggar in.
//Man kan säga att denna metod hämtar saker från databasen och lägger dem i en snygg NSArray som heter recipiesArray.

//Den här kanske borde heta getDishesWithCompletion

- (void) recipiesWithCompletion:(void (^) (NSArray*) )the_block withTheWeekOfThisDate:(NSDate *)d
{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString * dateStr = [dateFormatter stringFromDate:d]; //Vi gör en sträng av datumet vi vill hämta dishes/recipes för.

    NSURLSession * session = [NSURLSession sharedSession];
    
    
    NSString * string = [NSString stringWithFormat:@"http://work.skaggbyran.se/inkop/getrecipes.php?userID=%@&date=%@", self.the_id, dateStr];
    
   
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    
    
    //Först kör den dataTaskWithRequest:request och altså går till server och frågar. Sen kör den completionHandler. Alltså när den körs har man ju då fått saker från sörvern.
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        
        //PHP-skriptet väljer hur många recept jag ska få.
        NSArray* parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        
        NSMutableArray* recipiesArray = [[NSMutableArray alloc] init];
        

        
        
        //Jag borde ha en NSarray med recipies.
        
        
        //Kan vara fel i for-loopen, kanske 1 steg för mycket eller för lite.
        
        
        
        for (int i = 0 ; i < parsedData.count ; i++)
        {            Recipe* r =  [Recipe recipe] ; //Den här kör init alloc innuti sig. Men varför gör vi så nu igen?
            
            NSDictionary* d = parsedData[i]; //Sätt en rad här
            
           
            //Så, nu har vi ändrat.
            r.the_id = [d[@"id"] integerValue]; //Hmm, pyssel med NSInteger osv.
            NSLog(@"Hmm, pyssel med NSInteger osv, Ser recipeID:t bra ut?: %zd", r.the_id);
            r.user = self;
            r.dishName = d[@"dishName"];
            r.date = d[@"date"];
            r.dayNumber = d[@"dayNumber"]; //  denhär la vi till.
            
        
            //Sätt in r i recipiesArrayen:
            recipiesArray[i]=r;
        }
        
        
        // obj.the_id parsedData
        
        the_block(recipiesArray);
        
    }];
    
    
    [task resume];
    
    //Den returnerar inget, det den gör är att den skickar saker till singeltonnen om användare hittades.
    //Annars så kommer det vara nil i singeltonnen.
    return;
    
    
    
}





@end
