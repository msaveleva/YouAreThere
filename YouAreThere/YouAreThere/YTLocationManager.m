//
//  YTLocationManager.m
//  YouAreThere
//
//  Created by Maria Saveleva on 1/15/14.
//  Copyright (c) 2014 Maria Saveleva. All rights reserved.
//

#define COORDINATES_DELTA 30
#define SOUND_NAME @"Sound.caf"
#define LOCATION_DETECTED @"Location detected"

#import "YTLocationManager.h"

@interface YTLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic) BOOL isNotified;

- (void)checkIfCoordinatesAreEqual:(CLLocation *)location;
- (void)notifyAboutPlace;

@end

@implementation YTLocationManager

+ (id)sharedManager
{
    static YTLocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YTLocationManager alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.isNotified = NO;
    }
    
    return self;
}

- (void)checkIfCoordinatesAreEqual:(CLLocation *)location
{
    if (self.userLocation) {
        NSInteger distance = [location distanceFromLocation:self.userLocation];
        
        if (distance <= COORDINATES_DELTA) {
            if (self.isNotified) {
                return;
            }
            [self notifyAboutPlace];
        }
    }
}

- (void)notifyAboutPlace
{
    self.isNotified = YES;
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:nil];
    [notification setAlertBody:NSLocalizedString(@"You are there", nil)];
    notification.soundName = SOUND_NAME;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_DETECTED object:self];
}

- (void)setUserLocation:(CLLocation *)userLocation
{
    _userLocation = userLocation;
}

#pragma mark - CLLocationManager methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [self checkIfCoordinatesAreEqual:location];
}

#pragma mark - YTLocationManager Utilities

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}
@end
