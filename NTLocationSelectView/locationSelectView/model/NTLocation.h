//
//  NTLocation.h
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/15.
//  Copyright © 2016年 liying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTLocation : NSObject

@property (nonatomic, copy)NSString * locationName;

@property (nonatomic, assign)NSInteger currentID;

@property (nonatomic, assign)NSInteger fatherID;

@property (nonatomic,assign) BOOL  isSelected;

@end
