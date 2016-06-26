//
//  HXLPolyline.m
//  HXLMoving
//
//  Created by Carrot on 16/6/26.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLPolyline.h"
#import "HXLDPoint.h"

@implementation HXLPolyline

- (instancetype)initWithPointArray:(NSArray*)points{
    CLLocationCoordinate2D* pts = new CLLocationCoordinate2D[points.count];
    for (int i = 0;  i < points.count; i++) {
        pts[i] = ((HXLDPoint*)(points[i])).location.coordinate;
    }
    [self setPolylineWithCoordinates:pts count:points.count];
    return self;
}
+ (instancetype)polyLineWithPointArray:(NSArray*)points{
    return [[[self class] alloc] initWithPointArray:points];
}
@end
