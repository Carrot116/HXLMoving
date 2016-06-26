//
//  HXLLocationData.m
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLDPoint.h"
#import "BaiduMapAPI.h"

@interface HXLDPoint ()
@property (assign, nonatomic, readwrite) NSTimeInterval timestamp;
@property (assign, nonatomic, readwrite) NSInteger moveid;
@property (copy, nonatomic, readwrite) NSString* posText;
@property (strong, nonatomic, readwrite) CLLocation* location;
@end

@implementation HXLDPoint

- (instancetype)initWithBMKUserLocation:(BMKUserLocation*)location{
    self = [super init];
    if (self) {
        [self updateWithBMKUserLocation:location];
    }
    return self;
}

- (void)updateWithBMKUserLocation:(BMKUserLocation*)location{
    _location = location.location;
    self.timestamp = [location.location.timestamp timeIntervalSince1970];
}

@end
