//
//  CarouselView.m
//  CarouselDemo
//
//  Created by 易博 on 2017/4/6.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "CarouselView1.h"
#import "UIImageView+WebCache.h"
#import "CarouselModel.h"

@interface CarouselView1 ()<UIScrollViewDelegate>
//装载轮播图的scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//页码
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//数据源
@property (strong,nonatomic) NSMutableArray *dataArr;
//滚动的计时器
@property (strong,nonatomic) NSTimer *timer;

//是否开启自动滚动,默认不开启
@property (assign,nonatomic) BOOL autoScroll;
@end

@implementation CarouselView1

-(instancetype)initWithFrameAndData:(CGRect)frame data:(NSMutableArray *)dataModel
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"CarouselView1" owner:nil options:nil][0];
        self.frame = frame;
        self.dataArr = dataModel;
        [self initCarouselView];
    }
    return self;
}

-(void)initCarouselView
{

    CGFloat imageW = self.frame.size.width;
    CGFloat imageH = self.frame.size.height;
    CGFloat imageY = 0;
    CGFloat imageX = 0;
    
    //初始化
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    //添加图片
    for (int i = 0; i < self.dataArr.count; i++) {
        imageX = i * imageW;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        imageView.tag = 1000 + i;
        imageView.userInteractionEnabled = YES;
        CarouselModel *model = [self.dataArr objectAtIndex:i];
        [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"1"]];
        [self.scrollView addSubview:imageView];
        
        //添加imageView的点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
        [imageView addGestureRecognizer:tap];
    }
    
    //设置内容区域
    self.scrollView.contentSize = CGSizeMake(self.dataArr.count * imageW, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    
    //设置分页页数
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.dataArr.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.userInteractionEnabled = NO;
    
    if(self.autoScroll)
    {
        [self startTimer];
    }
}

-(void)imageViewTaped:(UITapGestureRecognizer *)sender
{
    NSLog(@"+++++++++:%ld",sender.view.tag);
    if ([self.delegate respondsToSelector:@selector(clickedAtIndex:)]) {
        [self.delegate clickedAtIndex:sender.view.tag];
    }
}

//开始自动滚动
- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

//开启自动滚动
-(void)startAutoScroll
{
    self.autoScroll = YES;
    [self startTimer];
}

//停止自动滚动
-(void)stopAutoScroll
{
    self.autoScroll = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTimer
{
    self.pageControl.currentPage = (self.pageControl.currentPage + 1) % self.dataArr.count;
    [self pageChanged:self.pageControl];
}

#pragma mark - 分页控件监听方法
- (void)pageChanged:(UIPageControl *)page
{
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - 滚动视图代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 根据contentOffset计算页数
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.timer)
    {
        return;
    }
    self.pageControl.currentPage = (scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width;
}

//手动滑动开始时，停止自动滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//手动滑动停止时，开启自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self startTimer];
    }
}

#pragma mark 懒加载

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

@end
