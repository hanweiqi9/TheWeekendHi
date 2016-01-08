//
//  ActivityViewController.m
//  TheWeekendHi
//
//  活动详情

//  Created by scjy on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MBProgressHUD.h>
#import "ActivityView.h"

@interface ActivityViewController ()
{
    NSString *_phoneNumber;
    
}

@property (strong, nonatomic) IBOutlet ActivityView *activityView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动详情";
    [self showBackBtn];
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
        
    //去地图页面
    
    [self.activityView.mapBtn addTarget:self action:@selector(mapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //打电话
    [self.activityView.makeCallBtn addTarget:self action:@selector(makeCallBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self getModel];
}

//去地图页
- (void)mapBtnAction:(UIButton *)btn{
    
}

//大电话页面
- (void)makeCallBtnAction:(UIButton *)btn{
    //程序内打电话，打完之后不返回当前程序
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
    //程序外打电话，打完电话之后返回当前程序
    UIWebView *cellPhoneWebView = [[UIWebView alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];

    
    [cellPhoneWebView loadRequest:request];
    
}

#pragma mark-----------------CustomMethod

- (void)getModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kActivity,self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"]integerValue];
        if ([status isEqualToString:@"success"]&&code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityView.dataDic = successDic;
            _phoneNumber = dic[@"tel"];
            
            
            
            
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
