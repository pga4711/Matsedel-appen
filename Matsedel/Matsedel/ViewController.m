//
//  ViewController.m
//  Matsedel
//
//  Created by Iphone Appdev on 2015-10-12.
//  Copyright © 2015 Skäggbyrån Ekonomiska förening. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "UserManager.h"





@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TapButton:(id)sender {
    
  
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Matsedel"
                                                                   message:@"Skriv in användarnamn och lösenord. Tips: ID: philip, PW: w"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    //Körs när jag trycker på sign in knappen, den borde komma åt .
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Logga in" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        NSLog(@"#Inside UIAlertAction");
        NSLog(@"Input: %@",alert.textFields[0].text);
        NSLog(@"Input2: %@",alert.textFields[1].text);
        
 
        
        
     
        
        
        //Här använder vi databasen långt bort, här sätter vi också in inputsen från textrutorna i "Logga in"-rutan-.
        [User userWithUserName:alert.textFields[0].text withPassword:alert.textFields[1].text completion:^(User *u, int status) {
            
            
            
            [UserManager sharedManager].signedInUser=u;
            
            
            
            
            if (status == 1){
                //Kör här om man kunde logga in.
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // post your notification or display your view
                
                
                [self performSegueWithIdentifier: @"ToWeekController" sender: self];
                
                });
                
                
            }
            else
            {
                
                //Kör det här om man inte lyckades logga in
            }
                
        }];
        
        
        
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Stäng" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){   }];
    

    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * t) //
    {
        
        
        t.placeholder = @"Användarnamn";
        
        
    } ];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * t) //
     {
         t.secureTextEntry=YES;
                 
         t.placeholder = @"Lösenord";
     
         
     } ];
    

    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];

    
    
}

@end
