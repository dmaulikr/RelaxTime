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
#import "SYHomeBeforeController.h"

#import "SYSearchControllerViewController.h"


@interface SYHomeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//重新加载view
@property (weak, nonatomic) IBOutlet SYAgainDownView *againDownView;

//背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
//背景图数组
@property(nonatomic ,strong) NSArray * picArray;

@end

@implementation SYHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatUI];
    [self getData];
    [SVProgressHUD show];
    
    //重新加载的view
    self.againDownView.hidden = YES;
    __weak typeof (self) weakSelf = self;
    self.againDownView.block = ^(){
        SYLog(@"重新加载");
        [weakSelf getData];
        [SVProgressHUD show];
        weakSelf.againDownView.hidden = YES;
    };
    
    
}


#pragma mark - 数据请求
-(void)getData{
    
    __weak typeof (self) weakSelf = self;
    [self.requestManager GET:Home_URl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        //取出数组
        NSArray * array = responseObject[@"data"];
        [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYHomeModel class] json:array]];
        //NSLog(@"%@",self.dataArray);
        dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.againDownView.hidden = YES;
            [weakSelf.collectionView reloadData];
            [SVProgressHUD dismiss];
        });
     
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        //[SVProgressHUD showErrorWithStatus:@"请求失败"];
        [SVProgressHUD dismiss];
        SYLog(@"首页数据请求失败");
        weakSelf.againDownView.hidden = NO;
    }];
    
   
}

#pragma mark - 创建视图
-(void)creatUI{
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SYHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.picArray = @[@"cat",@"longLu",@"tree"];
    
    self.bgImageView.image = [UIImage imageNamed:self.picArray[arc4random() % self.picArray.count]];
   
    [self setTitleViewWithText:@"闲Time"];
    
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

//点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"collctionCELL被点击了");
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
     self.bgImageView.image = [UIImage imageNamed:self.picArray[arc4random() %self.picArray.count]];
}

#pragma mark - scrollview代理  判断是否推出往期

//松手推出
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    
    //判断是否拉到最后一个cell
    //拉过多少才推出控制器
    CGFloat pullInset = 50;
    //需要的偏移量
    CGFloat MaxPull = ((self.dataArray.count - 1) * WIDTH) + pullInset;
    
    //推出控制器
    if (self.collectionView.contentOffset.x  > MaxPull) {
        
        SYHomeBeforeController *beforeVc = [[SYHomeBeforeController alloc]init];
        
        [self.navigationController pushViewController:beforeVc animated:YES];
    }
    
    //清理缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}
#pragma mark -按钮点击事件

//搜索
-(void)searchClick{
    
      SYSearchControllerViewController *searchVc = [[SYSearchControllerViewController alloc]init];
    searchVc.type = homeVC;
    
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
