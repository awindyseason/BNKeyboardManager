//
//  BNKeyboardManager.h
//  TikBeeStore
//
//  Created by yh on 2020/7/17.
//  Copyright © 2020 TikBee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Addtion.h"
#import <UIKit/UIKit.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface BNKeyboardManager : NSObject
// 用来 计算该view不被键盘遮挡所需要的距离 。不指定 默认当前第一响应者
@property (nonatomic,weak) UIView *caculateView;
// 得到计算后用来移动的view。不指定 默认移动window。 用来指定 如：UITextField所在的父View。
@property (nonatomic,weak) UIView *moveView;
// 间距
@property (nonatomic) float defaultMargin;
// 展示toolBar  显示一个完成按钮 点击关闭键盘
@property (nonatomic) BOOL isToolBar;
// 点击其他区域关闭键盘
@property (nonatomic) BOOL tapClose;
// 指定响应者. 不指定 默认为当前第一响应者
@property (nonatomic,weak) UIView *responderView;
+ (instancetype)shared;
- (BOOL)isFirstResponder;
- (void)endEditing;

@end

NS_ASSUME_NONNULL_END
