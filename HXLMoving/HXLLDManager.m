//
//  HXLLDManager.m
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLLDManager.h"
#import "HXLLLService.h"

@interface HXLLDManager () <HXLLLServiceDelegate>

@end

@implementation HXLLDManager


#pragma mark -- HXLLLServiceDelegate
- (void)willStartLocatingUser{
  
}

- (void)didStopLocatingUser{

}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{

}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
}

- (void)didFailToLocateUserWithError:(NSError *)error{
}
@end
