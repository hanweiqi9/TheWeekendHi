//
//  LoginViewController.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBar.barTintColor = mainColor;
    [self showBackBtn];
}
- (void)backBtn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//添加
- (IBAction)add:(id)sender {
    BmobObject *user = [BmobObject objectWithClassName:@"MemberUser"];
    [user setObject:@"练晓俊" forKey:@"user_Name"];
    [user setObject:@18 forKey:@"user_Age"];
    [user setObject:@"女" forKey:@"user_Gender"];
    [user setObject:@"18860233161" forKey:@"user_callNumber"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        HWQLog(@"恭喜注册成功");
    }];
    
}
//删除
- (IBAction)delete:(id)sender {
    
    BmobQuery *user = [BmobQuery queryWithClassName:@"MemberUser"];
    [user getObjectInBackgroundWithId:@"cceb9edf0b" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
        }
    }];
    
   }
//获取
- (IBAction)query:(id)sender {
    //查找GameScore表里面id为0c6db13c的数据
    BmobQuery   *user = [BmobQuery queryWithClassName:@"MemberUser"];
    [user getObjectInBackgroundWithId:@"74e04f6087" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *name= [object objectForKey:@"user_Name"];
                 NSString *number= [object objectForKey:@"user_callNumber"];
                HWQLog(@"%@%@",name,number);
            }
        }
    }];

}

//修改
- (IBAction)change:(id)sender {
    
    BmobQuery   *user = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [user getObjectInBackgroundWithId:@"74e04f6087" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:@"郭亚茹" forKey:@"user_Name"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
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
