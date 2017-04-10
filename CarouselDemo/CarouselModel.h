//
//  CarouselModel.h
//  CarouselDemo
//
//  Created by 易博 on 2017/4/6.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarouselModel : NSObject

//轮播图的地址
@property(copy,nonatomic) NSString *imageUrl;

//超链接内容的地址
@property(copy,nonatomic) NSString *contentUrl;

//文本显示内容
@property(copy,nonatomic) NSString *labelText;

@end
