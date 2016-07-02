//
//  SYHomeBeforeController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/30.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeBeforeController.h"
#import "SYHomeBeforeCell.h"
#import "SYHomeBeforeDetailController.h"

@interface SYHomeBeforeController ()
@property(nonatomic ,strong) NSMutableArray * dataArray;

@end

@implementation SYHomeBeforeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SYColorRBG(235, 235, 235);
    
    self.title = @"往期回顾";
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYHomeBeforeCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self initSet];
}
#pragma mark - 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray= [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 数据源处理
-(void)initSet{
    
    //判断这是第几年第几个月
    NSDate * date = [NSDate date];

 
   
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
   
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    
    NSDateComponents * cmps =[calendar components:unit fromDate:date];
    //编辑数据源
    [self initDataArrayWithCmps:cmps];
   
}

-(void)initDataArrayWithCmps:(NSDateComponents *)cmps{
    
    //取出年份和月份
   NSInteger year = cmps.year;
  NSInteger month =cmps.month;
    
    //拼接该年的数据 example 2015-06
    for (NSInteger i = month;i > 0; i --) {
        NSString * str = [NSString stringWithFormat:@"%zd-%02zd",year,i];
        [self.dataArray addObject:str];
    }
    //再拼接往年的从2013-01开始
    for (NSInteger i = year -1; i > 2013; i --) {
        for (NSInteger j = 12; j > 0; j --) {
            NSString *str = [NSString stringWithFormat:@"%zd-%02zd",i,j];
            [self.dataArray addObject:str];
        }
    }
   
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   SYHomeBeforeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
          cell.dataLabel.text = @"本月份";
    }else{
        cell.dataLabel.text = [NSString stringWithFormat:@"%@期",self.dataArray[indexPath.row]];
    }
    
    return cell;
}
#pragma mark - Table view delegate

//点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYHomeBeforeDetailController * detailVC = [[SYHomeBeforeDetailController alloc]init];

   detailVC.RequestDate = self.dataArray[indexPath.row];
   

   
   [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
