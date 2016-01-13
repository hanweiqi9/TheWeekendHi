//
//  FineViewController.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "FineViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "DiscoverModel.h"
#import "ActivityViewController.h"


@interface FineViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>


@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *allLikeArray;
@property(nonatomic,assign) BOOL refreshing;


@end

@implementation FineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    self.allLikeArray = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationController.navigationBar.barTintColor = mainColor;
    [self loadDate];
    [self.tableView launchRefreshing];
    
}

#pragma mark-------------获取接口
-(void)loadDate{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"正在加载中..."];
    [sessionManager GET:kDiscover parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载已完成"];
        NSDictionary *requestDic = responseObject;
        NSString *status = requestDic[@"status"];
        NSInteger code = [requestDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"]&& code == 0) {
            NSDictionary *dic = requestDic[@"success"];
            NSArray *likeArray = dic[@"like"];
            for (NSDictionary *dict in likeArray) {
                DiscoverModel *model = [[DiscoverModel alloc]initWithDictionary:dict];
                [self.allLikeArray addObject:model];
            }
            [self.tableView reloadData];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
    
    
    
}

#pragma mark-------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allLikeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableViewCell *disCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    DiscoverModel *model = self.allLikeArray[indexPath.row];
    disCell.model = model;
    
    return disCell;
}

#pragma mark-------------UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityVC"];
    DiscoverModel *model  = self.allLikeArray[indexPath.row];
    //活动id
    activityVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
    
    
    
    
}

#pragma mark---------------PullingRefreshTableViewDelegate

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadDate) withObject:nil afterDelay:1.0];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

//手指拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.tableView tableViewDidEndDragging:scrollView];
}

    
#pragma mark ---------- 懒加载
 

- (PullingRefreshTableView *)tableView{
        if (_tableView == nil) {
            self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) pullingDelegate:self];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.rowHeight = 90;
            self.tableView.separatorColor = [UIColor grayColor];
        }
        return _tableView;
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
