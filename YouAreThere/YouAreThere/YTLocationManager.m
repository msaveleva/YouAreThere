//
//  YTLocationManager.m
//  YouAreThere
//
//  Created by Maria Saveleva on 1/15/14.
//  Copyright (c) 2014 Maria Saveleva. All rights reserved.
//

static NSString* const kSoundName = @"Sound.caf";
static const CGFloat kCoordinatesDelta = 50.0f;

NSString* const kLocationDetected = @"locationDetected";

#import "YTLocationManager.h"

@interface YTLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)checkIfCoordinatesAreEqual:(CLLocation *)location;
- (void)notifyAboutPlace;

@end

@implementation YTLocationManager

+ (instancetype)sharedManager
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
        
        NSLog(@"Distance: %d", (int)distance);
        if (distance <= kCoordinatesDelta) {
            [self notifyAboutPlace];
        }
    }
}

- (void)notifyAboutPlace
{
    if (self.userLocation) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        [notification setFireDate:nil];
        [notification setAlertBody:NSLocalizedString(@"youAreThere", nil)];
        notification.soundName = kSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationDetected object:self];
        
        self.userLocation = nil;
    }
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
