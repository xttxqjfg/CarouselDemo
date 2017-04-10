//
//  CarouselCell.m
//  CarouselDemo
//
//  Created by 易博 on 2017/4/7.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "CarouselCell.h"
#import "UIImageView+WebCache.h"

@interface CarouselCell()
//显示的图片
@property (weak,nonatomic) IBOutlet UIImageView *imageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation CarouselCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CarouselCell" owner:self options:nil].lastObject;
    }
    return self;
}

//重写属性，设置值
-(void)setDataModel:(CarouselModel *)dataModel
{
    _dataModel = dataModel;
    [self.imageView sd_setImageWithURL:[[NSURL alloc] initWithString:_dataModel.imageUrl] placeholderImage:[UIImage imageNamed:@"1"]];
    self.titleLabel.text = _dataModel.labelText;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
