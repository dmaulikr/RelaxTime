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
    //评论数label
    UILabel *_label;
    
}

@property (weak, nonatomic) IBOutlet SYAgainDownView *againDownLabel;


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

//评论的sectionView
@property(nonatomic ,strong) UIView * sectionView;

@end


@implementation SYMusicViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    //设置重新加载
    self.againDownLabel.hidden = YES;
    
    __weak typeof (self) weakSelf = self;
    [self.againDownLabel setBlock:^{
        
        [SVProgressHUD show];
        [weakSelf getMusicArray];
         weakSelf.againDownLabel.hidden = YES;
    }];
    
    //
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
    
     [self setTitleViewWithText:@"音乐"];
    
    
    //去掉右按钮
    self.navigationItem.leftBarButtonItem = nil;
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
        
        //没有模型 请求第一次的
        if (!model) {
            [self getMusicCommentWithID:self.currentMusicID andUserId:@"0"];
        }else{
        //请求多余评论数据
            [self getMusicCommentWithID:self.currentMusicID andUserId:model._id];
        }
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
            //成功后就显示成功
            case AVPlayerStatusReadyToPlay:
              
               
               [SVProgressHUD showSuccessWithStatus:@"播放中"];
             
                SYLog(@"KVO：加载成功");
        
                break;
            //失败也提示
            case AVPlayerStatusFailed:
                
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
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
        [SVProgressHUD dismiss];
        SYLog(@"音乐数组请求失败");
        weakSelf.againDownLabel.hidden = NO;
    }];
}

#pragma mark - 以Id请求歌曲数据和第一次的评论
-(void)getMusicWithID:(NSString *)ID{
    
    //是否是第一次请求
    static BOOL isFirst = YES;
    
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
        
        //如果是第一次 设偏移量
        if (isFirst) {
            self.tableView.contentOffset = CGPointMake(0, WIDTH * 0.6);
            isFirst = NO;
        }
        
       
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SYLog(@" 音乐详情请求失败");
        //[SVProgressHUD showErrorWithStatus:@"请求失败"];
        [SVProgressHUD dismiss];
        //请求完成后使切换按钮可用
        self.musicContentView.changeButton.enabled = YES;
         self.againDownLabel.hidden = NO;
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
       // [SVProgressHUD showErrorWithStatus:@"评论加载失败"];
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
//设置sectionheader  评论标题头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.sectionView == nil) {
        self.sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        self.sectionView.backgroundColor= GlobalColor238;
        
        _label = [[UILabel alloc]init];
        _label.frame = CGRectMake(0, 5, WIDTH, 20);
        
        
        _label.textColor = GlobalColorBLUE;
        _label.font = [UIFont boldSystemFontOfSize:16];
        
        [self.sectionView addSubview:_label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(WIDTH - 40, 5, 30, 20);
        
        [button setImage:[UIImage imageNamed:@"comment_Score"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        [self.sectionView addSubview:button];
    }
    
    _label.text = [NSString stringWithFormat:@"  评论 共%zd条", self.count];
    return self.sectionView;
}

#pragma mark - 评论
-(void)comment{
    [SVProgressHUD showInfoWithStatus:@"暂未开放"];
}

#pragma mark - SYMusicContentViewDelegate 按钮点击

//内容被改变
-(void)contentViewHasBeenChanged:(SYMusicContentView *)contentView{
    
    [self.tableView reloadData];
}
//播放按钮被点击
-(void)playButtonClick:(UIButton *)button{
   
    //==先停止播放
    [_player pause];
    
    if (![self.currentModel.music_id containsString:@"http:"]) {
       
        [SVProgressHUD showErrorWithStatus:@"暂不支持\n该音乐播放"];
    }else{
        
       /*=====判断以前的item和当前的item是否相同  是否切歌、====*/
        
        //&&&&&如果不相同 切歌
        if (_item != _player.currentItem) {
            
            //先提示网络状况
            Reachability *wifi = [Reachability reachabilityForLocalWiFi];
            Reachability *contect = [Reachability reachabilityForInternetConnection];
            
            if ([wifi currentReachabilityStatus] != NotReachable) {
                
                SYLog(@"wifi连接");
                //换歌
                [_player replaceCurrentItemWithPlayerItem:_item];
                //开始播放
                [self startPlay];
              
            } else if([contect currentReachabilityStatus] != NotReachable){
                
                SYLog(@"手机流量连接");
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"不是WiFi状态" message:@"将会消耗手机流量播放" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //
                    SYLog(@"确定手机流量连接");
                    //换歌
                    [_player replaceCurrentItemWithPlayerItem:_item];
                    
                    //开始播放
                    [self startPlay];
                    
                    
                }];
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    SYLog(@"取消手机流量连接");
                    return ;
                }];
                
                [alertController addAction:action2];
                [alertController addAction:action1];
                
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
                
            } else {
                
                SYLog(@"没有网络");
                [SVProgressHUD showErrorWithStatus:@"没有网络"];
                return;
            }

        }
        //&&&&&&&如果还是当前的歌 只管暂停和播放
        else{
            if (button.selected) {
                [self endPlay];
            }else{
                [self startPlay];
            }
        
        }
    }
}

#pragma mark - 停止播放
-(void)endPlay{
    
    SYLogFunc;
    [SVProgressHUD dismiss];
    self.musicContentView.playButton.selected = NO;
    [_player pause];
    
}

#pragma mark - 开始播放
-(void)startPlay{
    
     [_player play];
    
     SYLogFunc;
    
    if (_item.status == 1) {
        [SVProgressHUD showSuccessWithStatus:@"播放中"];
        self.musicContentView.playButton.selected = YES;
    }else if (_item.status == 0){
        [SVProgressHUD showWithStatus:@"加载中"];
        self.musicContentView.playButton.selected = YES;
    }else{
        [SVProgressHUD showErrorWithStatus:@"记载失败"];
        self.musicContentView.playButton.selected = NO;
        
    };

}

#pragma mark - 切换按钮被点击
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
