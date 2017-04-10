//
//  ViewController.m
//  CarouselDemo
//
//  Created by 易博 on 2017/4/6.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "ViewController.h"
#import "CarouselView1.h"
#import "CarouselView2.h"
#import "CarouselView.h"
#import "CarouselModel.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<CarouselDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"carouselArr.plist" ofType:nil]];
    for (NSDictionary *dic in dataArr) {
        CarouselModel *model = [[CarouselModel alloc]init];
        model.imageUrl = [dic objectForKey:@"imageUrl"];
        model.contentUrl = [dic objectForKey:@"contentUrl"];
        model.labelText = [dic objectForKey:@"textLable"];
        [dataList addObject:model];
    }
    
    //CarouselView1，普通的轮播实现
    //CarouselView2，采用两个ImageView来实现无限轮播
    //CarouselView，采用UICollectionView来实现无线轮播
    
    CarouselView *view1 = [[CarouselView alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, (self.view.frame.size.width - 40) * 0.5)];
    view1.delegate = self;
    [view1 startAutoScroll];
    view1.dataSources = dataList;
    [self.view addSubview:view1];
}


-(void)clickedAtIndex:(NSInteger)index
{
    NSLog(@"++++++++++++++++:%ld",index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
