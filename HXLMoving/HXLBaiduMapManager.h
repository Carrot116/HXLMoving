//
//  HXLBaiduMapManager.h
//  HXLMoving
//
//  Created by Carrot on 16/4/19.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const baiduMapKey;

@interface HXLBaiduMapManager : NSObject
+ (instancetype)sharedInstance;
+ (BOOL)registBaiduMap:(NSString*)key;
@end
