//
//  BNKeyboardManager.h
//  TikBeeStore
//
//  Created by yh on 2020/7/17.
//  Copyright © 2020 TikBee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Addtion.h"
NS_ASSUME_NONNULL_BEGIN

@interface BNKeyboardManager : NSObject
// 不被的遮挡view 计算键盘与该view 发生的的偏移
@property (nonatomic,weak) UIView *caculcationView;
// 做偏移的view
@property (nonatomic,weak) UIView *moveView;
// 跟偏移view的间距
@property (nonatomic) float defaultMargin;
// 完成bar
@property (nonatomic) BOOL isToolBar;
// 点击关闭
@property (nonatomic) BOOL tapClose;
// 开关
@property (nonatomic) BOOL enable;
// 响应的view
@property (nonatomic,weak) UIView *responderView;

+ (instancetype)shared;

- (void)start;

- (void)endEditing;

@end

NS_ASSUME_NONNULL_END
