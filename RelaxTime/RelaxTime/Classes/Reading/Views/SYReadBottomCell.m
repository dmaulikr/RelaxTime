//
//  SYReadBottomCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYReadBottomCell.h"
#import "SYReadBottomTableCell.h"


@interface SYReadBottomCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SYReadBottomCell

- (void)awakeFromNib {
    // Initialization code
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 10;

    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    
    //设置tableView属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SYReadBottomTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}


#pragma mark - 赋值重写
-(void)setDataArray:(NSArray *)dataArray{
    
    _dataArray = dataArray;
    //重新将偏移量设回来
    self.tableView.contentOffset = CGPointMake(0, -8);
    [self.tableView layoutIfNeeded];
    
    [self.tableView reloadData];
}

#pragma mark - tableView协议方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
   return self.dataArray.count;
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYReadBottomTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    cell.model = self.dataArray[indexPath.row];
  
    return cell;
}

//cell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SYLogFunc;
    //取出对应模型的id值
    id model = self.dataArray[indexPath.row];
    //esaay ->type 1
    //serial ->type 2
    //question->type 3
    [self.delegate pushControllerWithType:indexPath.row + 1 andItemsID: [model valueForKey:@"item_id"]];
    
}
@end
