//
//  ActivityView.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ActivityView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation ActivityView

-(void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
}

//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityTitleLabel.text = dataDic[@"title"];
    self.favouriteLabel.text = [NSString stringWithFormat:@"%@人已收藏",dataDic[@"fav"]];
    self.priceLabel.text = [NSString stringWithFormat:@"价格参考：%@",dataDic[@"pricedesc"]] ;
    self.addressLabel.text = dataDic[@"address"];
    self.phoneLabel.text = dataDic[@"tel"];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
