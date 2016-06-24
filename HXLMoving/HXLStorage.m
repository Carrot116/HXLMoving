//
//  HXLStorage.m
//  HXLMoving
//
//  Created by Carrot on 16/6/23.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "HXLStorage.h"

#import "HXLMovement.h"
#import <FMDB/FMDB.h>

static NSString* const kDBFileName = @"hxlmoveing.db";
static char* const kDBQueueName = "com.hxlmoving.carrot";
static NSString* const kTableNameDay = @"t_day";
static NSString* const kTableNameHis = @"t_His";

static NSString* const kTableDayFormat = @"id integer PRIMARY KEY AUTOINCREMENT NOT NULL,moveid integer NOT NULL,pos text NOT NULL,stamp double NOT NULL";
static NSString* const kTableHisFormat = @"id integer PRIMARY KEY AUTOINCREMENT NOT NULL,moveid integer NOT NULL,pos text NOT NULL,stamp double NOT NULL";

@interface HXLStorage (){
    dispatch_queue_t _queue;
}
@property (strong, nonatomic) FMDatabaseQueue* dbQueue;
@end

@implementation HXLStorage

+ (instancetype)shared{
    static HXLStorage* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HXLStorage new];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create(kDBQueueName, DISPATCH_QUEUE_SERIAL);
        [self createTableWithName:kTableNameDay Format:kTableNameDay];
        [self createTableWithName:kTableNameHis Format:kTableNameHis];
    }
    return self;
}

- (FMDatabaseQueue*)dbQueue{
    if (!_dbQueue) {
        NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString* dbPath = [documentPath stringByAppendingPathComponent:kDBFileName];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return _dbQueue;
}

- (void)createTableWithName:(NSString*)tName Format:(NSString*)format{
    dispatch_async(_queue, ^{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            // do something
            NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);", tName, format];
            [db executeStatements:sql];
        }];
    });
}

- (void)storageData:(HXLMovement*)moveData withBlock:(StorageCallBackBlock)block{
    dispatch_async(_queue, ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString* sqlStatement = nil;
            NSArray* dataArray = moveData.dataArr;
            BOOL bRes = YES;
            for (int i = 0; i < dataArray.count; i++) {
                HXLDPoint* pos = (HXLDPoint*)(dataArray[i]);
                sqlStatement = [NSString stringWithFormat:@"insert into %@ (moveid,pos,stamp) values (%ld, %@, %f)",kTableNameDay,(long)moveData.moveid, pos.posText, pos.timestamp];
                if (![db executeStatements:sqlStatement]){
                    bRes = NO;
                    break;
                }
            }
            if (!block) {
                block(bRes);
            }
        }];
    });
}
@end
