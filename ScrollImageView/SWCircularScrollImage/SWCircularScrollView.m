//
//  SWCircularScrollView.m
//  BlueMobiProject
//
//  Created by sword on 2017/4/6.
//  Copyright © 2017年 sword. All rights reserved.
//

#define IMAGEVIEW_BASETAG 500

#import "SWCircularScrollView.h"

@implementation SWCircularScrollView{
    NSInteger    _currentImageIndex; //当前图片索引
    
    CGSize       _imageSize;    //图片大小
    
    NSInteger    _imageCount;   //图片个数
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self reloadData];
    [self scrollViewSetting];
}

//刷新所有数据
- (void)reloadData
{
    //移除所有
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
    
    [self getImageCount];
    [self getImageSize];
    [self addImageView];
    _currentImageIndex = 0;
    if (_imageCount>0) {
        [self setImageWithIndex:_currentImageIndex];
    }
}

- (void)scrollNext
{
    [self setContentOffset:CGPointMake(_imageSize.width*2 , 0) animated:YES];
}

//设置scrollview属性
- (void)scrollViewSetting
{
    //大于一张图片时才可循环滚动
    if (_imageCount >1) {
        self.contentSize = CGSizeMake(_imageSize.width * 3, self.frame.size.height);
        self.contentOffset = CGPointMake(_imageSize.width, 0);
    }
    else{
        self.contentSize = CGSizeMake(_imageSize.width, self.frame.size.height);
    }
    
    self.delegate = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
}

//获取图片大小
- (void)getImageSize
{
    if ([self.swScrollViewDelegate respondsToSelector:@selector(scrollImageSize)]) {
        _imageSize = [self.swScrollViewDelegate scrollImageSize];
    }
}

//获取图片张数
- (void)getImageCount
{
    if ([self.swScrollViewDelegate respondsToSelector:@selector(numberOfImageInScrollView)]) {
        _imageCount = [self.swScrollViewDelegate numberOfImageInScrollView];
    }
}

//添加图片
- (void)addImageView
{
    if (_imageCount == 0) {
        return;
    }
    NSInteger count = 1;
    //如果只有一张图片时，只创建一个imageview。否则创建左、中、右三张图片。以循环利用
    if (_imageCount>1) {
        count = 3;
    }
    for (int i =0; i<count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageSize.width * i, 0, _imageSize.width, _imageSize.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = IMAGEVIEW_BASETAG + i;
        
        //如果图片可点击，则绑定点击方法
        if (self.imageUserEnable) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerImageTap:)];
            [imageView addGestureRecognizer:tap];
        }
        [self addSubview:imageView];
    }
}

//根据索引设置三张图片
- (void)setImageWithIndex:(NSInteger)index
{
    NSInteger leftIndex = (index - 1 + _imageCount)%_imageCount;
    //如果count等于1，则只有一张图片。
    NSInteger count = 1;
    if (_imageCount>1) {
        count = 3;
    }
    
    for (int i = 0; i<count; i++) {
        UIImageView *imageView = [self viewWithTag:IMAGEVIEW_BASETAG + i];
        [self imageWithIndex:(leftIndex + i)%_imageCount imageBlock:^(UIImage *image){
            imageView.image = image;
        }];
    }
}

//滚动后重新设置三张图片
- (void)didScrollReload
{
    if (self.contentOffset.x >_imageSize.width) {
        _currentImageIndex = (_currentImageIndex +1)%_imageCount;
    }
    else if (self.contentOffset.x < _imageSize.width){
        _currentImageIndex = (_currentImageIndex -1 + _imageCount)%_imageCount;
    }
    [self setImageWithIndex:_currentImageIndex];
    
    self.contentOffset = CGPointMake(_imageSize.width, 0.0);
    
    if ([self.swScrollViewDelegate respondsToSelector:@selector(currentImageChangeAtIndex:)]) {
        [self.swScrollViewDelegate currentImageChangeAtIndex:_currentImageIndex];
    }
}

//通过代理方法获取图片方法
- (void)imageWithIndex:(NSInteger)index imageBlock:(GetImageBlock)imageblock
{
    if (![self.swScrollViewDelegate respondsToSelector:@selector(circularScrollviewImageWithIndex:imageBlock:)]) {
        imageblock(nil);
    }
    [self.swScrollViewDelegate circularScrollviewImageWithIndex:index imageBlock:^(UIImage *image){
        if (imageblock) {
            imageblock(image);
        }
    }];
}

//点击图片
- (void)bannerImageTap:(UITapGestureRecognizer *)tap
{
    if ([self.swScrollViewDelegate respondsToSelector:@selector(didSelectImageAtIndex:)]) {
        [self.swScrollViewDelegate didSelectImageAtIndex:_currentImageIndex];
    }
}


#define UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self didScrollReload];
}

//使用scrollNext方法时，会调用此方法。手指滑动不会走此方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
     [self didScrollReload];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.swScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.swScrollViewDelegate scrollViewWillBeginDragging:self];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.swScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.swScrollViewDelegate scrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

@end
