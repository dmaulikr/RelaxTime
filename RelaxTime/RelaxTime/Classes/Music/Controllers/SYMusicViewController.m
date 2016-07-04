//
//  SYMusicViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMusicViewController.h"
#import "SYReadCommentCell.h"
#import "SYReadCommentModel.h"

@interface SYMusicViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//获取的音乐 数字数组
@property(nonatomic,copy) NSArray * musicArray;

//当前请求的音乐Id
@property(nonatomic,copy) NSString* currentMusicID;

//评论数据源
@property(nonatomic,strong) NSMutableArray* dataCommentArray;

//评论数量
@property(nonatomic,assign) NSInteger count;

@end

@implementation SYMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
    
    [SVProgressHUD show];
    
    [self getMusicArray];
}

#pragma mark - 懒加载
-(NSMutableArray *)dataCommentArray{
    if (!_dataCommentArray) {
        
        _dataCommentArray = [NSMutableArray array];
    }
    
    return _dataCommentArray;
}

#pragma mark - 创建UI
-(void)creatUI{
    
    //设置滑条和tableView的偏移量
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SYReadCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.estimatedRowHeight = 10;
    
    //开始隐藏tableView
    self.tableView.hidden = YES;
    
    //加刷新尾巴
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        //取出评论模型的id
        SYReadCommentModel *model = self.dataCommentArray.lastObject;
        //请求多余评论数据
        [self getMusicCommentWithID:self.currentMusicID andUserId:model._id];
        
    }];
}


#pragma mark - 获取歌单 并请求第一次的数据
-(void)getMusicArray{
    
    __weak typeof(self) weakSelf = self;
    
    [self.requestManager GET:Music_first_URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //获取音乐数组
        _musicArray = responseObject[@"data"];
        //  NSLog(@"%@",self.musicArray);
        
        //根据音乐数组中数字请求详细参数 第一次请求第一个
        weakSelf.currentMusicID = _musicArray[0];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf getMusicWithID:weakSelf.currentMusicID];
            
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

#pragma mark - 以Id请求歌曲数据
-(void)getMusicWithID:(NSString *)ID{
    
    //请求音乐详细数据
    //详情地址
    NSString *detailUrl = [Music_detail_URL stringByAppendingString:ID];
    
    
    [self.requestManager GET:detailUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // NSLog(@"%@",responseObject);
        
        //显示tableView
        self.tableView.hidden = NO;
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SYLog(@"请求失败");
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    
    //第一次请求评论数据
    [self getMusicCommentWithID:ID andUserId:[NSString stringWithFormat:@"%d",0]];
    
}


#pragma mark - 以Id请求歌曲评论
-(void)getMusicCommentWithID:(NSString *) ID andUserId:(NSString *)userId{
    
    //拼接url
    NSString *url = [Music_comment_URL stringByAppendingFormat:@"%@/%@", ID, userId];
    
    [self.requestManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //取出评论字典的数组
        NSArray *arr = responseObject[@"data"][@"data"];
        //取出评论数量
        self.count = [responseObject[@"data"][@"count"] integerValue];
        
        //如果userID为0，清除数组元素
        if ([userId isEqualToString:@"0"]) {
             [self.dataCommentArray removeAllObjects];
        }
        
        //转成模型数组存入数据源
        [self.dataCommentArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYReadCommentModel class] json:arr]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
           
            //判断是否没有更多更多数据
            [self checkOutNoMoreData];
        });
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评论请求失败"];
    }];
    
}

#pragma mark - 判断是否没有更多更多数据
-(void)checkOutNoMoreData{
    //判断是否刷新完数据 显示没有更多
    if (self.count <= self.dataCommentArray.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - tableView代理方法
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataCommentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYReadCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataCommentArray[indexPath.row];
    
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
