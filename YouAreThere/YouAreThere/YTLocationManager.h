//
//  YTLocationManager.h
//  YouAreThere
//
//  Created by Maria Saveleva on 1/15/14.
//  Copyright (c) 2014 Maria Saveleva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YTLocationManager : NSObject <CLLocationManagerDelegate>

+ (id)sharedManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
