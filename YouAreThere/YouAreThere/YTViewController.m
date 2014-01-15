//
//  YTViewController.m
//  YouAreThere
//
//  Created by Maria Saveleva on 01/12/13.
//  Copyright (c) 2013 Maria Saveleva. All rights reserved.
//

#define CANCEL_ANIMATION 0.2
#define LOCATION_DETECTED @"Location detected"

#import "YTViewController.h"
#import "YTLocationManager.h"

@interface YTViewController ()

@property (nonatomic, strong) MKPointAnnotation *pin;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic) BOOL isNotified;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


- (IBAction)saveDestinationLoc:(id)sender;
- (IBAction)cancelNotification:(id)sender;
- (void)enableDisableCancelButton;
- (void)handleLocationNotification:(NSNotification *)notification;

@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.location = nil;
    self.pin = [[MKPointAnnotation alloc] init];
    self.isNotified = NO;
    
    [self enableDisableCancelButton];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel notification", nil)
                       forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"Tap on the map to set destination", nil)
                       forState:UIControlStateDisabled];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationNotification:)
                                                 name:LOCATION_DETECTED
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)saveDestinationLoc:(id)sender {
    
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    self.location = [[CLLocation alloc] initWithLatitude:location.latitude
                                                          longitude:location.longitude];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Get there", nil)
                                                    message:NSLocalizedString(@"Wake you up there?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No", nil)
                                          otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.isNotified) {
            self.isNotified = NO;
        }
        
        [self.pin setCoordinate:self.location.coordinate];
        [self.mapView addAnnotation:self.pin];
        
        [[YTLocationManager sharedManager] startUpdatingLocation];
        [self enableDisableCancelButton];
    }
}

- (IBAction)cancelNotification:(id)sender
{
    self.location = nil;
    [self.mapView removeAnnotation:self.pin];
    [self enableDisableCancelButton];
    [[YTLocationManager sharedManager] stopUpdatingLocation];
}

- (void)enableDisableCancelButton
{
    if (!self.location) {
        self.cancelButton.enabled = NO;
    } else {
        self.cancelButton.enabled = YES;
    }
}

- (void)handleLocationNotification:(NSNotification *)notification
{
    [self.mapView removeAnnotation:self.pin];
}

//for upside down orientation support
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
