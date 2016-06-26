//
//  HXLMovement.h
//  HXLMoving
//
//  Created by Carrot on 16/6/24.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLMovement.h"
#import "BaiduMapAPI.h"

@interface HXLMovement ()
@property (strong, nonatomic, readwrite) NSMutableArray* dataArr; 
@end

@implementation HXLMovement
- (NSArray*)testData{
    NSMutableArray* arr_m = [NSMutableArray array];
    CLLocation* location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(31.199, 121.520) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
    HXLDPoint* pos = [[HXLDPoint alloc]initWithLocation:location];
    [arr_m addObject:pos];
    
    location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(32.199, 121.520) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
    pos = [[HXLDPoint alloc]initWithLocation:location];
    [arr_m addObject:pos];
    
    location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(33.199, 121.520) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
    pos = [[HXLDPoint alloc]initWithLocation:location];
    [arr_m addObject:pos];
    
    return [arr_m copy];
}
- (instancetype)initWithMoveID:(NSInteger)ID moveType:(HXLMovingType)type{
    self = [super init];
    if (self) {
        self.moveid = ID;
        self.moveType = type;
    }
    return self;
}

- (void)addUserLocation:(BMKUserLocation*)location{
    HXLDPoint* pos = [[HXLDPoint alloc]initWithBMKUserLocation:location];
    [_dataArr addObject:pos];
}

- (NSMutableArray*)dataArr{
    if (!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
