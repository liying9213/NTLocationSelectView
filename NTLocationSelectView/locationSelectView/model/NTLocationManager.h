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

- (NSMutableArray *)getCityDataBy:(NSString *)ID;

- (NSMutableArray *)getCountyDataBy:(NSString *)ID;

- (NSMutableArray *)getStreetDataBy:(NSString *)ID;

@end
