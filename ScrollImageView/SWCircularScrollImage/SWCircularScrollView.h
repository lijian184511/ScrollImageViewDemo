//
//  SWCircularScrollView.h
//  BlueMobiProject
//
//  Created by sword on 2017/4/6.
//  Copyright © 2017年 sword. All rights reserved.
//

/**
 *  图片循环滚动，因为使用图片重用机制，所以不会出现大量图片创建带来的内存消耗过多问题
 *  支持图片滑动浏览，以及图片点击
 *  调用reloadData方法可以进行刷新
 *  调用scrollNext方法会切换到下一张图片
 */

#import <UIKit/UIKit.h>
@class SWCircularScrollView;

//返回图片block
typedef void(^GetImageBlock)(UIImage *);

@protocol SWCircularScrollViewDelegate <NSObject>

@required

/**
 @brief 一共多少张图片
 */
- (NSInteger)numberOfImageInScrollView;

/**
 @brief 获取图片大小
 */

- (CGSize)scrollImageSize;

/**
 @brief 根据索引获取图片代理方法
 */
- (void)circularScrollviewImageWithIndex:(NSInteger)index imageBlock:(GetImageBlock)imageBlock;

@optional

/**
 @brief 图片索引变化
 */
- (void)currentImageChangeAtIndex:(NSInteger)index;

- (void)didSelectImageAtIndex:(NSInteger)index;

//以下两个方法继承自scrollview系统
- (void)scrollViewWillBeginDragging:(SWCircularScrollView *)scrollView;

-(void)scrollViewDidEndDragging:(SWCircularScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

@interface SWCircularScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,assign)BOOL imageUserEnable;  //是否可点击，默认为NO

@property (nonatomic,weak)id<SWCircularScrollViewDelegate> swScrollViewDelegate;

@property (nonatomic,assign)BOOL autoScroll;  //是否自动滚动，为yes时，默认每3秒滚动一张图片
/**
 @brief 刷新数据
 */
- (void)reloadData;

/**
 @brief 执行滚动
 */
- (void)scrollNext;

@end
