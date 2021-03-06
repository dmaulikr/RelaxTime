//
//  SYSetController.m
//  RelaxTime
//
//  Created by 千锋 on 16/7/9.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYSetController.h"
#import "SYLoginRegisterViewController.h"
#import "SYLikeController.h"
#import "SYUserController.h"


@interface SYSetController ()<SYLoginRegisterViewController,SYUserController>

//内存显示label
@property (weak, nonatomic) IBOutlet UILabel *disklabel;

/**headerView*/
@property (nonatomic, strong) UIView *headerView;
//背景image
@property  (strong,nonatomic)  UIImageView  *imageView;
//imageView 原始高度
@property(nonatomic ,assign) CGFloat imageViewOriginHeight;
//头像image
@property(nonatomic ,strong) UIImageView * iconImage;
//名字
@property(nonatomic ,strong) UILabel * nameLabel;

@end

@implementation SYSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //读取缓存显示
       self.disklabel.text = [NSString stringWithFormat:@"%.1fM",[self calculateMemoryWithPath:localImageCachePath]];
}

#pragma mark - 懒加载
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH * 0.6);
    }
    return _headerView;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        
        _imageView.image = [UIImage imageNamed:@"setBG"];
        //设置内容物
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        
        _imageView.frame = self.headerView.frame;
    }
    return _imageView;
}

-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _iconImage.center = CGPointMake(WIDTH / 2, WIDTH * 0.6 / 2);
        _iconImage.layer.cornerRadius = 40;
        _iconImage.layer.masksToBounds =YES;
        _iconImage.image = [UIImage imageNamed:@"defaultUserIcon"];
        
        //给头像加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        _iconImage.userInteractionEnabled = YES;
        
        [_iconImage addGestureRecognizer:tap];
    }
    return _iconImage;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        _nameLabel.center = CGPointMake(WIDTH / 2, WIDTH * 0.6 / 2 + 60);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}

#pragma mark - 登录 
-(void)tap{
    SYLog(@"登录");
    //判断是否已经登录
   BOOL login = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"];
    if (login) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SYUserController *userVC = [sb instantiateViewControllerWithIdentifier:@"SYUserController"];
        
        userVC.delegate = self;
        
        [self.navigationController pushViewController:userVC animated:YES];
       
        
    }else{
    
    SYLoginRegisterViewController * loginVc = [[SYLoginRegisterViewController alloc]init];
    
    loginVc.delegate = self;
    [self presentViewController:loginVc animated:YES completion:^{
        //
    }];
    }
}

#pragma mark - 注册成功代理方法改变头像
//通过第三方 来设置用户显示
-(void)changeUserbyQQ{
    
    //如果登录状态
    //判断是否已经登录
    BOOL login = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"];
    if (login) {
    self.nameLabel.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
     NSString *iconURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIcon"];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    }else{
        self.nameLabel.text = @"请登录";
        self.iconImage.image = [UIImage imageNamed:@"defaultUserIcon"];
    }
}

//通过手机注册 来设置用户显示
-(void)changeUserByPhoneRegister{
    //如果登录状态
    //判断是否已经登录
    BOOL login = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"];
    if (login) {
        self.nameLabel.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        
        //如果有头像
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIcon"];
        if (data) {
            self.iconImage.image = [UIImage imageWithData:data];
        }else{
            //默认显示
            self.iconImage.image = [UIImage imageNamed:@"comment_profile_mars"];
        }
    }else{
        self.nameLabel.text = @"请登录";
        self.iconImage.image = [UIImage imageNamed:@"defaultUserIcon"];
    }
}

#pragma mark - 设置UI
-(void)creatUI{
    

    self.title = @"个人中心";
    
    /**设置headView*/
    
    //设置原始高度
    self.imageViewOriginHeight = self.imageView.height;
    //将imageView放在headview上
    
    [self.headerView addSubview:self.imageView];
    
    //将头像放到放到headView上
    [self.headerView addSubview:self.iconImage];
    
    //将名字放在headView上
    [self.headerView addSubview:self.nameLabel];
    
    //将headview设为tableView的tableheadview
    
    self.tableView.tableHeaderView = self.headerView;
    
    //设置头像
    [self changeUser];

}

-(void)changeUser{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"registerByPhone"]) {
        [self changeUserByPhoneRegister];
    }else{
        [self changeUserbyQQ];
    }
}

-(double)calculateMemoryWithPath:(NSString *)path{
    //返回字节
     long long size = [SYFileHelper folderSizeAtPath:path];
    
    double mSize = size / 1024.0 / 1024;
    
    return mSize;
}
#pragma mark - ScrollView代理方法 改变图片大小
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //SYLog(@" scYY %f",scrollView.contentOffset.y);
    //如果scrolleView往下拉 改变图片的原点及高度
    if (scrollView.contentOffset.y < 0) {
        
        self.imageView.y = scrollView.contentOffset.y;
       
        self.imageView.height = self.imageViewOriginHeight - scrollView.contentOffset.y;
    
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
        {
            SYLikeController *like = [[SYLikeController alloc]init];
            [self.navigationController pushViewController:like animated:YES];
        }
            break;
        case 1:
            [SVProgressHUD showInfoWithStatus:@"等待开放"];
            break;
        case 2:
            [SVProgressHUD showInfoWithStatus:@"等待开放"];
            break;
        case 3:
            [SVProgressHUD showInfoWithStatus:@"等待开放"];
            break;
        case 4:
        {
         UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要清空缓存?" preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                SYLog(@"确定");
            
            [SVProgressHUD showWithStatus:@"清理中"];
            
            [SYFileHelper clearAtPath:localImageCachePath];
            
             self.disklabel.text = [NSString stringWithFormat:@"%.1fM",[self calculateMemoryWithPath:localImageCachePath]];
            [SVProgressHUD showSuccessWithStatus:@"清理完成"];
            
        }];
            
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                  SYLog(@"取消");
              }];
            
            [alertController addAction:action2];
            [alertController addAction:action1];
            
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
            break;
            
            
        default:
            break;
    }

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
