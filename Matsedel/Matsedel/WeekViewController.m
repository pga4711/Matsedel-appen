//
//  WeekViewController.m
//  Matsedel
//
//  Created by Iphone Appdev on 2015-10-15.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//
//


#import "WeekViewController.h"
#import "ViewController.h"
#import "UserManager.h"
#import "User.h"
#import "Recipe.h"

@interface WeekViewController ()

@end

@implementation WeekViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Nu är jag inloggad :D
    
    
    self.arrayWithRecipes = [[NSMutableArray alloc] init];
    
    
    //Här vi vill vi sätta dit nuvarande veckonummer i labeln, därför kan vi inte ha denna kod (tom hit *1) i reloadDishes, för man kanske vill anropa reloadDishes med en annan vecka.
    NSDate *currDate = [NSDate date];
    
    self.viewingWeekRepresentedByDate = currDate; //Vi insialiserar själva datumet som vi ska använda för att byta veckor med.
    
    //hejhej jag testar lite
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    
    
    [calendar setFirstWeekday:2]; //görs automatiskt av syntheze
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitCalendar;
    
    
    
    NSDateComponents *comps= [calendar components: unitFlags fromDate:currDate];
    
    //NSLog(@"Current Week: %d, Current year %d, Current monthdaynumber: %d, Current weekdayordinal: %d", [comps weekOfYear] , [comps year], [comps day], [comps weekdayOrdinal]);
    
    self.viewingWeek = [NSNumber numberWithInt:[comps weekOfYear]];
    
    self.weekLabel.text = [NSString stringWithFormat:@"Vecka %@ (nu)", [self.viewingWeek stringValue]];  //Sätta dit veckonumret i GUI:t
    
    
    
    //(*1 hit alltså)
    
    [self reloadDishes:^{} withTheWeekOfThisDate:currDate];
    
    
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews {

    //Gör det här sist!
   
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ViewController * theController;
    
    theController = [segue destinationViewController]; //Nu kommer vi åt den ViewControllern vi ska till
    
    if ([theController isKindOfClass:ViewController.class]) //Om vi trycker på Logga ut-knappen typ.
    {
        //Vi plokcar bort den inloggade usern ur singelton-managern.
        [UserManager sharedManager].signedInUser=nil;
    }
    
    
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}



- (IBAction)saveMondayBox:(id)sender {
    
    
    NSLog(@"Just nu står det såhär: %@ ", self.mondayBox.text);
    
    NSLog(@"This is viewingWeek: %@", self.viewingWeek);
    NSLog(@"This is viewingWeekRepresentedByDate: %@", self.viewingWeekRepresentedByDate);
    
    
    [self.mondayBox resignFirstResponder];
    
    [self saveDish:self.mondayBox.text withDayOrdinal:0];
    
    //Vi kan nog göra en funktion nu som heter typ. nåt. Vet inte. Men den ska ta emot argument som t ex:
    //self.mondayBox.text     dagen (måndag 0 t ex)
    
    NSLog(@"Okej, men var går vi sen då?");
    
}

- (IBAction)saveTuesdayBox:(id)sender {
    
    
    [self.tuesdayBox resignFirstResponder];
    
    [self saveDish:self.tuesdayBox.text withDayOrdinal:1];
    

}


- (IBAction)saveWednesdayBox:(id)sender {
    [self.wednesdayBox resignFirstResponder];
    
    [self saveDish:self.wednesdayBox.text withDayOrdinal:2];
    
}

- (IBAction)saveThursdayBox:(id)sender {
    
    [self.thursdayBox resignFirstResponder];
    
    [self saveDish:self.thursdayBox.text withDayOrdinal:3];
    
    
}
- (IBAction)saveFridayBox:(id)sender {
    
    [self.fridayBox resignFirstResponder];
    
    [self saveDish:self.fridayBox.text withDayOrdinal:4];
}




- (IBAction)browseWeekForward:(id)sender {
    
    //NSInteger weekToGetFromDatabase = subtractGlobalWeekManagerWithWeekAndReturnThatWeek();
    //reloadDishes(weekToGetFromDatabase);
    
    NSDate *currDate = [NSDate date]; //Använd sen, när jag ska göra en markering för i appen så man vet vilken vecka som är nu.
    
    //Här gör vi så att man har en bra kalender som man i slutändan genom NSDateComponents kan plocka ut veckonumret vart efter.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    
    //[calendar setFirstWeekday:2]; //HÄR KAN VARA FEL, ERSÄTT ELLER FUNDERA ELLER NÅTT
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitCalendar;
    
    //Lägg till 7 dagar
    self.viewingWeekRepresentedByDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                                             value:7
                                                            toDate:self.viewingWeekRepresentedByDate
                                                           options:kNilOptions];
    
    
    
    
    NSDateComponents *compsOfViewingWeek = [calendar components: unitFlags fromDate:self.viewingWeekRepresentedByDate];
    self.viewingWeek = [NSNumber numberWithInt:[compsOfViewingWeek weekOfYear]];
    
    NSDateComponents *compsOfCurrentDate = [calendar components: unitFlags fromDate:currDate];
    NSNumber *currWeek = [NSNumber numberWithInt:[compsOfCurrentDate weekOfYear]];
    
    
    
    
    
    
    if (self.viewingWeek==currWeek) 
        self.weekLabel.text = [NSString stringWithFormat:@"Vecka %@ (nu)", [self.viewingWeek stringValue]];  //Sätta dit veckonumret i GUI:t
    else
        self.weekLabel.text = [NSString stringWithFormat:@"Vecka %@", [self.viewingWeek stringValue]];  //Sätta dit veckonumret i GUI:t
    
    
    /*
    NSLog(@"self.viewingWeek: %@", self.viewingWeek);
    NSLog(@"currWeek: %@", currWeek);
    NSLog(@"self.weekLabel.text: %@", self.weekLabel.text);
    NSLog(@"self.viewingWeekRepresentedByDate: %@", self.viewingWeekRepresentedByDate);
    */
     
     
    //Hämta nya recipes och skicka till GUI!
    [self reloadDishes:^{} withTheWeekOfThisDate:self.viewingWeekRepresentedByDate];
    
    
    
}

- (IBAction)browseWeekBack:(id)sender {
       
    
    
    
    NSDate *currDate = [NSDate date]; //Använd sen, när jag ska göra en markering för i appen så man vet vilken vecka som är nu.
    
    //Här gör vi så att man har en bra kalender som man i slutändan genom NSDateComponents kan plocka ut veckonumret vart efter.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    
    //[calendar setFirstWeekday:2]; //HÄR KAN VARA FEL, ERSÄTT ELLER FUNDERA ELLER NÅTT
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitCalendar;
    
    //Ta bort 7 dagar
    self.viewingWeekRepresentedByDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                                             value:-7
                                                            toDate:self.viewingWeekRepresentedByDate
                                                           options:kNilOptions];
    
    //Här under måste vi avgöra om veckan vi tittar på är nuvarande vecka eller ej.
    
    
    
    //Här plockar vi ut de NSCalendarUnits vi vill ha i comps. NSCalendarWeekOfYear är mest intressant (som finns inuti unitFlags kan man säga).
    NSDateComponents *compsOfViewingWeek = [calendar components: unitFlags fromDate:self.viewingWeekRepresentedByDate];
    self.viewingWeek = [NSNumber numberWithInt:[compsOfViewingWeek weekOfYear]];
    
    NSDateComponents *compsOfCurrentDate = [calendar components: unitFlags fromDate:currDate];
    NSNumber *currWeek = [NSNumber numberWithInt:[compsOfCurrentDate weekOfYear]];
    
    
    
    if (self.viewingWeek==currWeek)
        self.weekLabel.text = [NSString stringWithFormat:@"Vecka %@ (nu)", [self.viewingWeek stringValue]];  //Sätta dit veckonumret i GUI:t
    else
        self.weekLabel.text = [NSString stringWithFormat:@"Vecka %@", [self.viewingWeek stringValue]];  //Sätta dit veckonumret i GUI:t
    
    
    
    //Hämta nya recipes och skicka till GUI!
    [self reloadDishes:^{} withTheWeekOfThisDate:self.viewingWeekRepresentedByDate];
    
    
}



//Här stannade jag sista arbetsdagen 2015.
//Fundera på att lägga till ett argument på realod Dishes.


//Vad gör denna? Hämtar 5 recept? Så i vanliga fall hämtar den receptet
//Man kan säga att den heter reloadRecipesIntoGui också.
- (void)reloadDishes:(void (^)() )the_block withTheWeekOfThisDate:(NSDate *)d
{
    
    //Lite speciell. Den här körs när vi hämtat något från databasen.
    [[UserManager sharedManager].signedInUser recipiesWithCompletion: ^(NSArray *recipeArray)
    {
        //Alltså allting här i kommer vi stoppa in i funktionen recipiesWithCompletion
        //Varför stoppar vi in den där?
        
        //Vi skapar en array av alla UITextBox:ar för att det är lättare att stega igenom dem då.
        NSArray* arrayWithDayBoxes = @[ self.mondayBox, self.tuesdayBox, self.wednesdayBox, self.thursdayBox, self.fridayBox];
        
        //Spara hela veckans dishes/recipes i arrayWithRecipes.
        self.arrayWithRecipes = [NSMutableArray arrayWithArray:recipeArray];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (UITextField* b in arrayWithDayBoxes)
            {
                b.text = @""; //Ha tomt vissa dagar
            }
        });
        
        
        //Info om hur for-loopen funkar i objC:Det som är till vänster om 'in' är de typerna som finns i arrayen/dictionaryn som finns till höger om 'in'
        
        
        //Lägg in saker i GUI
        for (Recipe* r in recipeArray)
        {
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //FIX_MED_DAGAR
                
                UITextField* box = nil;
                
                NSLog(@"Undrar vad jag tänkt här:  r.dayNumber.intValue: %d", r.dayNumber.intValue);
                box = arrayWithDayBoxes[r.dayNumber.intValue]; //Plocka ut rätt UITextField
                NSLog(@"Här är r.dishName: %@", r.dishName);
                box.text = r.dishName; //Sätt dit matnamnet på den rätta dagen.
                
                
            });
            
        }
        
        NSLog(@"Ny reload");
    } withTheWeekOfThisDate:d];
    
    
}


-(void) saveDish:(NSString*)dishText withDayOrdinal:(int)dayOrdinal
{
    
    //Alltså för att få id, vi skulle kunna kolla om ett visst recept med en viss dayNumber redan existerar i arrayWithRecipes
    Recipe* r = [[Recipe alloc] init];
    
    r.user = [UserManager sharedManager].signedInUser;
    
    r.dishName = dishText;
   
    NSLog(@" self.arrayWithRecipes (om den är tom så är tanken att det inte fanns några dagar den veckan som man tittar på): %@", self.arrayWithRecipes);
    
    
    
    for (Recipe* steppingRecipe in self.arrayWithRecipes)
    {
        
        
        //Intressant nu:
        //Kan det vara så att någon steppingRecipe.dayNumber är 1 fastän det inte finns någon sån i databasen?
        //Kan det vara så att någon steppingRecipe.dayNumber inte är 1 och så finns det någon 1 i databsen?
        //Det kan bli error om det är fler användare. Om användare x1 skapar ett recept som inte funnits sen förut. Och sen skapar användare x2 också ett recept
        //Men det kanske går bra ändå? För vi skickar ju 0 om själva appen inte vet om att det funnits något recept.
        
      
        if (steppingRecipe.dayNumber == [NSNumber numberWithInt:dayOrdinal]) //Om vi har fått en Recipe från databasen sedan förut. Vi kollar om det redan finns något recept för idag.
        {
            //japp vi hade den sen förut,
            NSLog(@"steppingRecipe.the_id: %zd. Dendär kommer ju skickas in i r.the_id alltså. ", steppingRecipe.the_id);
            
            r.the_id = steppingRecipe.the_id;
        }
        
        else
        {
            r.the_id = 0; //Så om det är en ny så sätter vi id = 0? Iallafal vet inte appen om att det funnits något recept sen förut i databasen. Däremot kan en annann användare skapa ett recept utan att vi  vet om det. Om vi har multi-user-app. VI SKA INTE HA DET ÄN, JESPER BLIR GALEN DÅ säkert
        }
        
    }
    
    
    
    //@property NSDate *viewingWeekRepresentedByDate;  måste vara denna vecka för att det ska fungera!
    r.date = [self computeTheUITextFieldsDate:dayOrdinal+1]; //1 betyder måndag! om vi skriver fel här blir allt galet
    //???????????
    
    
    
    NSLog(@"%@", r);
    
    //Vad ska jag stoppa in i saveDish? Hur ska den se ut? Ska den se ut som reloadDishes?
    
    //[r saveRecipeWithCompletion];
    
    //HUR SKA DET VARA?  16:54 DEN 2/2-2016. //GLÖM INTE FACKING H-FILEN
    [r  saveWithCompletion: ^(NSArray *arrayWithInfo) {
        
        NSLog(@"DEBUG tralala");
        
      
        
        //NSLog(@"NU ÄR VI HÄR. arrayWithInfo[22222]: %@", arrayWithInfo[@"insertID"]); //VÄLDIGT DÅLIGT. HUR KÖR MAN DICTIONARY?
        
        
        /*
        for (Recipe *steppingRecipe in self.arrayWithRecipes)
        {
            NSLog(@"arrayWithInfo[2]: %@", arrayWithInfo[2]);
            NSLog(@"steppingRecipe.the_id: %ld", (long)steppingRecipe.the_id);
            //if (steppingRecipe.the_id == arrayWithInfo[2])
        
        }
            */
         NSLog(@"Här är r: %@", r);
        
        
        NSLog(@"arrayWithInfo: %@", arrayWithInfo);
        NSLog(@"self.arrayWithRecipes: %@ ", self.arrayWithRecipes);
        
        
        
        
    }];
    
}


- (NSString*)computeTheUITextFieldsDate:(NSUInteger) dayNumber
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    //[calendar setFirstWeekday:2]; //FEL?????
    
    NSUInteger adjustedWeekdayOrdinal = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:self.viewingWeekRepresentedByDate];
    
    NSLog(@"self.viewingWeekRepresentedByDate innan bakåt: %@", self.viewingWeekRepresentedByDate);
    
    
    //FIX_MED_DAGAR
    NSDate *UITextFieldDate = [calendar dateByAddingUnit:NSCalendarUnitDay
                                                             value:-adjustedWeekdayOrdinal+dayNumber
                                                            toDate:self.viewingWeekRepresentedByDate
                                                           options:kNilOptions];
    
    NSLog(@"UITextFieldDate: %@", UITextFieldDate);
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //kolla om det är rätt.

  
    return [dateFormatter stringFromDate:UITextFieldDate];
}




@end
