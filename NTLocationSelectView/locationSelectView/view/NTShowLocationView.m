//
//  NTShowLocationView.m
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/19.
//  Copyright © 2016年 liying. All rights reserved.
//

#import "NTShowLocationView.h"
#import "UIView+Frame.h"

@interface NTShowLocationView ()
@property (nonatomic,strong) NSMutableArray * btnArray;
@end

@implementation NTShowLocationView

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1 ; i++) {
        
        UIView * view = self.btnArray[i];
        if (i == 0) {
            view.left = 20;
        }
        if (i > 0) {
            UIView * preView = self.btnArray[i - 1];
            view.left = 20  + preView.right;
        }
        
    }
}

- (NSMutableArray *)btnArray{
    
    NSMutableArray * mArray  = [NSMutableArray array];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

@end
