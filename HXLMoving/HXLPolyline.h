//
//  HXLPolyline.h
//  HXLMoving
//
//  Created by Carrot on 16/6/26.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "BaiduMapAPI.h"

@interface HXLPolyline : BMKPolyline

- (instancetype)initWithPointArray:(NSArray*)points;
+ (instancetype)polyLineWithPointArray:(NSArray*)points;
@end
