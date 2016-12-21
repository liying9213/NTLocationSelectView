//
//  NTLocationTableViewCell.h
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/19.
//  Copyright © 2016年 liying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTLocation.h"

@interface NTLocationTableViewCell : UITableViewCell

@property (nonatomic,strong) NTLocation * item;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
