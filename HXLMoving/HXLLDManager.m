//
//  HXLLDManager.m
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLLDManager.h"
#import "HXLStorage.h"
#import "HXLLLService.h"
#import "HXLMovement.h"
#import "BaiduMapAPI.h"

#import <CoreLocation/CoreLocation.h>

@interface HXLLDManager () <HXLLLServiceDelegate>
@property (nonatomic, strong) HXLLLService* localService;
@property (nonatomic, strong, readwrite) BMKUserLocation* bmkUserLocation;
@property (assign, nonatomic, readwrite) CLLocation* location;
@property (assign, nonatomic, readwrite) HXLMovingState moveState;

@property (nonatomic, strong, readwrite) HXLMovement* currentMovement;

@end

@implementation HXLLDManager

- (HXLLLService*)localService{
    if (!_localService) {
        _localService = [[HXLLLService new] init];
        _localService.delegate = self;
    }
    return _localService;
}

- (HXLMovement*)currentMovement{
    if (!_currentMovement) {
        _currentMovement = [HXLMovement new];
    }
    return _currentMovement;
}

- (void)setMoveType:(HXLMovingType)moveType{
    _moveType = moveType;
    if (_moveType == HXLMovingTypeNone) {
        [self storageUerLocation];
    }
}

- (void)startLocation{
    [self.localService startLocation];
}

- (void)stopLocation{
    [self.localService stopLocation];
}


- (void)startMove{
    self.currentMovement.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)endMove{
    self.currentMovement.endTime = [[NSDate date] timeIntervalSince1970];
}

- (void)pauseMove{
    self.moveState = HXLMovingStatePause;
}

- (void)addNewUserLocation:(BMKUserLocation*)location{
    if (self.moveState == HXLMovingStatePause) return;
    
    [self.currentMovement addUserLocation:location];
}

- (void)storageUerLocation{
    __weak __typeof(self) weakSelf = self;
    [[HXLStorage shared] storageData:self.currentMovement withBlock:^(BOOL bResult) {
        if (bResult) {
            weakSelf.currentMovement = nil;
        }
    }];
}

#pragma mark -- HXLLLServiceDelegate
- (void)willStartLocatingUser{
  
}

- (void)didStopLocatingUser{

}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    self.bmkUserLocation = userLocation;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.bmkUserLocation = userLocation;
    self.location = userLocation.location;
    if (self.moveType != HXLMovingTypeNone) {
        [self addNewUserLocation:userLocation];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
//    HXLLOG(@"%@", error);
}
@end
