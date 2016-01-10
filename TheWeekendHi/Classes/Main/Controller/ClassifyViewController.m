//
//  ClassifyViewController.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ClassifyViewController.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityViewController.h"
#import "GoodTableViewCell.h"
#import "GoodModel.h"


@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

{
    NSInteger _pageCount;
}

@property(nonatomic,strong) UISegmentedControl *segmentControl;
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *listArray;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBackBtn];
    
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"演出剧目",@"景点场馆",@"学习益智",@"亲子旅游"]];
    self.segmentControl.frame = CGRectMake(0, 0, kScreenWidth, 44);
    [self.segmentControl addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    
    self.tableView.rowHeight = 90;
    [self.tableView launchRefreshing];
    
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
//tableView上拉开始刷新的时候调用
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _pageCount = 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
}
//下拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
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
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",kShowProgram,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        HWQLog(@"han = %@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        HWQLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        self.listArray = [NSMutableArray new];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            
            for (NSDictionary *acDic in acArray) {
                GoodModel *model = [[GoodModel alloc]initWithDictionary:acDic];
                [self.listArray addObject:model];
                NSLog(@"list = %@",self.listArray);
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








- (void)segmentAction{
    
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
