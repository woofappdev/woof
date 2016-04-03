//
//  MapViewController.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-02.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"


@interface MapViewController (){

}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Map";
    
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {

        UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        [imageButton setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
        [imageButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];

        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
    self.mapView.myLocationEnabled = YES;
    
    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                                      longitude:self.mapView.myLocation.coordinate.longitude
                                                           zoom:15];
    
    
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [PFUser logOut];
    
    [[PFUser currentUser]fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        NSLog(@"user updated");
    }];
    
    NSLog(@"stripeId: %@", [PFUser currentUser][@"stripeId"]);
    
    if (![PFUser currentUser]) {
    
        SignUpViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navigationController animated:NO completion:nil];
        
    }
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    [self.mapView animateToLocation:currentLocation.coordinate];
}



@end
