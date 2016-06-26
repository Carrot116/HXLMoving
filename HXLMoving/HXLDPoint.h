//
//  HXLDPoint.h
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMKUserLocation, CLLocation;
@interface HXLDPoint : NSObject

@property (assign, nonatomic, readonly) NSTimeInterval timestamp;
@property (assign, nonatomic, readonly) NSInteger moveid;
@property (copy, nonatomic, readonly) NSString* posText;
@property (strong, nonatomic, readonly) CLLocation* location;

- (instancetype)initWithBMKUserLocation:(BMKUserLocation*)location;
- (void)updateWithBMKUserLocation:(BMKUserLocation*)location;
@end
