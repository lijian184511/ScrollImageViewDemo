//
//  ViewController.m
//  ScrollImageView
//
//  Created by sword on 2017/4/6.
//  Copyright © 2017年 sword. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    SWCircularScrollView * _scrollView;
    UILabel              *_label;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScrollView];
    [self addLabel];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)addScrollView
{
    _scrollView = [[SWCircularScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.swScrollViewDelegate = self;
    
    _scrollView.imageUserEnable = YES;  //设置图片可点击
    [self.view addSubview:_scrollView];
}

- (void)addLabel
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0,50, 100, 50)];
    _label.center = CGPointMake(self.view.center.x, _label.center.y);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"第1张图片";
    [self.view addSubview:_label];
}

#pragma mark
#pragma mark SWCircularScrollViewDelegate
//返回图片张数
- (NSInteger)numberOfImageInScrollView
{
    return 5;
}

//返因图片大小
- (CGSize)scrollImageSize
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

//通过imageblock返回uiimage对象。如果网络图片，则下载后通过block返回
- (void)circularScrollviewImageWithIndex:(NSInteger)index imageBlock:(GetImageBlock)imageBlock
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%ld",index+1]];
    imageBlock(image);
}

//滑动图片后，图片索引变化
- (void)currentImageChangeAtIndex:(NSInteger)index
{
    _label.text = [NSString stringWithFormat:@"第%ld张图片",index+1];
}

- (void)didSelectImageAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld张图片",index+1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
