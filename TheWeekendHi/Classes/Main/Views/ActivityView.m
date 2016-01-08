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
    CGFloat _lastLabelBottom;
    CGFloat _hintLabelHeight;
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
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 6000);
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
    
    self.str = dataDic[@"reminder"];
   
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
    
    
     self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, _lastLabelBottom +_hintLabelHeight);
    
}

-(void)drawContentWithArray:(NSArray *)contentArray{
    
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithBigestSize:dic[@"description"] BigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 430) { //如果图片底部的高度没有值（也就是小于500）,也就说明是加载第一个lable，那么y的值不应该减去500
            y = 430 + _previousImageBottom - 430;
        } else {
            y = 430 + _previousImageBottom;
        }
        NSString *title = dic[@"title"];
        if (title != nil) {
            //如果标题存在,标题的高度应该是上次图片的底部高度
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        //保留最后一个label的高度，+ 64是下边tabbar的高度
        _lastLabelBottom = label.bottom + 10 + 64;
        
        
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的底部高度+10
            _previousImageBottom = label.bottom + 10;
        } else {
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) { //有title的算上title的30像素
                            imgY = _previousImageBottom + label.height + 30 + 5;
                        } else {
                            imgY = _previousImageBottom + label.height + 5;
                        }
                    } else {
                        imgY = lastImgbottom + 10;
                    }
                    
                } else {
                    //单张图片的情况
                    imgY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imgY, kScreenWidth - 20, (kScreenWidth - 20)/width * imageHeight)];
                imageView.backgroundColor = [UIColor redColor];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _previousImageBottom = imageView.bottom + 5;
                if (urlsArray.count > 1) {
                    lastImgbottom = imageView.bottom;

                }
            }
        }
    }
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, _lastLabelBottom-_hintLabelHeight-50, kScreenWidth - 70, 30)];
    hintLabel.text = @"温馨提示";
    hintLabel.font = [UIFont systemFontOfSize:15.0];
    [self.mainScrollView addSubview:hintLabel];
    
    _hintLabelHeight = [HWTools getTextHeightWithBigestSize:self.str BigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
    
    UILabel *htLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _lastLabelBottom, kScreenWidth - 20, _hintLabelHeight)];
    htLabel.text = self.str;
    htLabel.numberOfLines = 0;
    htLabel.font = [UIFont systemFontOfSize:15.0];
    [self.mainScrollView addSubview:htLabel];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, _lastLabelBottom-48, 20, 25)];
    image.image = [UIImage imageNamed:@"list_like_heart"];
    [self.mainScrollView addSubview:image];
    
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
*/

@end
