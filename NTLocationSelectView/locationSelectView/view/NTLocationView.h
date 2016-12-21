//
//  NTLocationView.h
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/15.
//  Copyright © 2016年 liying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTLocationView : UIView

@property (nonatomic, copy) NSString * location;

@property (nonatomic, copy) void(^chooseFinish)();

@property (nonatomic, copy) NSString * areaCode;

- (void)resetVithCode:(NSString *)areaCode;

@end
