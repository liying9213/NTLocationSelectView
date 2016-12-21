//
//  NTLocationTableViewCell.m
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/19.
//  Copyright © 2016年 liying. All rights reserved.
//

#import "NTLocationTableViewCell.h"
#import <Masonry/Masonry.h>

@interface NTLocationTableViewCell()
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *selectFlag;


@end

@implementation NTLocationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _selectFlag = [[UIImageView alloc] init];
        [self addSubview:_selectFlag];
        [_selectFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.locationLabel.mas_trailing).offset(8);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(NTLocation *)item{
    
    _item = item;
    _locationLabel.text = item.locationName;
    _locationLabel.textColor = item.isSelected ? [UIColor colorWithRed:255.0/255.0 green:36.0/255.0 blue:98.0/255.0 alpha:1] : [UIColor blackColor] ;
    _selectFlag.hidden = !item.isSelected;
    _selectFlag.image = [UIImage imageNamed:[NSString stringWithFormat:@"NTLocation.bundle/image/address_selected"]];
}

@end
