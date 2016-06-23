//
//  HXLLDManager.h
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class BMKUserLocation;
@interface HXLLDManager : NSObject

@property (strong, nonatomic, readonly) BMKUserLocation* bmkUserLocation;
@property (assign, nonatomic, readonly) CLLocation* location;

- (void)stopLocation;
- (void)startLocation;
@end
