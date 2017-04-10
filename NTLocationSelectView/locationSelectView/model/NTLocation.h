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

@property (nonatomic, copy)NSString * currentID;

@property (nonatomic, copy)NSString * fatherID;

@property (nonatomic,assign) BOOL  isSelected;

@end
