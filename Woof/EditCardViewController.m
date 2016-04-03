//
//  EditCardViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-03-21.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "EditCardViewController.h"
#import "ConnectionManager.h"
#import "ActivitySpinnerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditCardViewController ()


@property (nonatomic, strong) UITextField *expField;
@property (nonatomic, strong) UITextField *cvcField;
@property (nonatomic, strong) UITextField *cardNameField;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) IBOutlet UILabel *primaryLabel;
@property (nonatomic, strong) IBOutlet UISwitch *primarySwitch;

@property (nonatomic, strong) IBOutlet UIImageView *cardImageView;

@property (nonatomic, strong) IBOutlet UIButton *deleteButton;

@end

@implementation EditCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardImageView.image = [UIImage imageNamed:@"sample cc"];
    
    [self setupCard];
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 40, 250, 50)];
    self.numberLabel.text = [NSString stringWithFormat:@"•••• •••• •••• %@", self.card.last4];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    UIImageView *brandView = [[UIImageView alloc]initWithFrame:CGRectMake(220, 125, 65, 40)];
    brandView.backgroundColor = [UIColor whiteColor];
    brandView.layer.masksToBounds = YES;
    brandView.layer.cornerRadius = 5;
    brandView.image = [self imageForCardBrand:self.card.brand];
    
    [self.cardImageView addSubview:self.numberLabel];
    [self.cardImageView addSubview:brandView];
    
    if (self.isOnlyCard == YES) {
        self.deleteButton.hidden = YES;
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCard)];
    
    [self.navigationItem setRightBarButtonItem:editButton];
}

- (void)setupCard {
    
    [self.expField removeFromSuperview];
    [self.cvcField removeFromSuperview];
    [self.cardNameField removeFromSuperview];
    
    self.primaryLabel.hidden = YES;
    self.primarySwitch.hidden = YES;
    
    self.expLabel = [[UILabel alloc]initWithFrame:CGRectMake(63, 82, 100, 50)];
    self.expLabel.text = [NSString stringWithFormat:@"%@/%@", self.card.month, [self.card.year.stringValue substringFromIndex:self.card.year.stringValue.length - 2]];
    self.expLabel.textColor = [UIColor whiteColor];
    self.expLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 125, 250, 50)];
    if (self.card.cardName.length) {
        self.nameLabel.text = self.card.cardName;
    }
    else {
        self.nameLabel.text = NSLocalizedString(@"PERSONAL", nil);
    }
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    [self.cardImageView addSubview:self.expLabel];
    [self.cardImageView addSubview:self.nameLabel];
    
}


- (void)saveCard {
    
    ActivitySpinnerViewController *spinner = [[ActivitySpinnerViewController alloc]initWithMessage:NSLocalizedString(@"Saving", nil)];
    [self.view addSubview:spinner];
    
    NSArray *expArray = [self.expField.text componentsSeparatedByString:@"/"];
    
    self.card.month = @([[expArray firstObject]intValue]);
    self.card.year = @([[expArray lastObject]intValue]);
    self.card.cvc = self.cvcField.text;
    self.card.cardName = self.cardNameField.text;
    
    if (!self.card.cardName.length) {
        self.card.cardName = NSLocalizedString(@"PERSONAL", nil);
    }
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCard)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    saveButton.enabled = NO;
    cancelButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:saveButton];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    [self setupCard];
    
    // save and then reset back to normal
    [[ConnectionManager sharedManager]editCardWithCardInfo:self.card setPrimary:self.primarySwitch.on completion:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCard)];
            
            [self.navigationItem setRightBarButtonItem:editButton];
            self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
            
            [spinner setMessage:@"Saved"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [spinner removeFromSuperview];
            });
            
            
        });
        
    }];
    
    
    
}

- (void)editCard {
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCard)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    [self.navigationItem setRightBarButtonItem:saveButton];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    // Remove labels
    self.expLabel.text = nil;
    [self.expLabel removeFromSuperview];
    self.nameLabel.text = nil;
    [self.nameLabel removeFromSuperview];
    
    // Add textFields
    self.expField = [[UITextField alloc]initWithFrame:CGRectMake(63, 92, 50, 30)];
    self.expField.text = [NSString stringWithFormat:@"%@/%@", self.card.month, [self.card.year.stringValue substringFromIndex:self.card.year.stringValue.length - 2]];
    self.expField.backgroundColor = [UIColor whiteColor];

    self.cvcField = [[UITextField alloc]initWithFrame:CGRectMake(125, 92, 50, 30)];
    self.cvcField.placeholder = @"CVC";
    self.cvcField.backgroundColor = [UIColor whiteColor];
    
    
    self.cardNameField = [[UITextField alloc]initWithFrame:CGRectMake(25, 135, 175, 30)];
    self.cardNameField.text = self.card.cardName;
    self.cardNameField.backgroundColor = [UIColor whiteColor];
    
    [self.cardImageView addSubview:self.expField];
    [self.cardImageView addSubview:self.cardNameField];
    [self.cardImageView addSubview:self.cvcField];
    
    if (self.card.isPrimaryCard == NO) {
        self.primaryLabel.hidden = NO;
        self.primarySwitch.hidden = NO;
    }
    
}


- (void)cancel {
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCard)];

    [self.navigationItem setRightBarButtonItem:editButton];
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    
    [self setupCard];
    
    [self.cardImageView addSubview:self.numberLabel];

    
    
}


- (IBAction)deleteCard {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Delete Card", nil) message:NSLocalizedString(@"Are you sure you want to delete this payment card?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        ActivitySpinnerViewController *spinner = [[ActivitySpinnerViewController alloc]initWithMessage:NSLocalizedString(@"Deleting", nil)];
        [self.view addSubview:spinner];
        
        
        [[ConnectionManager sharedManager]deleteCardWithCardId:self.card.cardId andStripeId:self.card.stripeId completion:^(NSError *error) {

            NSLog(@"error: %@", error);
            
            if (!error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [spinner removeFromSuperview];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Successfully Deleted", nil)  message:NSLocalizedString(@"Your Payment Card was successfully deleted", nil) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                        
                    }];
                    
                    [alertController addAction:okAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                });
            }
            
        }];
        
    }];
    [alertController addAction:delete];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}



- (UIImage *)imageForCardBrand:(NSString *)brand {
    
    if ([brand isEqualToString:@"Visa"]) {
        return [UIImage imageNamed:@"visa"];
    }
    else if ([brand isEqualToString:@"American Express"]) {
        return [UIImage imageNamed:@"amex"];
    }
    else if ([brand isEqualToString:@"MasterCard"]) {
        return [UIImage imageNamed:@"mc"];
    }
    else if ([brand isEqualToString:@"Discover"]) {
        return [UIImage imageNamed:@"discover"];
    }
    else if ([brand isEqualToString:@"JCB"]) {
        return nil;
    }
    else if ([brand isEqualToString:@"Diners Club"]) {
        return nil;
    }
    else if ([brand isEqualToString:@"Unknown"]) {
        return nil;
    }
    else {
        return nil;
    }
    
}




@end
