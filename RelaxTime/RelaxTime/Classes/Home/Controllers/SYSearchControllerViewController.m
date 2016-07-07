//
//  SYSearchControllerViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYSearchControllerViewController.h"
#import "SYHomeModel.h"
#import "SYhomeSearchCell.h"
#import "SYHomeBeforeSingleController.h"
#import "SYReadSeachCell.h"
#import "SYReadDetailController.h"

#import "SYReadTopTwoModel.h"

@interface SYSearchControllerViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic)  UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//当前的url请求
@property(nonatomic ,strong) NSString * currentUrl;


@end

@implementation SYSearchControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = GlobalColor245;
    [self creatUI];
  
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =YES;
}

#pragma mark - UI
-(void)creatUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加搜索框
    UISearchBar *seacrhBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 40)];
    seacrhBar.showsCancelButton = YES;
    seacrhBar.placeholder = @"搜索内容";
    
    seacrhBar.tintColor = [UIColor grayColor];
   // seacrhBar.barTintColor = SYColorRGB(100, 100, 100);
    [self.view addSubview:seacrhBar];
    [self.view bringSubviewToFront:seacrhBar];
    seacrhBar.delegate = self;
   
    if(self.type == homeVC)
        
    {
        self.tableView.rowHeight = 90;
    }else{
        self.tableView.rowHeight = 60;
    }
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SYhomeSearchCell" bundle:nil] forCellReuseIdentifier:@"homeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SYReadSeachCell" bundle:nil] forCellReuseIdentifier:@"readCell"];
}

#pragma mark - 数据请求
-(void)getDataWithSearchWord:(NSString *)searchWord{
    
    [SVProgressHUD show];
    
  NSString * url = [self dealwithWord:searchWord];
    
    SYLog(@"请求中");
    //赋值当前网络请求
    self.currentUrl = url;
    
    [self.requestManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
   //NSLog(@"%@",responseObject);
        //判断不是这次的请求就返回
        SYLog(@"请求成功");
        if (self.currentUrl != url) {
            SYLog(@"不是当前的数据请求,不处理");
            return ;
        }
        
        //如果是 清空数组
        [self.dataArray removeAllObjects];
        
        if (self.type == homeVC) {
               [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYHomeModel class] json:responseObject[@"data"]]];
        }else{
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYReadTopTwoModel class] json:responseObject[@"data"]]];
         
        }
 
      
        
        [self.tableView reloadData];
        
        if (self.dataArray.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"无搜索结果"];
        }else{
          [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
    }];
    
}

#pragma mark - tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == homeVC) {
        SYhomeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
        
        
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
    }
    
    
    SYReadSeachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"readCell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
  
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == homeVC) {
        SYHomeBeforeSingleController *single = [[SYHomeBeforeSingleController alloc]init];
        single.model = self.dataArray[indexPath.row];
        
        [self.navigationController pushViewController:single animated:YES];
    }else{
        
        SYReadDetailController *read = [[SYReadDetailController alloc]init];
        
        //取出模型
        SYReadTopTwoModel *model = self.dataArray[indexPath.row];
        if ([model.type isEqualToString:@"essay"]) {
             read.type = essay;
        }else if([model.type isEqualToString:@"serialcontent"]){
             read.type = serial;
        }else{
            read.type = question ;
        }
      
       
        read.itemID = model._id;
     [self.navigationController pushViewController:read animated:YES];
    }

    
    
}

#pragma mark - searBardelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
 
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    [self getDataWithSearchWord:searchBar.text];
    
}

#pragma mark - 处理搜索词
-(NSString *)dealwithWord:(NSString *)searchWord{
    NSString *urlPath;
    if (self.type ==homeVC) {
        urlPath  = [Search_hp_URL stringByAppendingString:searchWord];
    }else{
        urlPath = [Search_read_URL stringByAppendingString:searchWord];
    }
    
     
     //将链接中的中文转换成%形式
     NSString *string_2 = [urlPath stringByAddingPercentEncodingWithAllowedCharacters:
     [NSCharacterSet characterSetWithCharactersInString:searchWord].invertedSet];
    
    return string_2;
    
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
