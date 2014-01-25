//
//  YTLocationManager.m
//  YouAreThere
//
//  Created by Maria Saveleva on 1/15/14.
//  Copyright (c) 2014 Maria Saveleva. All rights reserved.
//

#define COORDINATES_DELTA 50
#define SOUND_NAME @"Sound.caf"

static NSString* const kLocationDetected = @"locationDetected";

#import "YTLocationManager.h"

@interface YTLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *userLocation;

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
    }
    
    return self;
}

- (void)checkIfCoordinatesAreEqual:(CLLocation *)location
{
    if (self.userLocation) {
        NSInteger distance = [location distanceFromLocation:self.userLocation];
        
        NSLog(@"Distance: %d", distance);
        if (distance <= COORDINATES_DELTA) {
            [self notifyAboutPlace];
        }
    }
}

- (void)notifyAboutPlace
{
    if (self.userLocation) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        [notification setFireDate:nil];
        [notification setAlertBody:NSLocalizedString(@"You are there", nil)];
        notification.soundName = SOUND_NAME;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationDetected object:self];
        
        self.userLocation = nil;
    }
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
