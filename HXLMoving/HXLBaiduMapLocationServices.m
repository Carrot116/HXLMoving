//
//  HXLBaiduMapLocationServices.m
//  HXLMoving
//
//  Created by Carrot on 16/5/9.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLBaiduMapLocationServices.h"
#import "BaiduMapAPI.h"

@interface HXLBaiduMapLocationServices () <BMKLocationServiceDelegate>

@property (nonatomic, strong, readwrite) BMKLocationService* locationService;

@end

@implementation HXLBaiduMapLocationServices

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
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    NSLog(@"willStartLocatingUser");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    NSLog(@"didStopLocatingUser");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"didUpdateUserHeading");
    NSLog(@"%@", userLocation);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"didUpdateBMKUserLocation");
    NSLog(@"%@", userLocation);
    
    self.currentCoordinate = userLocation.location.coordinate;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败%@",error);
}

@end
