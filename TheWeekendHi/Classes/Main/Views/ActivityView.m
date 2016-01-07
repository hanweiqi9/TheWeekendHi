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
{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
    //
    CGFloat _previousImageHeight;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation ActivityView

-(void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 5000);
}

//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    
    //活动图片
    NSArray *urls = dataDic[@"urls"];
    NSString *str = urls[0];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    //活动标题
    self.activityTitleLabel.text = dataDic[@"title"];
    //活动人
    self.favouriteLabel.text = [NSString stringWithFormat:@"%@人已收藏",dataDic[@"fav"]];
    //参考价格
    self.priceLabel.text = [NSString stringWithFormat:@"价格参考：%@",dataDic[@"pricedesc"]] ;
    //活动地址
    self.addressLabel.text = dataDic[@"address"];
    //活动电话
    self.phoneLabel.text = dataDic[@"tel"];
    //活动起止时间
    NSString *startTime = [HWTools getDateFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWTools getDateFromString:dataDic[@"new_end_date"]];
    self.timeLabel.text = [NSString stringWithFormat:@"正在进行：%@-%@",startTime,endTime];
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
    
    
    
    
    
}

-(void)drawContentWithArray:(NSArray *)contentArray{
    
    for (NSDictionary *dic in contentArray) {
        
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithBigestSize:dic[@"description"] BigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 430) {
            //如果图片底部高度没有值（也就是小于430），也就是说明加载第一个label，那么y的值不应该减去430
            y = 430+_previousImageBottom-430;
        }else{
            y = 430+_previousImageBottom;
        }
        
        //如果标题存在,标题的高度应该是上次图片底部的高度
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kScreenWidth-20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该加30，也就是标题的高度
            y += 30;
            
        }

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, y, kScreenWidth-20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        
        
        
        NSArray *urlArray = dic[@"urls"];
        if (urlArray == nil) {
            //当某一段落没有图片时，上次图片的高度用上次label的底部高度加10
            _previousImageBottom = label.bottom+10;
        }else{
            for (NSDictionary *urlDic in urlArray) {
                CGFloat width = [urlDic[@"width"]integerValue];
                CGFloat imageHeight = [urlDic[@"height"]integerValue];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, label.bottom, kScreenWidth-20, (kScreenWidth-20)/width *imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _previousImageBottom = imageView.bottom;
                
            }
            
        }
        
    }
    
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
*/

@end
