//
//  NTChooseLocationView.m
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/20.
//  Copyright © 2016年 liying. All rights reserved.
//

#import "NTChooseLocationView.h"
@interface NTChooseLocationView()<UIGestureRecognizerDelegate>

@end

@implementation NTChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetView];
    }
    return self;
}

- (void)resetView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    if (!_locationView) {
        _locationView = [[NTLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        
    }
    [self addSubview:_locationView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.hidden = YES;
    self.alpha = 0;
}

- (void)showLocationViewWithData:(NSString *)locationCode WithBlock:(void (^)(NSString *, NSString *))selectFinish{
    if (locationCode) {
        [_locationView resetVithCode:locationCode];
    }
    __weak typeof (self) weakSelf = self;
    _locationView.chooseFinish = ^(){
        selectFinish(weakSelf.locationView.location,weakSelf.locationView.areaCode);
        [weakSelf hiddenTheView];
    };
    [self showTheView];
}

#pragma mark - locationSelect

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_locationView.frame, point)){
        return NO;
    }
    return YES;
}

- (void)tapCover:(UITapGestureRecognizer *)tap{
    if (_locationView.chooseFinish) {
        _locationView.chooseFinish();
    }
}

#pragma mark - 

- (void)showTheView{
    self.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1;
    }];
    _showAnimate();
}

- (void)hiddenTheView{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    _hiddenAnimate();
}

@end
