//
//  NTLocationManager.h
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/15.
//  Copyright © 2016年 liying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTLocationManager : NSObject

+ (instancetype)sharedManager;

- (NSMutableArray *)getProvinceData;

- (NSMutableArray *)getCityDataBy:(NSInteger)ID;

- (NSMutableArray *)getCountyDataBy:(NSInteger)ID;

- (NSMutableArray *)getStreetDataBy:(NSInteger)ID;

@end
