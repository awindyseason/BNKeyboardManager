//
//  UIView+Addtion.h
//  BNKeyboardManager
//
//  Created by iosKF on 2020/6/8.
//  Copyright © 2020 Tikbee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Addtion)
@property (nonatomic,readonly) CGFloat maxX;
@property (nonatomic,readonly) CGFloat maxY;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
//@property (nonatomic, readonly, strong) NSString *desc;
@property (nonatomic,readonly) CGRect originRect;
@property (nonatomic,readonly) CGRect windowRect;

- (CGRect)bnRectToView:(UIView *)superview;

+ (NSString *)desc;
+ (instancetype)BNLoadNib;
@end

NS_ASSUME_NONNULL_END
