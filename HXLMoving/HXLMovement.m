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
