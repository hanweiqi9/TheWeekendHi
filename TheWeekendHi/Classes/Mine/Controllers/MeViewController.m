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
#import "WeiboSDK.h"
#import "AppDelegate.h"



@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *headImageBtn;
@property(nonatomic,strong) NSArray *imageArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIView *shareView;
@property (nonatomic, strong) UISwitch *imageSwitch;
@property (nonatomic, strong) UISwitch *textSwitch;
@property (nonatomic, strong) UISwitch *mediaSwitch;




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

-(void)share{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-200, kScreenWidth, 350)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];
    
   
    
    [UIView animateWithDuration:1.0 animations:^{
        
        //微博
        UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weiboBtn.frame = CGRectMake(30, 40, 70, 70);
        [weiboBtn setImage:[UIImage imageNamed:@"sina_normal"] forState:UIControlStateNormal];
        [weiboBtn addTarget:self action:@selector(weiboActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:weiboBtn];
        //朋友圈
        UIButton *CircleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CircleBtn.frame = CGRectMake(155, 40, 70, 70);
        [CircleBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [CircleBtn addTarget:self action:@selector(circleActivity) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:CircleBtn];
        
        //微信朋友
        UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        friendBtn.frame = CGRectMake(270, 40, 70, 70);
        [friendBtn setImage:[UIImage imageNamed:@"wx_normal"] forState:UIControlStateNormal];
        [friendBtn addTarget:self action:@selector(friendActivity)  forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:friendBtn];
        
        //取消
        UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removeBtn.frame = CGRectMake(20, 150, kScreenWidth-40, 44);
        [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [removeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(last ) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:removeBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 75 , 44)];
        label.text = @"分享到";
        label.textAlignment = NSTextAlignmentCenter;
        [self.shareView addSubview:label];
    }];
}

-(void)last{
    [self.shareView removeFromSuperview];
}

//分享到微博
-(void)weiboActivity:(UIButton *)btn{
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURL;
    authRequest.scope = @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"MeViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    [self.shareView removeFromSuperview];

}

- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);
    

    
    return message;

}
//分享微信好友
-(void)friendActivity{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.text = @"这是测试发送内容";
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}
//分享到朋友圈
- (void)circleActivity{
    
    
}

#pragma mark--------------WeiboSDKDelegate

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
        {
            //分享
            [self share];
        }
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
