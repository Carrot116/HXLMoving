//
//  HXLLocationService.m
//  HXLMoving
//
//  Created by Carrot on 16/4/19.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLLocationService.h"
#import <CoreLocation/CoreLocation.h>

@interface HXLLocationService () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation HXLLocationService

- (CLLocationManager*)locationManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
            //开始定位用户的位置
//           [self.locationManager startUpdatingLocation];
          //每隔多少米定位一次（这里的设置为任何的移动）
           self.locationManager.distanceFilter=kCLDistanceFilterNone;
           //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
        } else {//不能定位用户的位置
            //1.提醒用户检查当前的网络状况
            //2.提醒用户打开定位开关
        }
        
        //测试方法，计算两个位置之间的距离
        [self countDistance];
    }
    
    return _locationManager;
}


#pragma mark - location switch
- (void)stopLocationService{
    [self.locationManager stopUpdatingLocation];
}

- (void)startLocationService{
    [self.locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
     //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *loc = [locations firstObject];

     //维度：loc.coordinate.latitude
     //经度：loc.coordinate.longitude
     NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
     NSLog(@"%lu",(unsigned long)locations.count);

     //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
 //    [self.locMgr stopUpdatingLocation];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager{
    
}

//计算两个位置之间的距离
-(void)countDistance
{
     //根据经纬度创建两个位置对象
     CLLocation *loc1=[[CLLocation alloc]initWithLatitude:40 longitude:116];
     CLLocation *loc2=[[CLLocation alloc]initWithLatitude:41 longitude:116];
     //计算两个位置之间的距离
     CLLocationDistance distance=[loc1 distanceFromLocation:loc2];
     NSLog(@"(%@)和(%@)的距离=%fM",loc1,loc2,distance);
}



@end
