//
//  PaymentViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-23.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "PaymentViewController.h"
#import <Parse/Parse.h>
#import "ConnectionManager.h"
#import "WoofCreditCard.h"
#import "ActivitySpinnerViewController.h"
#import "EditCardViewController.h"
#import "AddCardViewController.h"

@interface PaymentViewController ()


@property (nonatomic, strong) UIView *addCardView;
@property (nonatomic, strong) NSArray *cards;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Payment", nil);
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCard)];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isInitialSetup) {
        [self addCard];
    }
    else{
        [self loadCards];
        
    }
}




- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCard {
    
    AddCardViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCardViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}


- (void)loadCards {
    
    ActivitySpinnerViewController *spinner = [[ActivitySpinnerViewController alloc]initWithMessage:NSLocalizedString(@"Getting Cards", nil)];
    [self.view addSubview:spinner];
    
    
    [[ConnectionManager sharedManager]getCreditCardsWithCustomerId:[PFUser currentUser][@"stripeId"] completion:^(NSArray *cards, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cards = cards;
            [self.tableView reloadData];
            [spinner removeFromSuperview];
        });
        
    }];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    WoofCreditCard *card = [self.cards objectAtIndex:indexPath.row];
    
    if (card.isPrimaryCard == YES) {
        cell.textLabel.text = [NSString stringWithFormat:@"•••• %@ (Primary)", card.last4];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"•••• %@", card.last4];
    }
    
    cell.imageView.image = [self imageForCardBrand:card.brand];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WoofCreditCard *card = [self.cards objectAtIndex:indexPath.row];
    
    EditCardViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCardViewController"];
    
    viewController.card = card;
    
    if (self.cards.count == 1) {
        viewController.isOnlyCard = YES;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}


- (UIImage *)imageForCardBrand:(NSString *)brand {
    
    if ([brand isEqualToString:@"Visa"]) {
        return [UIImage imageNamed:@"visa"];
    }
    else if ([brand isEqualToString:@"American Express"]) {
        return [UIImage imageNamed:@"amex"];
    }
    else if ([brand isEqualToString:@"MasterCard"]) {
        return [UIImage imageNamed:@"mastercard"];
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
