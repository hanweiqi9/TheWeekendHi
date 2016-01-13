//
//  MeViewController.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "MeViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"


@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *headImageBtn;
@property(nonatomic,strong) NSArray *imageArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) UILabel *label;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.navigationController.navigationBar.barTintColor = mainColor;
    
    
   
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除图片缓存",@"用户反馈",@"分享给好友",@" 给我评分",@" 当前版本",nil];
    self.imageArray = @[@"icon_shop",@"icon_user-1",@"icon_ac",@"pc_menu_collect_pressed_ic",@"umeng_example_socialize_action_icon"];
    [self setUpTableViewHeaderView];

}

#pragma mark------------Custom Method
-(void)setUpTableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    headerView.backgroundColor  = mainColor;
    
    [headerView addSubview:self.label];
    [headerView addSubview:self.headImageBtn];
    self.tableView.tableHeaderView = headerView;
}

-(void)sendEmail{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            
            picker.mailComposeDelegate = self;
            [picker setSubject:@"用户反馈"];
            //设置收件人
            NSArray *toRecipients = [NSArray arrayWithObjects:@"1072502398@qq.com", nil];
            [picker setToRecipients:toRecipients];
            
            //设置发送内容
            NSString *text = @"请留下你宝贵的意见";
            [picker setMessageBody:text isHTML:NO];
            
            [self presentViewController:picker animated:YES completion:nil];

        }else {
            HWQLog(@"您的设备尚未配置邮件账号");
        }
    }else{
        HWQLog(@"您的设备不支持邮件功能");
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            HWQLog(@"取消");
            break;
        case MFMailComposeResultSaved:
            HWQLog(@"保存");
            break;
        case MFMailComposeResultSent:
            HWQLog(@"发送邮件");
        case MFMailComposeResultFailed:
            HWQLog(@"发送邮件失败:%@...",error);
            break;
        default:
            break;
    }
}

-(void)checkAppVersion{
    [ProgressHUD showSuccess:@"当前已是最新版本..."];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次当页面将要出现的时候重新计算图片缓存大小
    //计算图片缓存
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存图片(%.02fM)",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark--------------UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text =self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewRowActionStyleDestructive;
    return cell;
    
}

#pragma mark--------------UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
         HWQLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            [imageCache cleanDisk];
        [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
        }
            break;
        case 1:{
            //发送邮件
            [self sendEmail];
        }
            
            break;
        case 2:
           
            break;
        case 3:
        {
            //评分
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
        {
            //检测当前版本
            [ProgressHUD show:@"正在为您检测..."];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            break;
        default:
            break;
    }
}

#pragma mark-------------懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-44) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }

    return _tableView;
}

- (UIButton *)headImageBtn{
    if (_headImageBtn == nil) {
        self.headImageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageBtn.frame=CGRectMake(30, 40, kScreenWidth/3, kScreenWidth/3);
        self.headImageBtn.layer.cornerRadius=kScreenWidth/6;
        self.headImageBtn.clipsToBounds=YES;
        [self.headImageBtn setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [self.headImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headImageBtn addTarget:self action:@selector(headImageBtnActivity) forControlEvents:UIControlEventTouchUpInside];
        self.headImageBtn.backgroundColor=[UIColor whiteColor];
    }
    return _headImageBtn;
}

- (UILabel *)label{
    if (_label == nil) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(180, 85, kScreenWidth-190, 40)];
        self.label.text = @"欢迎来到周末乐吧！";
        self.label.textColor = [UIColor whiteColor];
    }
    return _label;
}

- (void)headImageBtnActivity{
    
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
