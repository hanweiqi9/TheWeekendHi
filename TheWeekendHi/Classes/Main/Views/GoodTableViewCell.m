//
//  GoodTableViewCell.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "GoodTableViewCell.h"
#import "GoodModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GoodTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;



@end

@implementation GoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 90);
}

- (void)setModel:(GoodModel *)model{
    
    NSLog(@"%@",model.title);
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.headImageView.layer.cornerRadius = 20;
    self.headImageView.clipsToBounds = YES;
    self.titleLabel.text = model.title;
    self.priceLabel.text = model.price;
    self.ageLabel.text = model.age;
    self.likeLabel.text = [NSString stringWithFormat:@"%@",model.counts];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
