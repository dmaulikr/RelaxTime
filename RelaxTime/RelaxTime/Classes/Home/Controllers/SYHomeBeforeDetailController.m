//
//  SYHomeBeforeDetailController.m
//  RelaxTime
//
//  Created by imac on 16/6/30.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeBeforeDetailController.h"
#import <XRWaterfallLayout.h>
#import "SYWaterCell.h"
#import "SYHomeModel.h"
#import "SYHomeBeforeSingleController.h"



@interface SYHomeBeforeDetailController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XRWaterfallLayoutDelegate>


@property(nonatomic,strong) UICollectionView* collectionView;



@end

@implementation SYHomeBeforeDetailController


-(void)dealloc{
    [self.requestManager.operationQueue cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self getdata];
    [SVProgressHUD show];
    self.title = self.RequestDate;
    
}

#pragma mark - UI
-(void)creatUI{
    
    self.view.backgroundColor = SYColorRGB(235,235 ,235);
    
    //创建布局对象
    XRWaterfallLayout *layout = [[XRWaterfallLayout alloc]initWithColumnCount:2];
    
    //设置代理
    layout.delegate = self;
    
    //columnSpacing:列间距
    //rowSpacing：行间距
    //sectionInset:块的上左下右间距
    [layout setColumnSpacing: MarginCell rowSpacing:MarginCell sectionInset:UIEdgeInsetsMake(0, MarginCell / 2, 0, MarginCell / 2)];
    

    self.collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds] collectionViewLayout:layout];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    //颜色
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SYWaterCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}

#pragma mark - 数据请求
-(void)getdata{
    
    NSString *url = [Home_before_URL stringByAppendingString:self.RequestDate];
    __weak typeof (self) weakSelf = self;
    [self.requestManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *array = responseObject[@"data"];
        [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYHomeModel class]json:array]];
        
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.collectionView reloadData];
        });
       // NSLog(@"%@",self.dataArray);
        

        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    

}
#pragma mark - collection代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //SYLogFunc;
   return  self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //SYLogFunc;
    SYWaterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.model = self.dataArray[indexPath.row];

    return cell;
}
#pragma mark - cell点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SYHomeBeforeSingleController *vc = [[SYHomeBeforeSingleController alloc]init];
    
    vc.model =self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - water Cell高度返回
-(CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    
    
    
    SYHomeModel *model = self.dataArray[indexPath.row];
  
    return model.cellHeight;

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
