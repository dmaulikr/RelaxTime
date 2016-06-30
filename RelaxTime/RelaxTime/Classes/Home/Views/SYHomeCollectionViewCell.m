//
//  SYHomeCollectionViewCell.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeCollectionViewCell.h"
#import "SYHomeTableViewCell.h"
#import "SYHomeModel.h"
@interface SYHomeCollectionViewCell()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic ,strong) NSMutableArray * dataArray;

@end

@implementation SYHomeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    SYLogFunc;
   // self.autoresizingMask = NO;
    self.tableView.contentInset = UIEdgeInsetsMake( 70, 0, 200, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SYHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
  
}

#pragma mark - 模型赋值
-(void)setModel:(SYHomeModel *)model{
    
    _model = model;
    
   
    [self.tableView reloadData];
    //NSLog(@"%f",self.tableView.contentOffset.y);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   SYHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _model;
  
    return cell;
}

@end
