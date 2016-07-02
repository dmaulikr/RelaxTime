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

@interface SYHomeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end

@implementation SYHomeViewController

//停止网络请求
-(void)dealloc{
    [self.requestManager.operationQueue cancelAllOperations];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"闲Time";
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
   
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        SYLog(@"首页数据请求失败");
    }];
    
   
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

//点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"collctionCELL被点击了");
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
}
#pragma mark -按钮点击事件
//用户
-(void)userClick{
    
    
}
//搜索
-(void)searchClick{
    
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
