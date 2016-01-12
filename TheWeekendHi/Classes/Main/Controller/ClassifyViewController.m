//
//  ClassifyViewController.m
//  TheWeekendHi
//

//  分类列表
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "ClassifyViewController.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityViewController.h"
#import "GoodTableViewCell.h"
#import "GoodModel.h"
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"


@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

{
    NSInteger _pageCount;
}

@property(nonatomic,strong) VOSegmentedControl *segmentControl;
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic,strong) PullingRefreshTableView *tableView;
//用来显示数据的数组
@property(nonatomic,strong) NSMutableArray *showDataArray;
@property(nonatomic,strong) NSMutableArray *showArray;
@property(nonatomic,strong) NSMutableArray *touristArray;
@property(nonatomic,strong) NSMutableArray *studyArray;
@property(nonatomic,strong) NSMutableArray *familyArray;



@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBackBtn];
    self.title  = @"分类列表";
    self.showDataArray = [NSMutableArray new];

    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 90;
    _pageCount = 1;
    
    //第一次进入分类列表中，请求全部数据接口
    //根据上一页选择按钮，显示第几页数据
      [self showPreviousSelectBtn];
    
    [self.tableView launchRefreshing];
    [self chooseRequest];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [ProgressHUD dismiss];
}

#pragma mark-----------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.showDataArray.count;
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GoodModel *model = self.showDataArray[indexPath.row];
    goodCell.model = model;
    return goodCell;
    
   }


#pragma mark----------------UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodModel *model = self.showDataArray[indexPath.row];
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
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
   }
//上拉
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _pageCount+=1;
    
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
    
    }



//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
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


- (void)getShowRequest{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"正在加载中..."];
    //typeid=6时
    [sessionManager GET:[NSString stringWithFormat: @"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD show:@"加载完成"];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *acDic in acArray) {
                GoodModel *model = [[GoodModel alloc]initWithDictionary:acDic];
                [self.showArray addObject:model];
//                NSLog(@"show = %@",self.showArray);
            }
            [self.tableView reloadData];
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            
        }

        [self showPreviousSelectBtn];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
   }
-(void)getTouristRequest{
     AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    //typeid=23景点场所
    [ProgressHUD show:@"正在加载中..."];
    [sessionManager GET:[NSString stringWithFormat: @"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            
            for (NSDictionary *acDic in acArray) {
                GoodModel *model = [[GoodModel alloc]initWithDictionary:acDic];
                [self.touristArray addObject:model];
            }
            [self.tableView reloadData];
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
          
        }
        [self showPreviousSelectBtn];


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];

    }];
}
-(void)getStudyRequest{
     AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    //typeid=22学习益智
    [ProgressHUD show:@"正在加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }

            for (NSDictionary *acDic in acArray) {
                GoodModel *model = [[GoodModel alloc]initWithDictionary:acDic];
                [self.studyArray addObject:model];
                
            }
            [self.tableView reloadData];
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
        }
        [self showPreviousSelectBtn];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];

    }];
    

}
-(void)getFamilyRequest{
       //typeid=21亲子旅游
     AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [ProgressHUD show:@"正在加载中..."];
    [sessionManager GET:[NSString stringWithFormat: @"%@&page=%ld&typeid=%@",kClassify,_pageCount,@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            if (self.refreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }

            for (NSDictionary *acDic in acArray) {
                GoodModel *model = [[GoodModel alloc]initWithDictionary:acDic];
                [self.familyArray addObject:model];
            }
            [self.tableView reloadData];
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;

        }
        [self showPreviousSelectBtn];

     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];

    }];

}

#pragma mark--------------CustomMethod

- (void)showPreviousSelectBtn{
    if (self.refreshing) {//下拉显示原来数据
        if (self.showDataArray.count > 0) {
            [self.showDataArray removeAllObjects];
        }

    }
        switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark-------------LazyLoading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-64 - 40) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 90;
    }
    return _tableView;
}

- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

-(NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}

- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}

- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}

#pragma mark   -------------    VOSegmentedControl
- (VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"}]];
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segmentControl.selectedBackgroundColor = self.segmentControl.backgroundColor;
        self.segmentControl.allowNoSelection = NO;
        self.segmentControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.segmentControl.indicatorThickness = 4;
        self.segmentControl.selectedSegmentIndex = self.classifyListType-1;

        //返回点击的那个按钮
        //返回点击的是哪个按钮
        
        [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"1: block --> %@", @(index));
        }];
        [self.segmentControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (void)segmentCtrlValuechange:(VOSegmentedControl *)segmentControl{
    
//    [self showPreviousSelectBtn];
    self.classifyListType = segmentControl.selectedSegmentIndex + 1;
    [self chooseRequest];
    
}

- (void)chooseRequest{
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudyRequest];
            break;
        case ClassifyListTypeFamilyTravel:
            [self getFamilyRequest];
            break;
        default:
            break;
    }
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
