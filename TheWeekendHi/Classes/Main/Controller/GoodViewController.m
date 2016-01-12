//
//  GoodViewController.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "GoodViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "GoodModel.h"
#import "ActivityViewController.h"

@interface GoodViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

{
    NSInteger _pageCount;//请求的页码
}
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,strong) UISegmentedControl *segmentedControl;


@end

@implementation GoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"排序",@"筛选"]];
    self.segmentedControl.frame = CGRectMake(0, 0, kScreenWidth, 44);
    self.segmentedControl.momentary = YES;
    [self.segmentedControl setEnabled:YES forSegmentAtIndex:1];
    [self.segmentedControl addTarget:self action:@selector(segmentTapAction:) forControlEvents:UIControlEventValueChanged];
    self.listArray = [NSMutableArray new];

    [self.view addSubview:self.segmentedControl];
    
    
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    [self showBackBtn];
    self.navigationItem.title = @"精选活动";
    
    [self loadData];
    
//    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];

    
    self.tableView.rowHeight = 90;
    [self.tableView launchRefreshing];
    
   }


- (void)segmentTapAction:(UISegmentedControl *)segment{
    
}

#pragma mark-----------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)self.listArray.count);
    
            
//        [self loadData];
        return self.listArray.count;
}
    



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     GoodTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GoodModel *model = self.listArray[indexPath.row];
    goodCell.model = model;
    return goodCell;
}

#pragma mark----------------UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodModel *model = self.listArray[indexPath.row];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ActivityVC"];
    //活动id
    activityVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];

    
}

#pragma mark----------PullingRefreshTableViewDelegate
//tableView下拉开始刷新的时候调用
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _pageCount = 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
}
//上拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _pageCount+=1;
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}



//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

#pragma mark --------------//加载数据
- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",kGoodActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        HWQLog(@"han = %@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        HWQLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            //下拉刷新的时候需要移除数组中元素
            if (self.refreshing) {
                if (self.listArray.count > 0) {
                    [self.listArray removeAllObjects];
                }
            }

            for (NSDictionary *acDic in acArray) {
                GoodModel *model = [[GoodModel alloc]initWithDictionary:acDic];
                [self.listArray addObject:model];
//                NSLog(@"list = %@",self.listArray);
            }
            
            //完成加载
            
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HWQLog(@"%@",error);
        
    }];

    }

#pragma mark---------scrollViewDid

//手指拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.tableView tableViewDidEndDragging:scrollView];
    
}

#pragma mark-------------LazyLoading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark-------------搜索方法
-(void)searchActivityAction:(UIButton *)btn{
    
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
