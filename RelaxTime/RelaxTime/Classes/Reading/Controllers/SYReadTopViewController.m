//
//  SYReadTopViewController.m
//  RelaxTime
//
//  Created by imac on 16/7/2.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadTopViewController.h"
#import "SYReadTopTwoModel.h"
#import "SYReadTopTwoCell.h"
#import "SYReadDetailController.h"

@interface SYReadTopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabbleView;

//headView
@property(nonatomic,strong) UIView* headView;

//headView上的imageView
@property(nonatomic,strong) UIImageView* imageView;
//imageView原始高度
@property(nonatomic,assign) CGFloat imageViewOriginHeight;

@end

@implementation SYReadTopViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    [self setUI];
    
    //设置tableView headView
    [self setTabbleViewHeadView];
  
    //获取数据
    [self getdata];
    
   
   
 
}
-(void)viewDidAppear:(BOOL)animated{
    if (self.dataArray.count == 0) {
        
          [SVProgressHUD show];
    }
  
    
}
#pragma mark - 隐藏状态栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 懒加载
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]init];
    }
    return _headView;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        
        //设置内容物
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

#pragma mark - 设置tableView headView

-(void)setTabbleViewHeadView{
    
    //下载图片
    __weak typeof(self) weaksSelf = self;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.cover] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //根据下载的图片的尺寸设置headview大小
        
        weaksSelf.headView.size = CGSizeMake(WIDTH, WIDTH * image.size.height / image.size.width);
        
        //设置imageView大小
        weaksSelf.imageView.frame = weaksSelf.headView.frame;
        //设置原始高度
        weaksSelf.imageViewOriginHeight = weaksSelf.imageView.height;
        //将imageView放在headview上
        
        [weaksSelf.headView addSubview:weaksSelf.imageView];
        
        //将headview设为tableView的tableheadview
        
        weaksSelf.tabbleView.tableHeaderView = weaksSelf.headView;
        
    }];
}

#pragma mark - UI
-(void)setUI{

    self.tabbleView.estimatedRowHeight = 10;
    //取消分割线
    self.tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册了cell
    [self.tabbleView registerNib:[UINib nibWithNibName:@"SYReadTopTwoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //设置背景颜色
    self.view.backgroundColor  = [UIColor colorWithHexString:self.bgColor];
    self.tabbleView.hidden = YES;
}

#pragma mark - dismiss

- (IBAction)btnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 设置headView

#pragma mark - 数据请求
-(void)getdata{
    NSString *url = [Read_Scroll_Detail_URL stringByAppendingString:self._id];
    
    [self.requestManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSArray *array = responseObject[@"data"];
        
        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYReadTopTwoModel class] json:array]];
     
            self.tabbleView.hidden = NO;
        
            [self.tabbleView reloadData];
           
     [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];

}

#pragma mark - tableView协议方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYReadTopTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYReadDetailController *vc= [[SYReadDetailController alloc]init];
    
    SYReadTopTwoModel *model = self.dataArray[indexPath.row];
    vc.type = [model.type intValue];
    vc.itemID = model.item_id;
    
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - ScrollView代理方法 改变图片大小
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //如果scrolleView往下拉 改变图片的原点及高度
    if (scrollView.contentOffset.y < 0) {
        
        self.imageView.y = scrollView.contentOffset.y;
        self.imageView.height = self.imageViewOriginHeight - scrollView.contentOffset.y;
    }
}


#pragma mark - 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
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
