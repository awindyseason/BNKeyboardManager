//
//  UIView+Addtion.h
//  Hypermarket
//
//  Created by iosKF on 2020/6/8.
//  Copyright © 2020 Tikbee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Addtion)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
//@property (nonatomic, readonly, strong) NSString *desc;
@property (nonatomic,readonly) CGRect originRect;
@property (nonatomic,readonly) CGRect windowRect;
+ (NSString *)desc;
@end

NS_ASSUME_NONNULL_END
