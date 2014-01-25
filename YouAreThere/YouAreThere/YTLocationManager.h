//
//  YTLocationManager.h
//  YouAreThere
//
//  Created by Maria Saveleva on 1/15/14.
//  Copyright (c) 2014 Maria Saveleva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const kLocationDetected;

@interface YTLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *userLocation;

+ (instancetype)sharedManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
