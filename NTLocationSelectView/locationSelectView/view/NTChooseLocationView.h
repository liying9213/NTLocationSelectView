//
//  NTChooseLocationView.h
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/20.
//  Copyright © 2016年 liying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTLocationView.h"

@interface NTChooseLocationView : UIView

@property (nonatomic, strong)NTLocationView * locationView;

@property (nonatomic, copy)void(^showAnimate)();

@property (nonatomic, copy)void(^hiddenAnimate)();

- (void)showLocationViewWithData:(NSString *)locationCode WithBlock:(void(^)(NSString *location, NSString * locationCode))selectFinish;

@end
