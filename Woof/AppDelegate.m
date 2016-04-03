//
//  AppDelegate.m
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-02.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import "AppDelegate.h"

#import "MenuViewController.h"
#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Stripe/Stripe.h>
#import <Parse/Parse.h>

#import "PaymentViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"OLB209z73MKo8X85g8v38y1RarGcpzwQ";
        configuration.clientKey = @"unused";
        configuration.server = @"http://woof-server.herokuapp.com/parse";
    }]];
    
    [GMSServices provideAPIKey:@"AIzaSyCgfZtkkbRE-VYkhgwb0JVDD_Iy5-ozYJ4"];
    
    [Stripe setDefaultPublishableKey:@"pk_test_2vf9mcUQ31NUYxRm81FtTCsn"];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
