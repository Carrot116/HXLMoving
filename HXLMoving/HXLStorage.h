//
//  HXLStorage.h
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StorageCallBackBlock)(BOOL);

@class HXLMovement;
@interface HXLStorage : NSObject
+ (instancetype)shared;

- (void)storageData:(HXLMovement*)moveData withBlock:(StorageCallBackBlock)block;
@end
