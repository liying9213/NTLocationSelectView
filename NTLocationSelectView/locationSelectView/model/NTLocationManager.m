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
            model.currentID = [result stringForColumn:@"id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (NSMutableArray *)getCityDataBy:(NSString *)ID{
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM City WHERE province_id like '%@' ORDER BY id",ID];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            NTLocation *model = [[NTLocation alloc] init];
            model.locationName = [result stringForColumn:@"name"];
            model.currentID = [result stringForColumn:@"id"];
            model.fatherID = [result stringForColumn:@"province_id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (NSMutableArray *)getCountyDataBy:(NSString *)ID{
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM County WHERE city_id like '%@' ORDER BY id",ID];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            NTLocation *model = [[NTLocation alloc] init];
            model.locationName = [result stringForColumn:@"name"];
            model.currentID = [result stringForColumn:@"id"];
            model.fatherID = [result stringForColumn:@"city_id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}

- (NSMutableArray *)getStreetDataBy:(NSString *)ID{
    if ([self.fmdb  open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Street WHERE county_id like '%@' ORDER BY id",ID];
        FMResultSet *result = [self.fmdb  executeQuery:sql];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while ([result next]) {
            NTLocation *model = [[NTLocation alloc] init];
            model.locationName = [result stringForColumn:@"name"];
            model.currentID = [result stringForColumn:@"id"];
            model.fatherID = [result stringForColumn:@"county_id"];
            [array addObject:model];
        }
        [self.fmdb close];
        return array;
    }
    return nil;
}



@end
