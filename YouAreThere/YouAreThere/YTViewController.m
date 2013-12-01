//
//  YTViewController.m
//  YouAreThere
//
//  Created by Maria Saveleva on 01/12/13.
//  Copyright (c) 2013 Maria Saveleva. All rights reserved.
//

#import "YTViewController.h"

@interface YTViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

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
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocation methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"Latitude: %f, longitude: %f", location.coordinate.latitude, location.coordinate.longitude);
}

@end
