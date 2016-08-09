//
//  SYLikeController.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/11.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYLikeController.h"
#import "SYHomeModel.h"
#import "SYhomeSearchCell.h"
#import "SYHomeBeforeSingleController.h"

@interface SYLikeController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//编辑框
@property (weak, nonatomic) IBOutlet UIView *editView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;


//数据源
//待删除数据源
@property(nonatomic ,strong) NSMutableArray *rubbishArray;
//待删除cell
@property(nonatomic ,strong) NSMutableArray *cellArray;


@end

@implementation SYLikeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self creatUI];
    
    [self getdata];
    
    //创建数据源
    [self creatDataArray];
    
}

#pragma mark - 从数据库拉数据
-(void)getdata{
    //从数据库拿出模型
    [self.dataArray addObjectsFromArray: [[BasicDataManager manager]getAllModel]];
    //刷新
    [self.tableView reloadData];
}

#pragma mark - UI
-(void)creatUI{
    self.view.backgroundColor = GlobalColor245;
    
    //先把编辑框移除窗口
    
    self.viewBottomConstraint.constant = -50;
    
    
    //设置右按钮
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateSelected];
    
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.frame = CGRectMake(0, 0, 40, 30);
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5  );
    [button setTitleColor:GlobalColorBLUE forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = btnItem;
    
    
    //设置标题
    self.title = @"我的喜欢";
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SYhomeSearchCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0);
    
    //设置行号
    self.tableView.rowHeight = 90;
    
    //删除多余分割线
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

#pragma mark - 创建数据源
-(void)creatDataArray{
    
    _rubbishArray = [NSMutableArray array];
    _cellArray = [NSMutableArray array];
    
}

#pragma mark - 删除按钮
- (IBAction)delete:(id)sender {
    SYLog(@"删除");
    //将选中的数据从数据源中删除
    [self.dataArray removeObjectsInArray:_rubbishArray];
    
    [_tableView deleteRowsAtIndexPaths:_cellArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    //取出数据ID
    NSMutableArray *idArray =[NSMutableArray array];
    for (SYHomeModel *model  in _rubbishArray) {
        [idArray addObject:model.hpcontent_id];
    }
    
    //从数据库删除
    [[BasicDataManager manager]deleteDataWithIds:idArray];
    //通知中心发消息 改变首页的cell喜欢状态
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IDontLike" object:self userInfo:@{@"IDS":idArray}];
    
    //清空数据
    [_cellArray removeAllObjects];
    [_rubbishArray removeAllObjects];
    
}

#pragma mark - 全选按钮
- (IBAction)allSelect:(id)sender {
    SYLog(@"全选点击");
    
    self.allSelectButton.selected = !self.allSelectButton.selected;
    //如果是全选
    if (self.allSelectButton.selected) {
        //加上所有的数据源
        [_rubbishArray removeAllObjects];
        [_cellArray removeAllObjects];
        
        [_rubbishArray addObjectsFromArray:self.dataArray];
        //改变cell选中状态
        for (int row = 0; row < self.dataArray.count; row ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:row inSection:0];
            //选中cell
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [_cellArray addObject:indexPath];
        }
    }
    else{
       
        [_rubbishArray removeAllObjects];
        [_cellArray removeAllObjects];
        for (int row = 0; row < self.dataArray.count; row ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:row inSection:0];
            //选中cell
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark - 编辑按钮点击事件
-(void)rightClick:(UIButton *)button{
    
    //改变按钮状态
    button.selected = ! button.selected;
    
    //改变编辑模式
    [self.tableView setEditing:button.selected animated:YES];
 
    //清空之前选中的元素
    [_rubbishArray removeAllObjects];
    [_cellArray removeAllObjects];
    
    //出现底部view
    self.viewBottomConstraint.constant =  self.viewBottomConstraint.constant == 0 ? -50 : 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.editView layoutIfNeeded];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYhomeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    cell.editing = YES;
    return cell;
}



//使cell处于编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//设置编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //为编辑时
    if (tableView.editing) {
         return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }else{
        //不在编辑状态时
        return UITableViewCellEditingStyleDelete;
    }
   
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //为编辑状态时
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        //从数据库中删除该元素
        SYHomeModel *model = self.dataArray[indexPath.row];
        [[BasicDataManager manager]deleteDataWithContentId:model.hpcontent_id];
        
        //更改数据源：删除选中的那行cell上面的数据
        [self.dataArray removeObjectAtIndex:indexPath.row];
       
        //删除多余的cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //通知中心发消息 改变首页的cell喜欢状态
        [[NSNotificationCenter defaultCenter]postNotificationName:@"IDontLike" object:self userInfo:@{@"IDS":@[model.hpcontent_id]}];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     //tableView是否等于编辑状态
    if (tableView.editing) {
        //将选中的数据放到待删除的数组里面
        [_rubbishArray addObject:self.dataArray[indexPath.row]];
        //将多余的cell放入数组中
        [_cellArray addObject:indexPath];
        
       
    }else{
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    SYHomeBeforeSingleController *vc = [[SYHomeBeforeSingleController alloc]init];
    
    vc.model = self.dataArray[indexPath.row];
    //不显示喜欢按钮
    vc.hiddenLikeButton = YES;
    
        [self.navigationController pushViewController:vc animated:YES];
    
    }
}

//反选
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView.editing) {
        //将选中的数据从待删除的数组中移除
        [_rubbishArray removeObject:self.dataArray[indexPath.row]];
        [_cellArray removeObject:indexPath];
    }
}

@end
