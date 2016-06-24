//
//  HXLLDManager.h
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "HXLMovement.h"

@class BMKUserLocation;
@interface HXLLDManager : NSObject

@property (strong, nonatomic, readonly) BMKUserLocation* bmkUserLocation;
@property (assign, nonatomic, readonly) CLLocation* location;
@property (assign, nonatomic, readonly) HXLMovingState moveState;
@property (assign, nonatomic) HXLMovingType moveType;

- (void)stopLocation;
- (void)startLocation;


- (void)startMove;
- (void)endMove;
- (void)pauseMove;

@end
