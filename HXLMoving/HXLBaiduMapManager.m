//
//  HXLBaiduMapManager.m
//  HXLMoving
//
//  Created by Carrot on 16/4/19.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLBaiduMapManager.h"

NSString* const baiduMapKey = @"iD1ydAZ2c5XohFBt7EtEanjnkte9o0f3";

static HXLBaiduMapManager* sharedInstance;

@interface HXLBaiduMapManager ()
@property (strong, nonatomic, readwrite) BMKMapManager* mapManager;

@end

@implementation HXLBaiduMapManager
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HXLBaiduMapManager new];
    });
    return sharedInstance;
}

- (BOOL)registBaiduMap:(NSString*)key{
    return [self.mapManager start:key generalDelegate:[HXLBaiduMapManager sharedInstance]];
}

- (BMKMapManager*)mapManager{
    if (!_mapManager){
        _mapManager = [[BMKMapManager alloc] init];
    }
    return _mapManager;
}

- (void)onGetNetworkState:(int)iError{
    if (BMKErrorOk == iError){
        HXLLOG(@"网络正常");
    } else {
        HXLLOG(@"网络异常[%d]",iError);
    }
}

- (void)onGetPermissionState:(int)iError{
    if (iError == E_PERMISSIONCHECK_OK) {
        HXLLOG(@"授权成功");
    } else {
        HXLLOG(@"授权失败[%d]", iError);
    }
}

@end
