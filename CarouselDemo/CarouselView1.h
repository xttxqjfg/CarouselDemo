//
//  CarouselView.h
//  CarouselDemo
//
//  Created by 易博 on 2017/4/6.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarouselDelegate <NSObject>

//图片的点击事件
-(void)clickedAtIndex:(NSInteger)index;

@end

@interface CarouselView1 : UIView

//代理
@property (nonatomic,assign) id<CarouselDelegate> delegate;

//初始化
-(instancetype)initWithFrameAndData:(CGRect)frame data:(NSMutableArray *)dataModel;

//开启自动滚动
-(void)startAutoScroll;

//停止自动滚动
-(void)stopAutoScroll;

@end
