//
//  SYHomeViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeViewController.h"
#import "SYHomeCollectionViewCell.h"
#import "SYHomeModel.h"

@interface SYHomeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
//喜欢数量
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
//喜欢按钮
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
//collection
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//数据源
@property(nonatomic ,strong) NSMutableArray * dataArray;

@end

@implementation SYHomeViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"闲时";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatUI];
    [self getData];
    [SVProgressHUD show];
    
   
}


#pragma mark - 数据请求
-(void)getData{
    
    
    [self.requestManager GET:Home_URl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        //取出数组
        NSArray * array = responseObject[@"data"];
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYHomeModel class] json:array]];
        //NSLog(@"%@",self.dataArray);
        [self.collectionView reloadData];
        
        [self refreshLikeLabel];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        SYLog(@"首页数据请求失败");
    }];
    
   
}

#pragma mark - 刷新喜欢数量
-(void)refreshLikeLabel{
    //取出模型
    NSInteger num =  self.collectionView.contentOffset.x / WIDTH;
    SYHomeModel *model = self.dataArray[num];
    self.likeLabel.text = model.praisenum ;
}
#pragma mark -懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 创建视图
-(void)creatUI{
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SYHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
   
}

#pragma mark - collectionView代理方法事件
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SYHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;

}
//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT);
}
//设置间隔

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark - scollviewView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self refreshLikeLabel];
    
}

#pragma mark -按钮点击事件
//用户
-(void)userClick{
}
//搜索
-(void)searchClick{
    
}

//喜欢
- (IBAction)likeBtnClick:(id)sender {
}
//分享
- (IBAction)shareBtnClick:(id)sender {
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
