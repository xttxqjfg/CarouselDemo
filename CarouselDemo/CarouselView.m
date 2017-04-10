//
//  CarouselCollectionView.m
//  CarouselDemo
//
//  Created by 易博 on 2017/4/7.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "CarouselView.h"
#import "CarouselCell.h"


// 每一组最大的行数
#define TotalRowsInSection (2000 * self.dataSources.count)
#define DefaultRow (NSUInteger)(TotalRowsInSection * 0.5)


@interface CarouselView()<UICollectionViewDataSource,UICollectionViewDelegate>
//容器
@property (strong, nonatomic) UICollectionView *collectionView;
//分页控制器
@property (strong, nonatomic) UIPageControl *pageControl;
//定时器
@property (nonatomic , strong) NSTimer *timer;
//自动滚动，默认不开启
@property (assign,nonatomic) BOOL autoScroll;

@end

@implementation CarouselView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self initSubviews:frame];
    }
    return self;
}

-(void)initSubviews:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CarouselCell class] forCellWithReuseIdentifier:@"carouselCell"];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.center = CGPointMake(frame.size.width * 0.5, frame.size.height - 30);
    self.pageControl.bounds = CGRectMake(0, 0, 150, 40);
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.enabled = NO;
    self.pageControl.numberOfPages = self.dataSources.count;
    
    [self addSubview:self.pageControl];
    if (self.autoScroll) {
        [self addTimer];
    }
}

-(void)setDataSources:(NSMutableArray *)dataSources
{
    _dataSources = dataSources;
    
    //设置分页控制器页数
    self.pageControl.numberOfPages = self.dataSources.count;
    
    //刷新数据
    [self.collectionView reloadData];
    
    //设置默认组
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:DefaultRow inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

-(void)startAutoScroll
{
    self.autoScroll = YES;
    [self addTimer];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  下一页
 */
- (void)next
{
    NSIndexPath *visiablePath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    
    NSUInteger visiableItem = visiablePath.item;
    if ((visiablePath.item % self.dataSources.count)  == 0) { // 第0张图片
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:DefaultRow inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        visiableItem = DefaultRow ;
    }
    
    NSUInteger nextItem = visiableItem + 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return TotalRowsInSection;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"carouselCell";
    
    CarouselCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CarouselCell" owner:self options:nil][0];
    }
    cell.dataModel = self.dataSources[indexPath.item % self.dataSources.count];
    return cell;
}

#pragma mark - UICollectionViewDelegate
/**
 *  cell显示结束之后调用(滑动了一页)
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *visiablePath = [[collectionView indexPathsForVisibleItems] firstObject];
    //设置pageControl的当前页
    self.pageControl.currentPage = visiablePath.item % self.dataSources.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item % self.dataSources.count;
    if ([self.delegate respondsToSelector:@selector(clickedAtIndex:)]) {
        [self.delegate clickedAtIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self addTimer];
    }
}

@end
