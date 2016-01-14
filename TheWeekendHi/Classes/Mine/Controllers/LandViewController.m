//
//  LandViewController.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "LandViewController.h"

@interface LandViewController ()



@end

@implementation LandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showBackBtn];
    
    self.title = @"登陆";
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

- (IBAction)landBtn:(id)sender {
}
@end
