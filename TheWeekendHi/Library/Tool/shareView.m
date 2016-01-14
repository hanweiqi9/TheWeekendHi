//
//  shareView.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "shareView.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WXApi.h"

@interface shareView ()<WeiboSDKDelegate,WXApiDelegate>
@property(nonatomic,strong) UIView *shareView;
@property(nonatomic,strong) UIView *grayView;


@end

@implementation shareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.grayView.backgroundColor = [UIColor blackColor];
    self.grayView.alpha = 0.5;
    [window addSubview:self.grayView];
    
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-200, kScreenWidth, 350)];
    self.shareView.backgroundColor = [UIColor colorWithRed:234/255.0 green:243/255.0 blue:246/255.0 alpha:1.0];
    [window addSubview:self.shareView];
    
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(30, 40, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"sina_normal"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboActivity:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 85, 100, 44)];
    weiboLabel.text = @"新浪微博";
    weiboLabel.font = [UIFont systemFontOfSize:13.0f];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weiboLabel];
    [self.shareView addSubview:weiboBtn];
    
    //微信朋友
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(155, 40, 70, 70);
    [friendBtn setImage:[UIImage imageNamed:@"wx_normal"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendActivity)  forControlEvents:UIControlEventTouchUpInside];
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 85, 100, 44)];
    friendLabel.text = @"微信好友";
    friendLabel.font = [UIFont systemFontOfSize:13.0f];
    friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:friendLabel];
    [self.shareView addSubview:friendBtn];
    //朋友圈
    UIButton *CircleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CircleBtn.frame = CGRectMake(270, 40, 70, 70);
    [CircleBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [CircleBtn addTarget:self action:@selector(circleActivity) forControlEvents:UIControlEventTouchUpInside];
    UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 85, 100, 44)];
    circleLabel.text = @"微信朋友圈";
    circleLabel.font = [UIFont systemFontOfSize:13.0f];
    circleLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:circleLabel];
    [self.shareView addSubview:CircleBtn];
    
    
    
    //取消
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(0, 180, kScreenWidth, 40);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(last ) forControlEvents:UIControlEventTouchUpInside];
    removeBtn.backgroundColor = [UIColor whiteColor];
    [self.shareView addSubview:removeBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 75 , 44)];
    label.text = @"分享到";
    label.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:label];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareView.frame = CGRectMake(0, kScreenHeight-250, kScreenWidth, 350);
    }];
    
}

-(void)last{
    [self.shareView removeFromSuperview];
    [self.grayView removeFromSuperview];
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
    [self last];
}

- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = NSLocalizedString(@"不完美", nil);
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"1" ofType:@".jpg"]];
    message.imageObject = image;
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
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@".jpg"];

    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);

    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];

    
}

#pragma mark--------------WeiboSDKDelegate
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
    
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
