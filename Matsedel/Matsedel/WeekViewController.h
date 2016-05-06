//
//  WeekViewController.h
//  Matsedel
//
//  Created by Iphone Appdev on 2015-10-15.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *weekLabel;
@property NSNumber *viewingWeek; //Veckan som användaren är och tittar på i GUI:t


@property NSDate *viewingWeekRepresentedByDate; //Denhär kommer man ta -7 på om man vill bläddra bakåt och +7 om man vill bläddra framåt?

//Så nu används den här för att spara alla recipes i appen när de anländer. När vi sparar ett recept så så sparar vi även i denna.
@property NSMutableArray *arrayWithRecipes; //Denhär kanske vi ska ha för att i slutändan kunna skicka ett ID till databasen.


@property (strong, nonatomic) IBOutlet UITextField *mondayBox;
@property (strong, nonatomic) IBOutlet UITextField *tuesdayBox;
@property (strong, nonatomic) IBOutlet UITextField *wednesdayBox;
@property (strong, nonatomic) IBOutlet UITextField *thursdayBox;
@property (strong, nonatomic) IBOutlet UITextField *fridayBox;





@end
