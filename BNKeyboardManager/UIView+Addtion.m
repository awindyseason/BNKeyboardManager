//
//  UIView+Addtion.m
//  Hypermarket
//
//  Created by iosKF on 2020/6/8.
//  Copyright © 2020 Tikbee. All rights reserved.
//

#import "UIView+Addtion.h"

@implementation UIView (Addtion)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {

    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}

- (CGFloat)y {

    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {

    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
}

- (CGFloat)width {

    return self.frame.size.width;

}

- (void)setWidth:(CGFloat)width {

    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;

}

- (CGFloat)height {

    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}

- (CGPoint)origin {

    return self.frame.origin;

}

- (void)setOrigin:(CGPoint)origin {

    CGRect frame =  self.frame;
    frame.origin = origin;
    self.frame = frame;
    
}

- (CGSize)size {

    return self.frame.size;
}

- (void)setSize:(CGSize)size {

    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
}

- (CGRect)originRect{
    
    return  CGRectMake(self.center.x-self.width/2.0, self.center.y-self.height/2.0, self.width, self.height) ;
}
- (void)setOriginRect:(CGRect)originRect{
    
}

- (CGRect)windowRect{
    return [self.superview convertRect:self.frame toView:UIApplication.sharedApplication.keyWindow];
}
+ (NSString *)desc{
    return NSStringFromClass(self.class);
//    return self.description;
}
@end
