//
//  YTViewController.m
//  YouAreThere
//
//  Created by Maria Saveleva on 01/12/13.
//  Copyright (c) 2013 Maria Saveleva. All rights reserved.
//

#define COORDINATES_DELTA 0.000001

#import "YTViewController.h"

@interface YTViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D location;

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
    self.location = location;
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    [self.locationManager startUpdatingLocation];
}

- (void)notifyAboutPlace
{
    sleep(3);
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:nil];
    [notification setAlertBody:@"Hi! It's LocalNotification!"];
    notification.soundName = @"VOCALOID solo.caf";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)checkIfCoorinatesAreEqual:(CLLocationCoordinate2D)currentCoordinates
{
//    MKCoordinateRegion region;
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.0000001;
//    span.longitudeDelta = 0.0000001;
//    region.span = span;
//    region.center = self.location;
    
    CGFloat latitudeDelta = abs(self.location.latitude - currentCoordinates.latitude);
    CGFloat longitudeDelta = abs(self.location.longitude - currentCoordinates.longitude);
    
    if (latitudeDelta <= COORDINATES_DELTA && longitudeDelta <= COORDINATES_DELTA) {
        [self notifyAboutPlace];
    }
}

#pragma mark - CLLocation methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"Latitude: %f, longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
}

@end
