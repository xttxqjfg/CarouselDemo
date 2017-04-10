//
//  CarouselCollectionView.h
//  CarouselDemo
//
//  Created by 易博 on 2017/4/7.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarouselDelegate <NSObject>

//点击事件
-(void)clickedAtIndex:(NSInteger)index;

@end

@interface CarouselView : UIView

//代理
@property(assign,nonatomic) id<CarouselDelegate> delegate;

//数据源
@property (strong,nonatomic) NSMutableArray *dataSources;

//开启自动滚动
-(void)startAutoScroll;

@end
