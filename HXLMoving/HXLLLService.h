//
//  HXLBaiduMapLocationServices.h
//  HXLMoving
//
//  Created by Carrot on 16/5/9.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class BMKUserLocation;

@protocol HXLLLServiceDelegate <NSObject>
@optional
//! 在将要启动定位时，会调用此函数
- (void)willStartLocatingUser;
//! 在停止定位后，会调用此函数
- (void)didStopLocatingUser;
//! 用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation;
//! 用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;
//! 定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error;
@end


@interface HXLLLService : NSObject

@property (nonatomic, weak) id<HXLLLServiceDelegate>delegate;

- (void)startLocation;
- (void)stopLocation;

@end
