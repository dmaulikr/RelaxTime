//
//  SYMovieDetailController.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/6.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMovieDetailController.h"
#import "SYReadCommentCell.h"
#import "SYReadCommentModel.h"
#import "SYMovieDetailModel.h"
#import "SYMovieStoryModel.h"
#import "SYMovieContentView.h"
#import "SYPlayViewController.h"
#import "ZFPlayerView.h"

@interface SYMovieDetailController ()<UITableViewDataSource,UITableViewDelegate,SYMovieContentViewDelegate>





@property (weak, nonatomic) IBOutlet UITableView *tableView;

//tableHeadView
@property(nonatomic ,strong) SYMovieContentView * contentView;

//电影详情模型
@property(nonatomic ,strong) SYMovieDetailModel * detailModel;
//电影评论数组
@property(nonatomic ,strong) NSMutableArray * commentArray;
//故事模型
@property(nonatomic ,strong) SYMovieStoryModel * storyModel;

//当前评论id
@property(nonatomic ,copy) NSString * commentId;

//评论数量
@property(nonatomic ,assign) NSInteger count;


@end

@implementation SYMovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化当前评论Id
    self.commentId = @"0";
    
    [self creatUI];
    //请求数据
    [self requestoneMovieCommentData:self.movieId page:self.commentId];
    [self requestMovieData:self.movieId];
    [self requestoneStoryData:self.movieId];
    
    [SVProgressHUD show];
    
}

#pragma mark - UI设置
-(void)creatUI{
    
    
    self.title = self.movieTitle;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SYReadCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.estimatedRowHeight = 10;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    //设置滑条和tableView的偏移量
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
      
        [weakSelf requestoneMovieCommentData:self.movieId page:self.commentId];
    }];
    self.tableView.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - 懒加载
-(NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

-(SYMovieContentView *)contentView{
    if (!_contentView) {
        
        _contentView = [[[NSBundle mainBundle]loadNibNamed:@"SYMovieContentView" owner:nil options:nil]lastObject];
        
        self.tableView.tableHeaderView = _contentView;
        
        _contentView.delegate = self;
    }
    return _contentView;
}



#pragma mark - 播放视频
-(void)SYMovieContentViewPlayButtonClick{
    
    SYPlayViewController *playerVC = [[SYPlayViewController alloc] init];
    playerVC.videoString = self.detailModel.video;
    
    [self.navigationController pushViewController:playerVC animated:YES];
    
}

#pragma mark - 请求电影详情数据
- (void) requestMovieData:(NSString *) movieId{
    
    NSString *requestStr = [NSString stringWithFormat:Movie_detail_URL, movieId];
    
    __weak typeof(self) weakSelf = self;
    [self.requestManager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        weakSelf.detailModel = [SYMovieDetailModel yy_modelWithDictionary:responseObject[@"data"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //给contentView显示
            [weakSelf.contentView showMessageWithDetaiModel:weakSelf.detailModel];
           
            weakSelf.tableView.hidden = NO;
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        });
    }];
    
    
}

#pragma mark - 请求一个故事数据
- (void) requestoneStoryData:(NSString *) movieId{
    
    NSString *requestStr = [NSString stringWithFormat:Movie_StoryFirst_URL, movieId];
    
    __weak typeof(self) weakSelf = self;
    [self.requestManager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        NSDictionary *modelDict = [responseObject[@"data"][@"data"] firstObject];
        weakSelf.storyModel = [SYMovieStoryModel yy_modelWithDictionary:modelDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //给contentView显示
            [weakSelf.contentView showMessageWithStoryModel:weakSelf.storyModel];
            [weakSelf.tableView reloadData];
            // weakSelf.tableView.hidden = NO;
            
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
           // [SVProgressHUD showErrorWithStatus:@"电影故事加载失败"];
        });
        
    }];
    
}

#pragma mark - 请求电影评论数据
- (void) requestoneMovieCommentData:(NSString *) movieId page:(NSString *) page{
    
    NSString *requestStr = [NSString stringWithFormat:Movie_comment_URL, movieId, page];
    
    __weak typeof(self) weakSelf = self;
    [self.requestManager GET:requestStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *commnetArray = [NSArray yy_modelArrayWithClass:[SYReadCommentModel class] json:responseObject[@"data"][@"data"]];
        //评论数量
        weakSelf.count = [responseObject[@"data"][@"count"]integerValue];
        //下一次评论id
        weakSelf.commentId = [commnetArray.lastObject _id];
        
        [weakSelf.commentArray addObjectsFromArray:commnetArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            weakSelf.tableView.mj_footer.hidden = NO;
            
           [weakSelf.tableView reloadData];
            //判断是否刷新完数据 显示没有更多
            if (weakSelf.count <= weakSelf.commentArray.count) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showErrorWithStatus:@"评论加载失败"];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        });
        
    }];
    
}


#pragma mark - tableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SYReadCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.commentArray[indexPath.row];
    
    return cell;
}
//设置sectionheader  评论标题头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, 0, 20);
    label.text = [NSString stringWithFormat:@"  评论 共%zd条", self.count];
    
    label.textColor = GlobalColorBLUE;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = GlobalColor238;
    
    return label;
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //清楚图片在内存中的缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
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
