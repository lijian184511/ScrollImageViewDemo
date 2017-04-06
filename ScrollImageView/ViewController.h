//
//  ViewController.h
//  ScrollImageView
//
//  Created by sword on 2017/4/6.
//  Copyright © 2017年 sword. All rights reserved.
//



/**
    图片循环滚动，因为使用图片重用机制，所以不会出现大量图片创建带来的内存消耗过多问题
 */

#import <UIKit/UIKit.h>
#import "SWCircularScrollView.h"

@interface ViewController : UIViewController<SWCircularScrollViewDelegate>


@end

