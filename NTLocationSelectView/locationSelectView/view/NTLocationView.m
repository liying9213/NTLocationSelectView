//
//  NTLocationView.m
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/15.
//  Copyright © 2016年 liying. All rights reserved.
//
#import "NTLocationTableViewCell.h"
#import "NTShowLocationView.h"
#import "NTLocationManager.h"
#import "NTLocationView.h"
#import "UIView+Frame.h"
#import "NTLocation.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface NTLocationView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,weak) NTShowLocationView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,copy) NSArray * dataSouce;
@property (nonatomic,copy) NSArray * cityDataSouce;
@property (nonatomic,copy) NSArray * countyDataSouce;
@property (nonatomic,copy) NSArray * streetDataSouce;
@property (nonatomic,strong) NSMutableArray * selectItems;
@property (nonatomic,strong) NSMutableArray * tableViews;
@property (nonatomic,strong) NSMutableArray * topTabbarItems;
@property (nonatomic,weak) UIButton * selectedBtn;
@end

@implementation NTLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetView];
    }
    return self;
}


- (void)resetVithCode:(NSString *)areaCode{
    [self resetViewWithData:areaCode];
}

#pragma mark - resetView

- (void)resetView{
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.center = topView.center;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];
    
    NTShowLocationView * topTabbar = [[NTShowLocationView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, 30)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:36.0/255.0 blue:98.0/255.0 alpha:1];
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - 40 - 30)];
    contentView.contentSize = CGSizeMake(ScreenWidth, 0);
    contentView.tag = 999;
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    _contentView.delegate = self;
    
}

- (void)addTableView{
    
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * ScreenWidth, 0, ScreenWidth, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"NTLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"NTLocationTableViewCell"];
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor colorWithRed:255.0/255.0 green:36.0/255.0 blue:98.0/255.0 alpha:1] forState:UIControlStateSelected];
    [topBarItem sizeToFit];
    topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - private

//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * ScreenWidth, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn{
    
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address{
    
    NSInteger index = self.contentView.contentOffset.x / ScreenWidth;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    NSMutableString * locationStr = [[NSMutableString alloc] init];
    for (UIButton * btn  in self.topTabbarItems) {
        [locationStr appendString:btn.currentTitle];
    }
    for (int i = 0;i<self.selectItems.count;i++) {
        if (!self.areaCode) {
            self.areaCode = [[NSString alloc] init];
        }
        if (i == self.selectItems.count-1) {
            self.areaCode = [self.areaCode stringByAppendingFormat:@"%@",self.selectItems[i]];
        }
        else{
            self.areaCode = [self.areaCode stringByAppendingFormat:@"%@;",self.selectItems[i]];
        }
    }
    self.location = locationStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{
    
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / ScreenWidth;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * ScreenWidth,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + ScreenWidth, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        return self.cityDataSouce.count;
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        return self.countyDataSouce.count;
    }else if ([self.tableViews indexOfObject:tableView] == 3){
        return self.streetDataSouce.count;
    }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * _cellIdentify = @"cell";
    NTLocationTableViewCell * iCell = [tableView dequeueReusableCellWithIdentifier:_cellIdentify];
    if (iCell == nil)
    {
        NTLocationTableViewCell *_iCell=[[NTLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentify];
        iCell=_iCell;
    }
    iCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NTLocation * item;
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0){
        item = self.dataSouce[indexPath.row];
        //市级别
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
        //县级别
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        item = self.countyDataSouce[indexPath.row];
    }
    else if ([self.tableViews indexOfObject:tableView] == 3){
        item = self.streetDataSouce[indexPath.row];
    }
    iCell.item = item;
    return iCell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.tableViews indexOfObject:tableView] == 0){
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        NTLocation * provinceItem = self.dataSouce[indexPath.row];
        [self setSelectItem:provinceItem withIndex:0];
        self.cityDataSouce = [[NTLocationManager sharedManager] getCityDataBy:provinceItem.currentID];
        if(self.cityDataSouce.count == 0){
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self setUpAddress:provinceItem.locationName];
            return indexPath;
        }
        //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            
            NSInteger count = self.tableViews.count;
            for (NSInteger i = 0; i<count-1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.locationName];
            return indexPath;
            
        }else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0){
            
            NSInteger count = self.tableViews.count;
            for (NSInteger i = 0; i<count-1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.locationName];
            return indexPath;
        }
        
        //之前未选中省，第一次选择省
        [self addTopBarItem];
        [self addTableView];
        NTLocation * item = self.dataSouce[indexPath.row];
        [self scrollToNextItem:item.locationName];
        
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        
        NTLocation * cityItem = self.cityDataSouce[indexPath.row];
        [self setSelectItem:cityItem withIndex:1];
        self.countyDataSouce = [[NTLocationManager sharedManager] getCountyDataBy:cityItem.currentID];
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            
            NSInteger count = self.tableViews.count;
            for (NSInteger i = 0; i<count-2; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:cityItem.locationName];
            return indexPath;
            
        }else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0){
            
            [self scrollToNextItem:cityItem.locationName];
            return indexPath;
        }
        
        [self addTopBarItem];
        [self addTableView];
        NTLocation * item = self.cityDataSouce[indexPath.row];
        [self scrollToNextItem:item.locationName];
        
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        NTLocation * countyitem = self.countyDataSouce[indexPath.row];
        [self setSelectItem:countyitem withIndex:2];
        self.streetDataSouce = [[NTLocationManager sharedManager] getStreetDataBy:countyitem.currentID];
        if(self.streetDataSouce.count == 0){
            [self setUpAddress:countyitem.locationName];
        }
        else{
            NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
            
            if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
                
                NSInteger count = self.tableViews.count;
                for (NSInteger i = 0; i<count-3; i++) {
                    [self removeLastItem];
                }
                [self addTopBarItem];
                [self addTableView];
                [self scrollToNextItem:countyitem.locationName];
                return indexPath;
                
            }else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0){
                
                [self scrollToNextItem:countyitem.locationName];
                return indexPath;
            }
            
            [self addTopBarItem];
            [self addTableView];
            NTLocation * item = self.countyDataSouce[indexPath.row];
            [self scrollToNextItem:item.locationName];
        }
    }
    else if ([self.tableViews indexOfObject:tableView] == 3){
        NTLocation * item = self.streetDataSouce[indexPath.row];
        [self setSelectItem:item withIndex:3];
        [self setUpAddress:item.locationName];
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NTLocation * item;
    if([self.tableViews indexOfObject:tableView] == 0){
        item = self.dataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        item = self.countyDataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 3){
        item = self.streetDataSouce[indexPath.row];
    }
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NTLocation * item;
    if([self.tableViews indexOfObject:tableView] == 0){
        item = self.dataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        item = self.countyDataSouce[indexPath.row];
    }else if ([self.tableViews indexOfObject:tableView] == 3){
        item = self.streetDataSouce[indexPath.row];
    }
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 999) {
        NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
        [UIView animateWithDuration:0.3 animations:^{
            [self changeUnderLineFrame:self.topTabbarItems[index]];
        }];
    }
    
}

#pragma mark - 开始就有地址时.

- (void)resetViewWithData:(NSString *)areaCode{
    NSArray * ary = [areaCode componentsSeparatedByString:@";"];
    if (ary.count>1) {
        self.cityDataSouce = [[NTLocationManager sharedManager] getCityDataBy:[ary[0] integerValue]];
    }
    if (ary.count>2) {
        self.countyDataSouce = [[NTLocationManager sharedManager] getCountyDataBy:[ary[1] integerValue]];
    }
    if (ary.count>3) {
        self.streetDataSouce = [[NTLocationManager sharedManager] getStreetDataBy:[ary[2] integerValue]];
    }
    
    for (int i = 0 ; i<ary.count-1; i++) {
        [self addTableView];
        [self addTopBarItem];
    }
    [self setSelectedWithArray:ary];
    
    [self.topTabbarItems makeObjectsPerformSelector:@selector(sizeToFit)];
    [_topTabbar layoutIfNeeded];
    
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    //2.4 设置偏移量
    self.contentView.contentSize = (CGSize){self.tableViews.count * ScreenWidth,0};
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake((self.tableViews.count - 1) * ScreenWidth, offset.y);
    
}

//初始化选中状态
- (void)setSelectedWithArray:(NSArray *)selectAry{
    if (selectAry.count>0) {
        for (NTLocation * item in self.dataSouce) {
            if (item.currentID == [selectAry[0] integerValue]) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataSouce indexOfObject:item] inSection:0];
                UITableView * tableView  = self.tableViews.firstObject;
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                
                UIButton * selectBtn = self.topTabbarItems.firstObject;
                [selectBtn setTitle:item.locationName forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    if (selectAry.count>1) {
        for (NTLocation * item in self.cityDataSouce) {
            if (item.currentID == [selectAry[1] integerValue]) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.cityDataSouce indexOfObject:item] inSection:0];
                UITableView * tableView  = self.tableViews[1];
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                
                UIButton * selectBtn = self.topTabbarItems[1];
                [selectBtn setTitle:item.locationName forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    if (selectAry.count>2) {
        for (NTLocation * item in self.countyDataSouce) {
            if (item.currentID == [selectAry[2] integerValue]) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.countyDataSouce indexOfObject:item] inSection:0];
                UITableView * tableView  = self.tableViews[2];
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                
                UIButton * selectBtn = self.topTabbarItems[2];
                [selectBtn setTitle:item.locationName forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    if (selectAry.count>3) {
        for (NTLocation * item in self.streetDataSouce) {
            if (item.currentID == [selectAry[3] integerValue]) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.streetDataSouce indexOfObject:item] inSection:0];
                UITableView * tableView  = self.tableViews[3];
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                
                UIButton * selectBtn = self.topTabbarItems[3];
                [selectBtn setTitle:item.locationName forState:UIControlStateNormal];
                break;
            }
        }
    }
}

#pragma mark - getter 方法

//分割线
- (UIView *)separateLine{
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}

- (NSMutableArray *)selectItems{
    if (_selectItems == nil) {
        _selectItems = [NSMutableArray array];
    }
    return _selectItems;
}

- (void)setSelectItem:(NTLocation *)location withIndex:(NSInteger)index{
    NSInteger count = self.selectItems.count;
    for (NSInteger i = index; i<count-index; i++) {
        [self.selectItems removeLastObject];
    }
    [self.selectItems addObject:[NSNumber numberWithInteger:location.currentID]];
}

//省级别数据源
- (NSArray *)dataSouce{
    
    if (_dataSouce == nil) {
        
        _dataSouce = [[NTLocationManager sharedManager] getProvinceData];
    }
    return _dataSouce;
}

@end
