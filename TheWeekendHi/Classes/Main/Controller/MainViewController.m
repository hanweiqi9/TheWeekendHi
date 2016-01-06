//
//  MainViewController.m
//  TheWeekendHi
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 芒果科技. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityViewController.h"
#import "ThemeViewController.h"
#import "ClassifyViewController.h"
#import "GoodViewController.h"
#import "HotViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property(nonatomic,strong) NSMutableArray *listArray;
//推荐活动数据
@property(nonatomic,strong) NSMutableArray *activityArray;
//推荐专题数据
@property(nonatomic,strong) NSMutableArray *themeArray;
@property(nonatomic,strong) NSMutableArray *adArray;
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self configTableViewHeaderView];
    
    
    //请求网络数据
    [self requestModel];
}

#pragma mark-------------UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
     return  self.themeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.mainModel = array[indexPath.row];
    

    return mainCell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityViewController *activityVC = [[ActivityViewController alloc] init];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
        
    }
}


#pragma mark-------------UITableViewDelegate

//分区的行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}

//自定义分区区头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 160, 5, 320, 16)];
       if (section == 0) {
           sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
    }else{
       sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    [view addSubview:sectionView];
    return view;

}
                                                                             
                                                                             

#pragma mark---------Custom Method

 //选择城市
-(void)selectCityAction:(UIBarButtonItem *)btn{
    SelectCityViewController *selectCity = [[SelectCityViewController alloc] init];
    [self presentViewController:selectCity animated:YES completion:nil];
    
}
//搜索页面
- (void)searchActivityAction:(UIButton *)btn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
    
    
}
//自定义tableView头部
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 343)];
        self.tableView.tableHeaderView = tableViewHeaderView;
    
    //添加轮播图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
    //整屏滑动
    self.scrollView.pagingEnabled = YES;
    //不显示水平方向滚动
    self.scrollView.showsHorizontalScrollIndicator = NO;
                                                                     
     //创建小圆点
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 156, kScreenWidth, 30)];
     //小圆点个数和颜色
    self.pageControl.numberOfPages = self.adArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    
   [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventEditingChanged];
    self.scrollView.contentSize = CGSizeMake(self.adArray.count *kScreenWidth, 186);
    for (int i = 0;i < self.adArray.count ; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i]] placeholderImage:nil];
        [self.scrollView addSubview:imageView];
    }
    [tableViewHeaderView addSubview:self.scrollView];

    //添加按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kScreenWidth / 4, 186, kScreenWidth / 4, kScreenWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d",i+1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
    }
    
    //精选活动/热门专题
    UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activityBtn.frame = CGRectMake(0, 186 +kScreenWidth / 4, kScreenWidth/2,343-186- kScreenWidth / 4);
    [activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
    [activityBtn addTarget:self action:@selector(goodActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:activityBtn];
    
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake(kScreenWidth/2, 186+kScreenWidth / 4, kScreenWidth/2,343-186- kScreenWidth / 4);
    [themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
    [themeBtn addTarget:self action:@selector(hotActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:themeBtn];
    [tableViewHeaderView addSubview:self.pageControl];

    
   
    
}
                                                                                                  
#pragma mark-------------首页轮播图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 //第一步：获取scrollView页面的宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
  //第二步：获取偏移量
    CGPoint offset = self.scrollView.contentOffset;
  //第三步：通过偏移量和页面宽度计算出当前页面
    NSInteger pageNumber = offset.x/pageWidth;
    self.pageControl.currentPage = pageNumber;
}

                                                                                                  
- (void)pageSelectAction:(UIPageControl *)pageControl{
    //第一步：获取pageControl点击的页面在第几页
    NSInteger pageNumber = pageControl.currentPage;
    //第二步：获取页面宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //让scrollView滚动到第几页
    self.scrollView.contentOffset = CGPointMake(pageNumber *pageWidth, 0);
}
- (void)requestModel{
    
    AFHTTPSessionManager *sessionManage = [AFHTTPSessionManager manager];
    sessionManage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManage GET:kMainDataList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        HWQLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HWQLog(@"%@",responseObject);
        
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            
            //刷新tableView数据
            [self.tableView reloadData];
            
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                [self.adArray addObject:dic[@"url"]];
            }
            
            //拿到数据之后重新刷新请求configTableViewHeaderView
            [self configTableViewHeaderView];
            NSString *cityName = dic[@"cityname"];
            
            //已请求回来的城市作为导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HWQLog(@"%@",error);
    }];
    
}

  //分类列表界面
- (void)mainActivityButtonAction:(UIButton *)btn{

    ClassifyViewController *classVC = [[ClassifyViewController alloc] init];
    [self.navigationController pushViewController:classVC animated:YES];
}
//精选活动
- (void)goodActivityButtonAction{
    GoodViewController *goodVC = [[GoodViewController alloc] init];
    [self.navigationController pushViewController:goodVC animated:YES];
}
//热门专题
- (void)hotActivityButtonAction{
    HotViewController *hotVC = [[HotViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}

    
#pragma mark------------懒加载，接收数据的数组
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}

- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return  _adArray;
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
