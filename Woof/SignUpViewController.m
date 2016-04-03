//
//  SignUpViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-12.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "SignUpViewController.h"
#import "PaymentViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "ActivitySpinnerViewController.h"

@interface SignUpViewController ()

@property (nonatomic, strong) IBOutlet UITextField *firstField;
@property (nonatomic, strong) IBOutlet UITextField *lastField;
@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Sign Up", nil);

}



- (IBAction)validateInput {
    
    NSMutableString *validationErrors = [[NSMutableString alloc]init];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimmedFirst = [self.firstField.text stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedFirst length] == 0) {
        [validationErrors appendString:NSLocalizedString(@"First name \n", nil)];
    }
    NSString *trimmedLast = [self.lastField.text stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedLast length] == 0) {
        [validationErrors appendString:NSLocalizedString(@"Last name \n", nil)];
    }
    
    NSString *trimmedEmail = [self.emailField.text stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedEmail length] == 0) {
        [validationErrors appendString:NSLocalizedString(@"Email address \n", nil)];
    }
    else{
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:self.emailField.text] == NO) {
            [validationErrors appendString:NSLocalizedString(@"Email address not valid\n", nil)];
        }
    }
    
    NSString *trimmedPassword = [self.passwordField.text stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedPassword length] == 0) {
        [validationErrors appendString:NSLocalizedString(@"Password", nil)];
    }
    
    if (validationErrors.length) {
        NSString *alertMessage = [NSString stringWithFormat:@"%@\n %@", NSLocalizedString(@"Please enter the following:", nil), validationErrors];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Incomplete", nil) message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else {
        [self doDone];
    }
}


- (void)doDone {
    
    [self.view endEditing:YES];
    
    PFUser *user = [PFUser user];
    user.username = self.emailField.text;
    user.email = self.emailField.text;
    user.password = self.passwordField.text;
    user[@"first"] = self.firstField.text;
    user[@"last"] = self.lastField.text;
    
    ActivitySpinnerViewController *spinner = [[ActivitySpinnerViewController alloc]initWithMessage:NSLocalizedString(@"Creating Account", nil)];
    [self.view addSubview:spinner];
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        [spinner removeFromSuperview];

        if (succeeded == YES && !error) {
            
            PaymentViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
            
            viewController.isInitialSetup = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else {
#warning handle error here
            NSLog(@"Error: %@", error.localizedDescription);
        }
        
    }];
    
}








@end
