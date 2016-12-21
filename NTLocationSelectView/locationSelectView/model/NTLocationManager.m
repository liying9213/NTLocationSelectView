//
//  NTLocationManager.m
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/15.
//  Copyright © 2016年 liying. All rights reserved.
//

#import "NTLocationManager.h"
#import "NTLocation.h"
#import <FMDB/FMDB.h>

@interface NTLocationManager()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation NTLocationManager

static NTLocationManager *shareInstance = nil;

#pragma mark - Singleton
+ (NTLocationManager *)sharedManager
{
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [[self alloc] init];
        }
    }
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [super allocWithZone:zone];
        }
    }
    return shareInstance;
}

- (id)copy
{
    return shareInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeDB];
    }
    return self;
}

- (void)initializeDB{
    NSString *resourceBundle = [[NSBundle mainBundle] pathForResource:@"NTLocation" ofType:@"bundle"];
    self.fmdb = [[FMDatabase alloc] initWithPath:[[NSBundle bundleWithPath:resourceBundle] pathForResource:@"DB/location" ofType:@"db"]];
//    self.fmdb = [FMDatabase databaseWithPath:[[NSBundle bundleWithPath:resourceBundle] pathForResource:@"DB/location" ofType:@"db"]];
    [self.fmdb open];
}

- (NSMutableArray *)getProvinceData{
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Province ORDER BY id"];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            NTLocation *model = [[NTLocation alloc] init];
            model.locationName = [result stringForColumn:@"name"];
            model.currentID = [result intForColumn:@"id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (NSMutableArray *)getCityDataBy:(NSInteger)ID{
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM City WHERE province_id = %ld ORDER BY id",(long)ID];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            NTLocation *model = [[NTLocation alloc] init];
            model.locationName = [result stringForColumn:@"name"];
            model.currentID = [result intForColumn:@"id"];
            model.fatherID = [result intForColumn:@"province_id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (NSMutableArray *)getCountyDataBy:(NSInteger)ID{
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM County WHERE city_id = %ld ORDER BY id",(long)ID];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            NTLocation *model = [[NTLocation alloc] init];
            model.locationName = [result stringForColumn:@"name"];
            model.currentID = [result intForColumn:@"id"];
            model.fatherID = [result intForColumn:@"city_id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (NSMutableArray *)getStreetDataBy:(NSInteger)ID{
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Street WHERE county_id = %ld ORDER BY id",(long)ID];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            NTLocation *model = [[NTLocation alloc] init];
            model.locationName = [result stringForColumn:@"name"];
            model.currentID = [result intForColumn:@"id"];
            model.fatherID = [result intForColumn:@"county_id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}



@end
