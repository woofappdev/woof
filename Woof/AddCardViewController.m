//
//  AddCardViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-27.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "AddCardViewController.h"
#import <Stripe/Stripe.h>
#import "ConnectionManager.h"
#import "ActivitySpinnerViewController.h"
#import "CardIO.h"

@interface AddCardViewController () <STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate>

@property (nonatomic) STPPaymentCardTextField *paymentTextField;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.saveButton.enabled = NO;
    
    [self.navigationItem setRightBarButtonItem:self.saveButton];
    
    
//    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(85, 125, 220, 44)];
    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(10, 125, self.view.frame.size.width - 20, 44)];
    
    NSLog(@"%@", NSStringFromCGRect([self.paymentTextField numberFieldRectForBounds:self.paymentTextField.frame]));
    
    
    self.paymentTextField.delegate = self;
    [self.view addSubview:self.paymentTextField];
    
//    [CardIOUtilities preload];
    
}

#pragma mark CardIO methods

- (IBAction)scanCard {
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.hideCardIOLogo=YES;
    scanViewController.disableManualEntryButtons = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
}


- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
//    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    // Use the card info...
    
    STPCardParams *params = [[STPCardParams alloc]init];
    params.number = info.cardNumber;
    params.expMonth = info.expiryMonth;
    params.expYear = info.expiryYear;
    params.cvc = info.cvv;
    
    [self.paymentTextField setCardParams:params];
    
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}




- (void)save {
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    saveButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    [self.view endEditing:YES];
    
    ActivitySpinnerViewController *spinner = [[ActivitySpinnerViewController alloc]initWithMessage:NSLocalizedString(@"Saving", nil)];
    [self.view addSubview:spinner];
    
    
    [[STPAPIClient sharedClient] createTokenWithCard:self.paymentTextField.cardParams completion:^(STPToken *token, NSError *error) {
        if (error) {
            // handle error here
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner removeFromSuperview];
            });
            
            saveButton.enabled = YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        } else {
            [[ConnectionManager sharedManager]saveCardWithToken:token completion:^(BOOL success, NSArray *cards, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner removeFromSuperview];
                });
                
                if (success == YES) {
                    
                    
                    // show success message here?
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                    
                    
                }
                else {
                    // handle error here
                    NSLog(@"Failed");
                }
                
            }];
        }
    }];
}

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    self.saveButton.enabled = textField.isValid;
}


- (void)close {
    [self.paymentTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
