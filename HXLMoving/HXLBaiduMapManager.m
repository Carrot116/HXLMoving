//
//  HXLBaiduMapManager.m
//  HXLMoving
//
//  Created by Carrot on 16/4/19.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLBaiduMapManager.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>           //引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>             //引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>       //引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>   //引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>   //引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>         //引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>         //引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>                  //只引入所需的单个头文件

NSString* const baiduMapKey = @"iD1ydAZ2c5XohFBt7EtEanjnkte9o0f3";

static HXLBaiduMapManager* sharedInstance;
@implementation HXLBaiduMapManager
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HXLBaiduMapManager new];
    });
    return sharedInstance;
}

+ (BOOL)registBaiduMap:(NSString*)key{
    BMKMapManager* mapManager = [[BMKMapManager alloc] init];
    return [mapManager start:key generalDelegate:nil];
}
@end
