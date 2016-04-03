//
//  PetsViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-11.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "PetsViewController.h"
#import "EditPetViewController.h"
#import "ConnectionManager.h"

@interface PetsViewController ()

@property (nonatomic, strong) NSArray *pets;

@end

@implementation PetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPet)];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    [self.navigationItem setLeftBarButtonItem:closeButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadPets];
}

- (void)loadPets {
    
    [[ConnectionManager sharedManager]getPetsWithCompletion:^(NSArray *pets, NSError *error) {
        
        if (!error) {
            self.pets = pets;
            
            [self.tableView reloadData];
        }
        
        
    }];
    
}

- (void)addPet {
    
    EditPetViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPetViewController"];
    
    viewController.isNewPet = YES;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    WoofPet *pet = [self.pets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = pet.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WoofPet *pet = [self.pets objectAtIndex:indexPath.row];
    
    EditPetViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPetViewController"];
    
    viewController.pet = pet;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}



@end
