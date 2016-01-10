//
//  HotTableViewCell.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HotTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;


@end

@implementation HotTableViewCell


- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setModel:(HotModel *)model{
    
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
