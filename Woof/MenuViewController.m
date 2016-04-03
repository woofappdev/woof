//
//  MenuViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-03.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "SettingsViewController.h"
#import "PetsViewController.h"
#import "HistoryViewController.h"
#import "PaymentViewController.h"


enum {
    MenuOptionPets,
    MenuOptionPayment,
    MenuOptionHistory,
    MenuOptionSettings,
    
    MenuOptionsCount
};
typedef NSUInteger MenuOption;


@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MenuOptionsCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    if (!name) {
        name = @"Name Goes Here";
    }
    
    return name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self stringForMenuOption:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == MenuOptionSettings) {
        SettingsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        
        [self.revealViewController revealToggleAnimated:YES withCompletion:^(BOOL finished) {
            [self presentViewController:viewController animated:YES completion:nil];
        }];
    }
    else if (indexPath.row == MenuOptionPayment) {
        
        PaymentViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self.revealViewController revealToggleAnimated:YES withCompletion:^(BOOL finished) {
            [self presentViewController:navigationController animated:YES completion:nil];
        }];
        
    }
    else if (indexPath.row == MenuOptionHistory) {
        HistoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self.revealViewController revealToggleAnimated:YES withCompletion:^(BOOL finished) {
            [self presentViewController:navigationController animated:YES completion:nil];
        }];
    }
    else if (indexPath.row == MenuOptionPets) {
        
        
        PetsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PetsViewController"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self.revealViewController revealToggleAnimated:YES withCompletion:^(BOOL finished) {
            [self presentViewController:navigationController animated:YES completion:nil];
        }];
    }

    
}

- (NSString *)stringForMenuOption:(NSInteger)menuOption {
    
    NSString *title;
    
    if (menuOption == MenuOptionSettings) {
        title = @"Settings";
    }
    else if (menuOption == MenuOptionPayment) {
        title = @"Payment";
    }
    else if (menuOption == MenuOptionHistory) {
        title = @"History";
    }
    else if (menuOption == MenuOptionPets) {
        title = @"Pets";
    }
    
    return title;
}

@end
