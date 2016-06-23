//
//  HXLLDManager.m
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLLDManager.h"
#import "HXLLLService.h"
#import "BaiduMapAPI.h"

#import <CoreLocation/CoreLocation.h>

@interface HXLLDManager () <HXLLLServiceDelegate>
@property (nonatomic, strong) HXLLLService* localService;
@property (nonatomic, strong, readwrite) BMKUserLocation* bmkUserLocation;
@property (assign, nonatomic, readwrite) CLLocation* location;
@end

@implementation HXLLDManager

- (HXLLLService*)localService{
    if (!_localService) {
        _localService = [[HXLLLService new] init];
    }
    return _localService;
}

- (void)startLocation{
    [self.localService startLocation];
}
- (void)stopLocation{
    [self.localService stopLocation];
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
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@", error);
}
@end
