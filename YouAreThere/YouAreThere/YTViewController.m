//
//  YTViewController.m
//  YouAreThere
//
//  Created by Maria Saveleva on 01/12/13.
//  Copyright (c) 2013 Maria Saveleva. All rights reserved.
//

#define SOUND_NAME @"VOCALOID solo.caf"
#define COORDINATES_DELTA 30
#define CANCEL_ANIMATION 0.2

#import "YTViewController.h"

@interface YTViewController ()

@property (nonatomic) BOOL cancelMenuHidden;
@property (nonatomic) BOOL tapViewHidden;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKPointAnnotation *pin;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic) BOOL isNotified;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;


- (IBAction)saveDestinationLoc:(id)sender;
- (IBAction)cancelNotification:(id)sender;
- (void)enableDisableCancelButton;
- (void)showCancelMenu;
- (void)hideCancelMenu;
- (void)hideTapView;
- (void)showTapView;

@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.location = nil;
    self.pin = [[MKPointAnnotation alloc] init];
    
    self.isNotified = NO;
    [self enableDisableCancelButton];
    self.cancelMenuHidden = YES;
    self.tapViewHidden = NO;
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get here?"
                                                    message:@"Wake you up when get here?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
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
        
        [self.locationManager startUpdatingLocation];
        [self enableDisableCancelButton];
        
        [self showCancelMenu];
        [self hideTapView];
    }
}

- (IBAction)cancelNotification:(id)sender
{
    self.location = nil;
    [self.mapView removeAnnotation:self.pin];
    [self enableDisableCancelButton];
    [self.locationManager stopUpdatingLocation];
    
    [self hideCancelMenu];
    [self showTapView];
}

- (void)enableDisableCancelButton
{
    if (!self.location) {
        self.cancelButton.enabled = NO;
//        self.cancelButton.titleLabel.text = @"Tap to set up destination point";
    } else {
        self.cancelButton.enabled = YES;
//        self.cancelButton.titleLabel.text = @"Cancel notification";
    }
}

- (void)showCancelMenu
{
    if (self.cancelMenuHidden) {
        [UIView animateWithDuration:CANCEL_ANIMATION animations:^{
            CGPoint origin = CGPointMake(self.cancelView.frame.origin.x,
                                         self.cancelView.frame.origin.y - self.cancelView.frame.size.height);
            CGRect frame = CGRectMake(0, 0, self.cancelView.frame.size.width,
                                      self.cancelView.frame.size.height);
            frame.origin = origin;
            self.cancelView.frame = frame;
        }];
        
        self.cancelMenuHidden = NO;
    }
}

- (void)hideCancelMenu
{
    if (!self.cancelMenuHidden) {
        [UIView animateWithDuration:CANCEL_ANIMATION animations:^{
            CGPoint origin = CGPointMake(self.cancelView.frame.origin.x,
                                         self.cancelView.frame.origin.y + self.cancelView.frame.size.height);
            CGRect frame = CGRectMake(0, 0, self.cancelView.frame.size.width,
                                      self.cancelView.frame.size.height);
            frame.origin = origin;
            self.cancelView.frame = frame;
        }];
        
        self.cancelMenuHidden = YES;
    }
}

- (void)hideTapView
{
    if (!self.tapViewHidden) {
        [UIView animateWithDuration:CANCEL_ANIMATION animations:^{
            CGPoint origin = CGPointMake(self.tapView.frame.origin.x,
                                         self.tapView.frame.origin.y - self.tapView.frame.size.height);
            CGRect frame = CGRectMake(0, 0, self.tapView.frame.size.width,
                                      self.tapView.frame.size.height);
            frame.origin = origin;
            self.tapView.frame = frame;
        }];
        
        self.tapViewHidden = YES;
    }
}

- (void)showTapView
{
    if (self.tapViewHidden) {
        [UIView animateWithDuration:CANCEL_ANIMATION animations:^{
            CGPoint origin = CGPointMake(self.tapView.frame.origin.x,
                                         self.tapView.frame.origin.y + self.tapView.frame.size.height);
            CGRect frame = CGRectMake(0, 0, self.tapView.frame.size.width,
                                      self.tapView.frame.size.height);
            frame.origin = origin;
            self.tapView.frame = frame;
        }];
        
        self.tapViewHidden = NO;
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
    [notification setAlertBody:NSLocalizedString(@"You are there", nil)];
    notification.soundName = SOUND_NAME;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [self hideCancelMenu];
    [self.mapView removeAnnotation:self.pin];
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
