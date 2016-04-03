//
//  MapViewController.h
//  Woof
//
//  Created by Patrick Whitehead on 2016-02-02.
//  Copyright © 2016 Patrick Whitehead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate>


@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

