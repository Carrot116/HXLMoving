//
//  HXLBaiduMapLocationServices.m
//  HXLMoving
//
//  Created by Carrot on 16/5/9.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLLLService.h"
#import "BaiduMapAPI.h"

@interface HXLLLService () <BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKLocationService* locationService;
@end

@implementation HXLLLService
- (BMKLocationService*)locationService{
    if (!_locationService){
        _locationService = [BMKLocationService new];
        _locationService.delegate = self;
        _locationService.distanceFilter = kCLLocationAccuracyBestForNavigation;
        [_locationService startUserLocationService];
    }
    return _locationService;
}

- (void)startLocation {
    [self.locationService startUserLocationService];
}

- (void)stopLocation{
    [self.locationService stopUserLocationService];
}

#pragma mark -- BMKLocationServiceDelegate
- (void)willStartLocatingUser{
    if ([self.delegate respondsToSelector:@selector(willStartLocatingUser)]){
        [self.delegate willStartLocatingUser];
    }
}

- (void)didStopLocatingUser{
    if ([self.delegate respondsToSelector:@selector(didStopLocatingUser)]){
        [self.delegate didStopLocatingUser];
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
//    HXLLOG(@"-- Heading --%p %p", userLocation, userLocation.heading);
    if ([self.delegate respondsToSelector:@selector(didUpdateUserHeading:)]){
        [self.delegate didUpdateUserHeading:userLocation];
    }
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//    HXLLOG(@"** Location ** %p %p",userLocation, userLocation.location);

    if ([self.delegate respondsToSelector:@selector(didUpdateBMKUserLocation:)]){
        [self.delegate didUpdateBMKUserLocation:userLocation];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLocateUserWithError:)]){
        [self.delegate didFailToLocateUserWithError:error];
    }
}

@end
