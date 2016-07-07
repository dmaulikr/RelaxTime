//
//  SYMovieViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMovieViewController.h"
#import "SYMovieListCell.h"
#import "SYMovieListModel.h"
#import "SYMovieDetailController.h"

@interface SYMovieViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic ,strong) UITableView * tableView;

//电影的id
@property (nonatomic, copy) NSString *movieId;

@end

NSString *const movieListCellIdentifer = @"movieListCell";

@implementation SYMovieViewController

#pragma mark - 懒加载


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GlobalColor238;
    
    [self setupTableView];
  
    self.navigationItem.rightBarButtonItem = nil;
    
    [self requestMovieData:self.movieId];
    
}


#pragma mark - 初始化tableView
- (void) setupTableView {
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYMovieListCell class]) bundle:nil] forCellReuseIdentifier:movieListCellIdentifer];
    
    // 设置tableView的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置滑条和tableView的偏移量
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.tableView.rowHeight = 145;
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.movieId = @"0";
       
        [weakSelf requestMovieData:self.movieId];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestMovieData:self.movieId];
    }];
    
    // 显示指示器
    [SVProgressHUD show];
  
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    

    self.movieId = @"0";
    
}



#pragma mark - 请求数据
- (void)requestMovieData:(NSString *) movieId{
    
    NSString *requestStr = [Movie_URL stringByAppendingString:movieId];
    
    __weak typeof(self) weakSelf = self;
    [self.requestManager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       // NSLog(@"%@",responseObject);
        
        [SVProgressHUD dismiss];
        NSArray *array = [NSArray yy_modelArrayWithClass:[SYMovieListModel class] json:responseObject[@"data"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (array.count == 0) {
                
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            if ([weakSelf.tableView.mj_header isRefreshing]) {
                 [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:array];
            weakSelf.movieId = [array.lastObject movieId];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            
        });
        
    }];
    
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    tableView.mj_footer.hidden = self.dataArray.count ? NO : YES;
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYMovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:movieListCellIdentifer forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}



//停止拖动清理图片在内存中的缓存
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
      [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYMovieDetailController *movieDetail = [[SYMovieDetailController alloc] init];
    movieDetail.movieId = [self.dataArray[indexPath.row] movieId];
    
    movieDetail.movieTitle = [self.dataArray[indexPath.row] title];
    movieDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:movieDetail animated:YES];
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
