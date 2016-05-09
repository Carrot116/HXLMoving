//
//  HXLBaiduMapLocationServices.h
//  HXLMoving
//
//  Created by Carrot on 16/5/9.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class BMKLocationService;
@interface HXLBaiduMapLocationServices : NSObject

@property (nonatomic, strong, readonly) BMKLocationService* locationService;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

- (void)startLocation;
- (void)stopLocation;

@end
