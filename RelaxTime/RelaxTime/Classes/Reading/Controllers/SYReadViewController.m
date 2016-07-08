//
//  SYReadViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadViewController.h"
#import "SYReadTopCell.h"
#import "SYReadBottomCell.h"
#import "SYReadQuesModel.h"
#import "SYReadSeriesModel.h"
#import "SYReadEssayModel.h"
#import "SYReadTopModel.h"
#import "SYReadDetailController.h"
#import "SYReadTopViewController.h"
#import "SYSearchControllerViewController.h"


@interface SYReadViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,SYReadCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

//上部数据
@property(nonatomic ,strong) NSMutableArray * dataArrayTop;
//下部数据
@property(nonatomic ,strong) NSMutableArray * dataArrayBottom;

@property(nonatomic,strong) NSTimer* timer;
@property (weak, nonatomic) IBOutlet SYAgainDownView *topDownAgainView;

@property (weak, nonatomic) IBOutlet SYAgainDownView *bottomDownView;

@end

#define TopCellID @"topCell"
#define BottomCellID @"bottomCell"
@implementation SYReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageController.hidden = YES;
    
    //设置重新下载
    __weak typeof (self) weakSelf = self;
    self.topDownAgainView.hidden = YES;
    
    self.topDownAgainView.block = ^() {
        [SVProgressHUD show];
        [weakSelf getdata];
        weakSelf.topDownAgainView.hidden = YES;
    };
    
    self.bottomDownView.hidden = YES;
    [self.bottomDownView setBlock:^{
        [SVProgressHUD show];
        [weakSelf getdata];
        weakSelf.bottomDownView.hidden = YES;
    }];
    
    
     [self setUI];
    
    
     [SVProgressHUD show];
    
    [self getdata];
    

    
}


#pragma mark - 懒加载

-(NSMutableArray *)dataArrayTop{
    if (!_dataArrayTop) {
        _dataArrayTop = [NSMutableArray array];
    }
    return _dataArrayTop;
}

-(NSMutableArray *)dataArrayBottom{
    if (!_dataArrayBottom) {
        _dataArrayBottom = [NSMutableArray array];
    }
    return _dataArrayBottom;
}



#pragma mark - 设置UI
-(void)setUI{

    //注册cell
    [self.topCollectionView registerNib:[UINib nibWithNibName:@"SYReadTopCell" bundle:nil] forCellWithReuseIdentifier:TopCellID];
     [self.bottomCollectionView registerNib:[UINib nibWithNibName:@"SYReadBottomCell" bundle:nil] forCellWithReuseIdentifier:BottomCellID];
    
    
}
#pragma mark - 请求数据
-(void)getdata{

    //请求下方数据
    if (self.dataArrayBottom.count ==0) {
           __weak typeof (self) weakSelf = self;
        [self.requestManager GET:Read_Bottom_URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            //处理下部数据
            [self dealBottomDataWithResponse:responseObject];
            
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.bottomCollectionView reloadData];
                [SVProgressHUD dismiss];
                
                weakSelf.bottomDownView.hidden = YES;
            });
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //[SVProgressHUD showErrorWithStatus:@"请求失败"];
            SYLog(@"read下方请求失败");
             [SVProgressHUD dismiss];
            
              weakSelf.bottomDownView.hidden = NO;
        }];

    }
    
    if (self.dataArrayTop.count == 0) {
        //请求上方数据
        [self.requestManager GET:Read_Scroll_URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray * array = responseObject[@"data"];
            [self.dataArrayTop addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYReadTopModel class] json:array]];
            
            //设置数据源 前后各加一个元素
            [self.dataArrayTop insertObject:self.dataArrayTop.lastObject atIndex:0];
            [self.dataArrayTop addObject:self.dataArrayTop[1]];
            
            
            //设置偏移量
            self.topCollectionView.contentOffset = CGPointMake(WIDTH, 0);
            //刷新数据
            [self.topCollectionView reloadData];
            
            //显示pageControler设置
            _pageController.hidden = NO;
            _pageController.numberOfPages = self.dataArrayTop.count - 2;
            _pageController.currentPage = 0;
            
            //添加计时器
            self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
            
            [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
            //请求成功 隐藏
            self.topDownAgainView.hidden = YES;
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
            SYLog(@"read页下方请求失败");
             [SVProgressHUD dismiss];
            //请求失败 显示
            self.topDownAgainView.hidden = NO;
        }];
    }
    
}

#pragma mark - 定时器事件
-(void)timeGo{
    
    //改变偏移量
   [ self.topCollectionView setContentOffset:CGPointMake(self.topCollectionView.contentOffset.x + WIDTH, 0) animated:YES];
    
}

//动画结束后
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //重置偏移量和pageControllor
    [self changeContenOffestAndCurrentPage:self.topCollectionView];
}

#pragma mark - 下部数据处理
-(void)dealBottomDataWithResponse:(id)responseObject{
    //取出包含 散文 连载  问答 的字典
    NSDictionary * dicAll = responseObject[@"data"];
    
      NSMutableArray *arrayTemp = [NSMutableArray array];
    
    //取出散文数组转成模型后存入数据源
    NSArray *essayArray = dicAll[@"essay"];
    [arrayTemp addObject:[NSArray yy_modelArrayWithClass:[SYReadEssayModel class] json:essayArray]];
    
    
    //取出连载数组转成模型后存入数据源
    NSArray *seriesArray = dicAll[@"serial"];
    [arrayTemp addObject:[NSArray yy_modelArrayWithClass:[SYReadSeriesModel class] json:seriesArray]];
    
    //取出问答数组转成模型后存入数据源
    NSArray *questionArray = dicAll[@"question"];
    [arrayTemp addObject:[NSArray yy_modelArrayWithClass:[SYReadQuesModel class] json:questionArray]];
    
    //处理数组结构 转成10个数组 每个数组中有三个模型  外层10次循环 内层3次
    for ( int i = 0; i < [arrayTemp[0] count]; i ++) {
        
         NSMutableArray *arr = [NSMutableArray array];
        
        for (int j = 0; j < arrayTemp.count; j ++) {
           [ arr addObject:arrayTemp[j][i]];
        }
        [self.dataArrayBottom addObject:arr];
    }
   
}

#pragma mark - UICollection相关的代理方法
//返回cell个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.topCollectionView) {
        return self.dataArrayTop.count;
    }
     return self.dataArrayBottom.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //上方的
    if (collectionView == self.topCollectionView) {
        
        SYReadTopCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:TopCellID forIndexPath:indexPath];
        SYReadTopModel *model = self.dataArrayTop[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default"]];
        
       
        return cell;
        
    }
    //下方的
    SYReadBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BottomCellID forIndexPath:indexPath];
   //从数组取出数据给cell
  
    cell.dataArray = self.dataArrayBottom[indexPath.row];
   // NSLog(@"%@",cell.dataArray);
    //设置代理 cell内部tableView cell被点击的事件
    cell.delegate = self;
    return cell;
    
}

//返回cell尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell大小都和各自的collectionview的尺寸一样
    //NSLog(@"%f  %f",collectionView.width, collectionView.height);
   return CGSizeMake(collectionView.width, collectionView.height);
 
}

#pragma mark - 上方collection点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.topCollectionView) {
        SYReadTopViewController *vc = [[SYReadTopViewController alloc]init];
        //取出模型
        SYReadTopModel *model = self.dataArrayTop[indexPath.row ];
        //赋参数
        vc._id = model._id;
        vc.bgColor = model.bgcolor;
        vc.cover = model.cover;
        
        SYNavgationController *nav = [[SYNavgationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - scrollView代理 改变偏移量
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //SYLogFunc;
    //判断第一张和最后一张改变偏移量
    if (scrollView == self.topCollectionView) {
        
        [self changeContenOffestAndCurrentPage:scrollView];
        //重置timer
        [self resetTimer];
    }

    
}

#pragma mark - 定时器重置操作
-(void)resetTimer{
    //之前的销毁
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

//在即将开始拖拽时销毁计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //定时销毁
   // SYLogFunc;
    if (scrollView == self.topCollectionView) {
        [self.timer invalidate];
        self.timer = nil;
    }

    
}
//在停止拖拽时启动计时器 因为可能不调用DidEndDecelerating方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //SYLogFunc;
    if (scrollView == self.topCollectionView) {
            [self resetTimer];
    }

}


#pragma mark - 改变偏移量 和 currentpage
-(void)changeContenOffestAndCurrentPage:(UIScrollView *) scrollView{
    //如果第一张或者最后一张 改变偏移量

        if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPointMake(WIDTH * (self.dataArrayTop.count - 2), 0);
        }else if (scrollView.contentOffset.x == WIDTH *(self.dataArrayTop.count - 1)){
            
            scrollView.contentOffset = CGPointMake(WIDTH ,0);
            
        }
    //设置pagecontrol的页数
    self.pageController.currentPage = scrollView.contentOffset.x / WIDTH - 1;
    
}


 #pragma mark - readCell 代理方法 推出控制器
-(void)pushControllerWithType:(ReadType)type andItemsID:(NSString *)itemsID{
    
    SYReadDetailController * detailVC  = [[SYReadDetailController alloc]init];
    //文章种类
    
    detailVC.type = type;
    //id
    detailVC.itemID = itemsID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 搜索 
-(void)searchClick{
    //搜索
    
    SYSearchControllerViewController *searchVc = [[SYSearchControllerViewController alloc]init];
    
    searchVc.type = readVC;
    
    SYNavgationController *nav = [[SYNavgationController alloc]initWithRootViewController:searchVc];
    
        
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
        
   
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
