//
//  ThemeView.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ThemeView ()
{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
    //
    CGFloat _lastLabelBottom;
    
}

@property(nonatomic,strong) UIScrollView *mainScrollView;
@property(nonatomic,strong) UIImageView *headImageView;

@end

@implementation ThemeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headImageView];
}


//在set方法中赋值
-(void)setDataDic:(NSDictionary *)dataDic{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    
      [self drawContentWithArray:dataDic[@"content"]];
    HWQLog(@"%@",dataDic[@"content"]);
}

-(void)drawContentWithArray:(NSArray *)contentArray{
    
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithBigestSize:dic[@"description"] BigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 186) { //如果图片底部的高度没有值（也就是小于500）,也就说明是加载第一个lable，那么y的值不应该减去500
            y = 186 + _previousImageBottom - 186;
        } else {
            y = 186 + _previousImageBottom;
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
        _lastLabelBottom = label.bottom + 30;
    
        
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的底部高度+10
            _previousImageBottom = label.bottom + 15;
        } else {
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) { //有title的算上title的30像素
                            imgY = _previousImageBottom + label.height + 30 + 10;
                        } else {
                            imgY = _previousImageBottom + label.height + 10;
                        }
                    } else {
                        imgY = lastImgbottom + 15;
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
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, _lastLabelBottom + 300);

}


- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 10000);
        
    }
    return _mainScrollView;
}

- (UIImageView *)headImageView{
    
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
    }
    return _headImageView;
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
