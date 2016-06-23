//
//  HXLStorage.m
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLStorage.h"

#import <FMDB/FMDB.h>

static NSString* const kDBQueuePathName = @"com.hxlmoving.carrot";
static NSString* const kTableNameMove = @"t_move";

@interface HXLStorage (){
    dispatch_queue_t _queue;
}
@property (strong, nonatomic) FMDatabaseQueue* dbQueue;
@end

@implementation HXLStorage

- (instancetype)init{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("queue.moving", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (FMDatabaseQueue*)dbQueue{
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:kDBQueuePathName];
    }
    return _dbQueue;
}

- (void)createTableWithName:(NSString*)tName{
    dispatch_async(_queue, ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            // do something
        }];
    });
}

@end
