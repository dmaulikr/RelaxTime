//
//  SYShowPicViewController.m
//  RelaxTime
//
//  Created by 千锋 on 16/6/30.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "SYShowPicViewController.h"

@interface SYShowPicViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic ,strong) UIImageView * imageView;


@end

@implementation SYShowPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //初始化滑动视图
    
   
    
    _scrollView.maximumZoomScale = 3;
    
    _scrollView.minimumZoomScale = 1;
    
    _scrollView.zoomScale = 1;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    
    
    
    
    
    //获取图片的宽高
    CGFloat width = self.image.size.width ;
    CGFloat height = self.image.size.height;

    //创建uiimageView
    self.imageView = [[UIImageView alloc]init];
    
  
    
    //设置图片位置大小
    self.imageView.frame = CGRectMake(0, 0, WIDTH, WIDTH/(width/height));
    self.imageView.center = CGPointMake(WIDTH / 2, HEIGHT / 2);


    //置contensize
  _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
    //赋值图
    self.imageView.image = self.image;
   // NSLog(@"%@",self.imageView.image);
    
  
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    
    tap.numberOfTapsRequired = 2;
    
    
    self.imageView.userInteractionEnabled  = YES;
    [_imageView addGestureRecognizer:tap];
    
    [_scrollView addSubview:self.imageView];
    
    
}

#pragma mark - 图片点击事件
-(void)tap{
    //NSLog(@"被双击两次");
    //双击两次
    [ self.scrollView setZoomScale:self.scrollView.zoomScale != 1 ? 1 : 2 animated:YES];
    
}

#pragma mark -返回缩放的imageView
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

#pragma mark - 缩放时时调用的方法
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    //x和y轴的增量:
    
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    
    //条件运算符
    
    CGFloat delta_x= scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    
    CGFloat delta_y= scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
    
    //让imageView一直居中
    
    //实时修改imageView的center属性 保持其居中
    
    self.imageView.center=CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
    
}


#pragma mark - 按钮点击事件
- (IBAction)backBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)storeImage:(id)sender {
    //保存图片
    __weak typeof (self) weakSelf = self;
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
           UIImageWriteToSavedPhotosAlbum(weakSelf.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
     });
    

}
    
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
         [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}



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
