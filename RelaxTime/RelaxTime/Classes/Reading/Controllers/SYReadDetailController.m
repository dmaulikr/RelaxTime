//
//  SYReadDetailController.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadDetailController.h"
#import "SYReadCommentModel.h"
#import "SYReadCommentCell.h"
#import "SYReadContentView.h"
#import "SYReadQuesModel.h"
#import "SYReadEssayModel.h"
#import "SYReadSeriesModel.h"

@interface SYReadDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    //评论条数
    UILabel *_label;
}

//内容URL
@property(nonatomic ,copy) NSString * contentURL;

//评论URL
@property(nonatomic ,copy) NSString * commentURL;

//内容数据
@property(nonatomic ,strong) id  dataContent;

//评论数据源
@property(nonatomic ,strong) NSMutableArray * dataCommentArray;

//评论数量
@property(nonatomic ,assign) NSInteger count;

//显示评论的tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//显示内容的view
@property(nonatomic ,strong) SYReadContentView * contentView;
//喜欢按钮
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

//评论的sectionView
@property(nonatomic ,strong) UIView * sectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;

@property(nonatomic ,assign) CGFloat beforeY;

@end

@implementation SYReadDetailController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.contentInset  = UIEdgeInsetsMake(64, 0, 49, 0);
    //模糊高度 自适应
    self.tableView.estimatedRowHeight = 10;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SYReadCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.hidden = YES;
    //设置UI属性 处理url
    [self setUI_dealURl];
    //展示数据
    [self showData];
    [SVProgressHUD show];
    
 
   
}

#pragma mark - 按钮点击事件
- (IBAction)likeBtn:(id)sender {
    self.likeBtn.selected = !self.likeBtn.selected;
}

- (IBAction)backToTop:(id)sender {
    
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}
- (IBAction)share:(id)sender {
   
   
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault];
    [UMSocialData defaultData].extConfig.title = @"这边文章不错,去[闲Time]看看吧";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAppKey
                                      shareText:self.contentView.titlelabel.text
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ]
                                       delegate:self];
    

}

#pragma mark - 懒加载
-(NSMutableArray *)dataCommentArray{
    
    if (!_dataCommentArray) {
        _dataCommentArray = [NSMutableArray array];
    }
    return _dataCommentArray;
}


-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[[NSBundle mainBundle]loadNibNamed:@"SYReadContentView" owner:nil options:nil]lastObject];
    }
    return _contentView;
}


#pragma mark - 设置UI 处理URl
-(void)setUI_dealURl{
    //判断那种类型 显示不同的数据
    switch (self.type) {
        case 1:
            self.navigationItem.title = @"短文";
            
            //内容URL
            self.contentURL = [Read_detailContent_URL stringByAppendingFormat:@"%@/%@",@"essay",self.itemID];
          
             //评论URL
            self.commentURL = [Read_detail_comment_URL stringByAppendingFormat:@"%@/%@/",@"essay",self.itemID];
            //创建相应的的数据模型
            self.dataContent = [[SYReadEssayModel alloc]init];
            
            break;
        case 2:
            self.navigationItem.title = @"连载";
            self.contentURL = [Read_detailContent_URL stringByAppendingFormat:@"%@/%@",@"serialcontent",self.itemID];
            self.commentURL = [Read_detail_comment_URL stringByAppendingFormat:@"%@/%@/",@"serial",self.itemID];
            
             self.dataContent = [[SYReadSeriesModel alloc]init];
            break;
        case 3:
            self.navigationItem.title = @"问题";
           
            self.contentURL = [Read_detailContent_URL stringByAppendingFormat:@"%@/%@",@"question",self.itemID];
            self.commentURL = [Read_detail_comment_URL stringByAppendingFormat:@"%@/%@/",@"question",self.itemID];
              self.dataContent = [[SYReadQuesModel alloc]init];
            break;
        default:
            break;
    }
    
    
    //添加刷新尾
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //取出评论模型的id
        SYReadCommentModel *model = self.dataCommentArray.lastObject;
        //请求多余评论数据
        [self getcommentDataWithID: model._id];
    }];
    

    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0);
    //NSLog(@"内容 %@", self.contentURL);
    //NSLog(@"评论 %@",self.commentURL);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.tableView addGestureRecognizer:tap];
    
}

#pragma mark - 手势
-(void)tap{
    //SYLogFunc;
    self.bottomViewConstraint.constant = self.bottomViewConstraint.constant == 0 ? -49 : 0;
   
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomView layoutIfNeeded];
    
    }];
}

#pragma mark - 数据请求
-(void)showData{
    //请求内容数据
    [self getContentData];
    //请求评论数据
    [self getcommentDataWithID:[NSString stringWithFormat:@"%d",0]];
    
}

#pragma mark -请求内容数据
-(void)getContentData{
    
    [self.requestManager GET:self.contentURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
     
        //处理内容数据 显示在界面上界面
        [self dealContentWithResponse:responseObject];
        
        self.tableView.hidden = NO;
        
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        SYLog(@"请求失败");
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
    
}
 //处理内容数据 显示在界面上界面
-(void)dealContentWithResponse:(id)responseObject{
   
    //取出字典
    NSDictionary *dic = responseObject[@"data"];
    
    //转成模型
    [self.dataContent yy_modelSetWithDictionary:dic];
    
    
    //将contenView赋给tableView.tableHeaderView
    
    self.tableView.tableHeaderView = self.contentView;
    
    //将内容模型赋值给contView显示
    self.contentView.model = self.dataContent;
    
    

   
}

#pragma mark -请求评论数据

-(void)getcommentDataWithID:(NSString *)ID{
    
    NSString *url = [self.commentURL stringByAppendingString:ID];
  //  NSLog(@"%@",url);
    [self.requestManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        //评论总数量
        self.count = [responseObject[@"data"][@"count"] integerValue];
       // NSLog(@"%zd",self.count);
        //评论数组
        NSArray *array = responseObject[@"data"][@"data"];
        //将评论数组转成模型数组
        [self.dataCommentArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYReadCommentModel class] json:array]];
       // NSLog(@"%@",self.dataCommentArray);
        [self.tableView reloadData];
        
        self.tableView.mj_footer.hidden = NO;
       
        //检测是否还有数据
        [self checkOutNoMoreData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        SYLog(@"请求失败");
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataCommentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYReadCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataCommentArray[indexPath.row];
    
    return cell;
}

//设置sectionheader  评论标题头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //SYLogFunc;
    if (self.sectionView == nil) {
        self.sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        self.sectionView.backgroundColor= GlobalColor238;
        
        _label = [[UILabel alloc]init];
        _label.frame = CGRectMake(0, 5, WIDTH, 20);
        
        
        _label.textColor = GlobalColorBLUE;
        _label.font = [UIFont boldSystemFontOfSize:16];
        
        [self.sectionView addSubview:_label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(WIDTH - 40, 5, 30, 20);
        
        [button setImage:[UIImage imageNamed:@"comment_Score"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        [self.sectionView addSubview:button];
    }
   
     _label.text = [NSString stringWithFormat:@"  评论 共%zd条", self.count];
    return self.sectionView;
}

#pragma mark - 评论
-(void)comment{
    
    [SVProgressHUD showInfoWithStatus:@"暂未开放"];
}


#pragma mark - scrollView代理方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //如果往下滑显示
    if (self.beforeY > scrollView.contentOffset.y) {
        self.bottomViewConstraint.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.bottomView layoutIfNeeded];
           
        }];
    }else{//往上滑消失
        self.bottomViewConstraint.constant = -49;
        [UIView animateWithDuration:0.5 animations:^{
            [self.bottomView layoutIfNeeded];
           
        }];
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //记录刚拉时的y
    self.beforeY = scrollView.contentOffset.y;
    
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
