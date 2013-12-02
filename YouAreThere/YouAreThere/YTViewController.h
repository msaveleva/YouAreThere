
//
//  YTViewController.h
//  YouAreThere
//
//  Created by Maria Saveleva on 01/12/13.
//  Copyright (c) 2013 Maria Saveleva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface YTViewController : UIViewController <CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)notifyAboutPlace;
- (void)checkIfCoorinatesAreEqual:(CLLocationCoordinate2D)currentCoordinates;

@end
