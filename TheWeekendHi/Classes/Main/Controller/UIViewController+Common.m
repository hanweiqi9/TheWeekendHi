//
//  UIViewController+Common.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "UIViewController+Common.h"
#import "SearchViewController.h"

@implementation UIViewController (Common)

//导航栏添加返回按钮
- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;

}
//搜索按钮
-(void)searchBtn{
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

//右按钮
-(void)rightBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"btn_keep"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twoBtn.frame = CGRectMake(40, 0, 20, 20);
    [twoBtn setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [twoBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightTwoBtn = [[UIBarButtonItem alloc] initWithCustomView:twoBtn];
    NSArray *rightBtns = @[rightTwoBtn,rightBtn];
    self.navigationItem.rightBarButtonItems = rightBtns;
    

}

- (void)searchRightBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twoBtn.frame = CGRectMake(40, 0, 20, 20);
    [twoBtn setImage:[UIImage imageNamed:@"btn_screening"] forState:UIControlStateNormal];
    [twoBtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightTwoBtn = [[UIBarButtonItem alloc] initWithCustomView:twoBtn];
    NSArray *rightBtns = @[rightTwoBtn,rightBtn];
    self.navigationItem.rightBarButtonItems = rightBtns;
    

}

- (void)backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchActivityAction:(UIButton *)btn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];

}

#pragma mark----------//喜欢按钮方法
- (void)likeBtn{
    
}
#pragma mark----------//分享按钮方法
- (void)shareBtn{
    
}

@end
