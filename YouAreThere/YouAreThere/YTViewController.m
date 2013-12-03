//
//  YTViewController.m
//  YouAreThere
//
//  Created by Maria Saveleva on 01/12/13.
//  Copyright (c) 2013 Maria Saveleva. All rights reserved.
//

#define COORDINATES_DELTA 50

#import "YTViewController.h"

@interface YTViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKPointAnnotation *pin;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic) BOOL isNotified;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)saveDestinationLoc:(id)sender;
- (IBAction)cancelNotification:(id)sender;
- (void)enableDisableCancelButton;

@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    self.location = nil;
    self.pin = [[MKPointAnnotation alloc] init];
    self.pin.title = @"Get here";
    
    self.isNotified = NO;
    [self enableDisableCancelButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)saveDestinationLoc:(id)sender {
    if (self.isNotified) {
        self.isNotified = NO;
    }
    
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    self.location = userLocation;
    
    [self.pin setCoordinate:location];
    [self.mapView addAnnotation:self.pin];
    
    [self.locationManager startUpdatingLocation];
    [self enableDisableCancelButton];
}

- (IBAction)cancelNotification:(id)sender
{
    self.location = nil;
    [self.mapView removeAnnotation:self.pin];
    [self enableDisableCancelButton];
    [self.locationManager stopUpdatingLocation];
}

- (void)enableDisableCancelButton
{
    if (!self.location) {
        self.cancelButton.enabled = NO;
    } else {
        self.cancelButton.enabled = YES;
    }
}

- (void)notifyAboutPlace
{
    if (self.isNotified) {
        return;
    }
    
    self.isNotified = YES;
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:nil];
    [notification setAlertBody:@"Hi! It's LocalNotification!"];
    notification.soundName = @"VOCALOID solo.caf";
//    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)checkIfCoorinatesAreEqual:(CLLocation *)currentLocation
{
    if (self.location) {
        NSInteger distance = [currentLocation distanceFromLocation:self.location];
        NSLog(@"DISTANCE: %d", distance);
        if (distance <= COORDINATES_DELTA) {
            if (self.isNotified) {
                return;
            }
            [self notifyAboutPlace];
        }
    }
}

#pragma mark - CLLocation methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    [self checkIfCoorinatesAreEqual:location];
}

@end
