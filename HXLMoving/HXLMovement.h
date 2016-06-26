//
//  HXLMovement.h
//  HXLMoving
//
//  Created by Carrot on 16/6/24.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLDPoint.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXLMovingType) {
    HXLMovingTypeNone   = 0,
    HXLMovingTypeWalk   = 1,
    HXLMovingTypeRun    = 2,
    HXLMovingTypeRide   = 3,
    
};

typedef NS_ENUM(NSInteger, HXLMovingState) {
    HXLMovingStateMoving  = 0,
    HXLMovingStatePause   = 1,
    
};

@interface HXLMovement : NSObject

@property (assign, nonatomic) NSInteger moveid;
@property (assign, nonatomic) HXLMovingType moveType;
@property (assign, nonatomic) NSTimeInterval startTime;
@property (assign, nonatomic) NSTimeInterval endTime;

@property (strong, nonatomic, readonly) NSArray* dataArr;

- (instancetype)initWithMoveID:(NSInteger)ID moveType:(HXLMovingType)type;
- (void)addUserLocation:(BMKUserLocation*)location;
@end
