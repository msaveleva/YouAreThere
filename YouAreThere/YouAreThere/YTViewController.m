//
//  YTViewController.m
//  YouAreThere
//
//  Created by Maria Saveleva on 01/12/13.
//  Copyright (c) 2013 Maria Saveleva. All rights reserved.
//

#define COORDINATES_DELTA 10

#import "YTViewController.h"

@interface YTViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

- (IBAction)saveDestinationLoc:(id)sender;

@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)saveDestinationLoc:(id)sender {
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    self.location = userLocation;
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    [self.locationManager startUpdatingLocation];
}

- (void)notifyAboutPlace
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:nil];
    [notification setAlertBody:@"Hi! It's LocalNotification!"];
    notification.soundName = @"VOCALOID solo.caf";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)checkIfCoorinatesAreEqual:(CLLocation *)currentLocation
{
    if (self.location) {
        NSInteger distance = [currentLocation distanceFromLocation:self.location];
        NSLog(@"DISTANCE: %d", distance);
        if (distance <= COORDINATES_DELTA) {
            [self notifyAboutPlace];
        }
    }
}

#pragma mark - CLLocation methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"Latitude: %f, longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
//    NSLog(@"Self lat: %f, lon: %f", self.location.latitude, self.location.longitude);
    
    [self checkIfCoorinatesAreEqual:location];
}

@end
