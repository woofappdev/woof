//
//  EditPetViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-22.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "EditPetViewController.h"
#import "ConnectionManager.h"


@interface EditPetViewController ()

@property (nonatomic, strong) IBOutlet UITextField *nameField;

@end

@implementation EditPetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isNewPet == YES) {
        self.title = NSLocalizedString(@"Add Pet", nil);
        self.pet = [[WoofPet alloc]init];
    }
    else {
        self.title = NSLocalizedString(@"Edit Pet", nil);
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}


- (void)done {
    
    self.pet.name = self.nameField.text;
    
//    self.pet is nil?
    
    [[ConnectionManager sharedManager]savePet:self.pet completion:^(BOOL success, NSError *error) {
        
        NSLog(@"success: %d", success);
        NSLog(@"error: %@", error);
        
    }];
    
    
    
}




@end
