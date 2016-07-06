//
//  SYMusicViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYMusicViewController.h"
#import "SYReadCommentCell.h"
#import "SYReadCommentModel.h"
#import "SYMusicModel.h"
#import "SYMusicContentView.h"
#import <AVFoundation/AVFoundation.h>


@interface SYMusicViewController ()<UITableViewDelegate, UITableViewDataSource,SYMusicContentViewDelegate>{
    
    //音乐播放器
   AVPlayer * _player;
    AVPlayerItem * _item;

}



@property (weak, nonatomic) IBOutlet UITableView *tableView;

//获取的音乐 数字数组
@property(nonatomic,copy) NSArray * musicArray;

//当前请求的音乐Id
@property(nonatomic,copy) NSString* currentMusicID;

//评论数据模型数组
@property(nonatomic,strong) NSMutableArray* dataCommentArray;

//评论数量
@property(nonatomic,assign) NSInteger count;

//音乐数据
@property(nonatomic ,strong) NSMutableArray * dataMusicArray;

//当前音乐模型
@property(nonatomic,strong) SYMusicModel* currentModel;

//音乐内容view
@property(nonatomic ,strong) SYMusicContentView * musicContentView;

@end

@implementation SYMusicViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
    
    [SVProgressHUD show];
    
    [self setPlayer];
    
    //请求第一次的音乐ID数组数据
    [self getMusicArray];
    
  
}



#pragma mark - 懒加载
-(NSMutableArray *)dataCommentArray{
    if (!_dataCommentArray) {
        
        _dataCommentArray = [NSMutableArray array];
    }
    
    return _dataCommentArray;
}

-(NSMutableArray *)dataMusicArray{
    
    if (!_dataMusicArray) {
        
        _dataMusicArray = [NSMutableArray array];
    }
    
    return _dataMusicArray;
}

-(SYMusicContentView *)musicContentView{
    if (!_musicContentView) {
        _musicContentView = [[[NSBundle mainBundle]loadNibNamed:@"SYMusicContentView" owner:nil options:nil]lastObject];
        //设置代理
        _musicContentView.delegate = self;
    }
    return _musicContentView;
}


#pragma mark - 创建UI
-(void)creatUI{
    
    
    //去掉右按钮
    self.navigationItem.rightBarButtonItem = nil;
    //设置滑条和tableView的偏移量
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 49, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SYReadCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.estimatedRowHeight = 10;
    
    //开始隐藏tableView
    self.tableView.hidden = YES;
    
    
    //加刷新尾巴
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        //取出评论模型的id
        SYReadCommentModel *model = self.dataCommentArray.lastObject;
        //请求多余评论数据
        [self getMusicCommentWithID:self.currentMusicID andUserId:model._id];
        
    }];
   
}

#pragma mark - 创建player和监听
-(void)setPlayer{
    
    //NSLog(@"%@",_currentModel.music_id);
    _player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:@" "]];
    
    //获取播放器播放结束的时刻
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
   
}

#pragma mark - 监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
 
    if ([keyPath isEqualToString:@"status"]) {
        switch (_player.status) {
            case AVPlayerStatusUnknown:
                 SYLog(@"KVO：正在加载");
                
                break;
            case AVPlayerStatusReadyToPlay:
                if (self.musicContentView.playButton.selected) {
                    [ XMGStatusBarHUD showSuccess:@"正在播放"];
                }
             
                SYLog(@"KVO：加载成功");
        
                break;
            case AVPlayerStatusFailed:
               SYLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
    
    //缓冲进度
//    AVPlayerItem * songItem = object;
//    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSArray * array = songItem.loadedTimeRanges;
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
//        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
//        SYLog(@"共缓冲%.2f",totalBuffer);
//    }
    
}





#pragma mark - 请求第一次的音乐ID数组数据
-(void)getMusicArray{
    
    __weak typeof(self) weakSelf = self;
    
    [self.requestManager GET:Music_first_URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //获取音乐数组
        _musicArray = responseObject[@"data"];
         // NSLog(@"%@",self.musicArray);
        
       //设置当前请求的音乐Id
        weakSelf.currentMusicID = _musicArray[0];
        
        //根据音乐数组中数字请求详细参数 第一次请求第一个
        
        [weakSelf getMusicWithID:weakSelf.currentMusicID];
     
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        SYLog(@"音乐数组请求失败");
    }];
}

#pragma mark - 以Id请求歌曲数据和第一次的评论
-(void)getMusicWithID:(NSString *)ID{
    
    //请求音乐详细数据
    //详情地址
    NSString *detailUrl = [Music_detail_URL stringByAppendingString:ID];
    
    
    [self.requestManager GET:detailUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
       // NSLog(@"%@",responseObject);
        SYMusicModel *model = [[SYMusicModel alloc]init];
        
        [model yy_modelSetWithDictionary:responseObject[@"data"]];
      
        
        //请求完成后使切换按钮可用
        self.musicContentView.changeButton.enabled = YES;
      
        //添加到音乐详情数据源中
        [self.dataMusicArray addObject:model];
        
        //赋值当前音乐模型并设置当前显示内容 设置初始化player（重写了setter）
        self.currentModel = model;
    
        //将musicContentView 设置为tableHeaderView
        self.tableView.tableHeaderView = self.musicContentView;
        
          //显示tableView
        self.tableView.hidden = NO;
        
       
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SYLog(@" 音乐详情请求失败");
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
    
    //第一次请求评论数据
    [self getMusicCommentWithID:ID andUserId:[NSString stringWithFormat:@"%d",0]];
    
}


#pragma mark - 以Id请求歌曲评论
-(void)getMusicCommentWithID:(NSString *) ID andUserId:(NSString *)userId{
    
    //拼接url
    NSString *url = [Music_comment_URL stringByAppendingFormat:@"%@/%@", ID, userId];
    
    self.currentMusicID = ID;
    
    [self.requestManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //如果不是当前请求的评论数据就返回
        if (self.currentMusicID != ID) {
            SYLog(@"不是当前请求的评论数据");
            return;
        }
        //取出评论字典的数组
        NSArray *arr = responseObject[@"data"][@"data"];
        //取出评论数量
        self.count = [responseObject[@"data"][@"count"] integerValue];
        
        //如果userID为0，清除数组元素
        if ([userId isEqualToString:@"0"]) {
             [self.dataCommentArray removeAllObjects];
        }
        
      
        //转成模型数组存入数据源
        
        [self.dataCommentArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SYReadCommentModel class] json:arr]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            //判断是否没有更多更多数据
            [self checkOutNoMoreData];
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评论请求失败"];
        SYLog(@"音乐评论请求失败");
    }];
    
}

#pragma mark - 判断是否没有更多数据
-(void)checkOutNoMoreData{
    //判断是否刷新完数据 显示没有更多
    if (self.count <= self.dataCommentArray.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - tableView代理方法
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataCommentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYReadCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataCommentArray[indexPath.row];
    
    return cell;
}

//设置sectionheader  评论标题头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, 0, 20);
    label.text = [NSString stringWithFormat:@"  评论 共%zd条", self.count];
    
    label.textColor = GlobalColorBLUE;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.backgroundColor = GlobalColor238;
  
    return label;
    
}

#pragma mark - SYMusicContentViewDelegate 按钮点击

//内容被改变
-(void)contentViewHasBeenChanged:(SYMusicContentView *)contentView{
    
    [self.tableView reloadData];
}
//播放按钮被点击
-(void)playButtonClick:(UIButton *)button{
  
    if (![self.currentModel.music_id containsString:@"http:"]) {
       
        [SVProgressHUD showErrorWithStatus:@"暂不支持\n这首音乐播放"];
    }else{
        
        //判断播放或者暂停
        if (button.selected) {
            [XMGStatusBarHUD showMessage:@"暂停播放"];
            button.selected = NO;
            [_player pause];
        }else{
            if (_item.status == 1) {
                  [XMGStatusBarHUD showSuccess:@"正在播放"];
                button.selected = YES;
            }else if (_item.status == 0){
                [XMGStatusBarHUD showLoading:@"正在加载中"];
                button.selected = YES;
            }else{
                 [XMGStatusBarHUD showError:@"加载失败"];
                 button.selected = NO;
            };
           
            [_player play];
        }
    }
}

//切换按钮被点击
-(void)changeBunttonClick:(UIButton *)button{
 
    //播放停止
    [_player pause];
    //播放按钮停止旋转
    self.musicContentView.playButton.selected= NO;
    
 
    //如果歌曲还没有完全请求下来就继续请求新的歌曲
    if (self.dataMusicArray.count < self.musicArray.count) {
        //先让按钮不可用 请求完成后可用 防止多次请求
        button.enabled = NO;
        //转圈圈
        [SVProgressHUD show];
        
        //切换当前音乐ID
        self.currentMusicID = self.musicArray[self.dataMusicArray.count];
        
        //请求下一个音乐ID对应的歌曲
        [self getMusicWithID:self.currentMusicID];
        
    }else{
      //否则把之前的数据拿来显示 循环显示 评论重新请求
        static int i = 0;
        
        //切换当前显示内容
        self.currentModel = self.dataMusicArray[i];
        
        //切换当前请求音乐ID 刷评论要用
        self.currentMusicID = self.musicArray[i];
        
        //重新请求该音乐ID的评论数据
        [self getMusicCommentWithID:self.currentMusicID andUserId:[NSString stringWithFormat:@"%d",0]];
        //计数加一
        i ++;
        //如果到最后一位切换至第一位
        if (i == self.dataMusicArray.count - 1) {
            i = 0;
        }
    }
}

#pragma mark - 重写currentModel setter方法 更换播放音乐 添加观察者

-(void)setCurrentModel:(SYMusicModel *)currentModel{
    
    _currentModel = currentModel;
    
    //如果格式正确更换播放音乐
    if ([_currentModel.music_id containsString:@"http:"]){
        
        //先移除观察者
        [_item removeObserver:self forKeyPath:@"status"];
        [_item removeObserver:self forKeyPath:@"loadedTimeRanges"];
        
       // 更换播放音乐
        _item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:_currentModel.music_id]];
        
        [_player replaceCurrentItemWithPlayerItem:_item];
        
        //添加观察者 监听加载状态
        [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }

    
    //将模型赋给contentView
    self.musicContentView.model = _currentModel;
    
}


#pragma mark - 通知 音乐播放完毕后调用的方法
-(void)repeatPlay{
    
    //循环播放
    [_player replaceCurrentItemWithPlayerItem:[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.currentModel.music_id]]];
    
    [_player play];
}

#pragma mark - 最开始设置tableView的偏移量 
-(void)viewDidLayoutSubviews{

   self.tableView.contentOffset = CGPointMake(0, WIDTH - 100);
   
    
}

#pragma mark - 移除监听
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_player removeObserver:self forKeyPath:@"status"];
    
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
