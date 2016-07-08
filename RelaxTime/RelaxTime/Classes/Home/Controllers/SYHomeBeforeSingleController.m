//
//  SYHomeBeforeSingleController.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/1.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYHomeBeforeSingleController.h"

#import "SYHomeTableViewCell.h"

@interface SYHomeBeforeSingleController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong) UITableView * tableView;
@end

@implementation SYHomeBeforeSingleController


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //背景
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH / 2 - 90, HEIGHT - 250, 180, 180)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray * picArray = @[@"cat",@"longLu",@"tree"];
    
    imageView.image = [UIImage imageNamed:picArray[arc4random() % picArray.count]];
    
    //tableView
    [self.view addSubview:imageView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = GlobalColor245;

    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 0, WIDTH - 20, HEIGHT);
    self.tableView.center = CGPointMake(WIDTH /2, HEIGHT /2);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SYHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //自适应高度
    self.tableView.estimatedRowHeight = 10;
    
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.model;
    
    return cell;
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
