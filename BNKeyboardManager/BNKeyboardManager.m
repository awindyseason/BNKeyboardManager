//
//  BNKeyboardManager.m
//  TikBeeStore
//
//  Created by yh on 2020/7/17.
//  Copyright © 2020 TikBee. All rights reserved.
//

#import "BNKeyboardManager.h"
#define k_defaultMargin 10
@interface BNKeyboardManager()

@property (nonatomic) UITapGestureRecognizer *tap;

@property (nonatomic) CGRect keyboardRect;

@property (nonatomic) UIView *toolBar;

@property (nonatomic) NSNotification *nf;
@end

static BNKeyboardManager *shared = nil;

@implementation BNKeyboardManager

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[BNKeyboardManager alloc] init];
        
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        _tapClose = true;
        [self toolBar];
        [self addKeyboardObserver];
        
    }
    return self;
}
//- (void)setMoveView:(UIView *)moveView{
//    if (_moveView && ![moveView isEqual:_moveView]) {
//        _moveView.transform = CGAffineTransformIdentity;
//    }
//    _moveView = moveView;
//}

- (BOOL)isFirstResponder{
    if ([self.responderView respondsToSelector:@selector(isFirstResponder)]) {
        return   [self.responderView isFirstResponder];
    }
    return false;
}

- (void)tap:(UITapGestureRecognizer  *)tap{
    [_responderView endEditing:true];
}

- (void)addKeyboardObserver{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self registerTextFieldViewClass:[UITextField class]
     didBeginEditingNotificationName:UITextFieldTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextFieldTextDidEndEditingNotification];
    
    
    [self registerTextFieldViewClass:[UITextView class]
     didBeginEditingNotificationName:UITextViewTextDidBeginEditingNotification
       didEndEditingNotificationName:UITextViewTextDidEndEditingNotification];
    
}


- (void)registerTextFieldViewClass:(nonnull Class)aClass
  didBeginEditingNotificationName:(nonnull NSString *)didBeginEditingNotificationName
    didEndEditingNotificationName:(nonnull NSString *)didEndEditingNotificationName
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:didBeginEditingNotificationName object:nil];
}
-(void)textFieldViewDidBeginEditing:(NSNotification*)notification
{
    UIView *view = notification.object;
    if (view) {
        _responderView = notification.object;
    }
    if (_tapClose) {
        [_responderView.window addGestureRecognizer:_tap];
    }
    if (_nf) {
         [self keyboardChangeFrame:_nf];
    }
}
- (void)keyboardWillShow:(NSNotification *)nf{}

- (void)keyboardChangeFrame:(NSNotification *)nf{
    _nf = nf;
    if (self.responderView == nil) {
        return;
    }
    _keyboardRect = [nf.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float value = [nf.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
 
  

    NSLog(@"%@--%f",NSStringFromCGRect(_keyboardRect),value);
    CGRect rect;
    UIView *view;
  
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    if (!window) {
        return;
    }
    
    if (_moveView) {
        view =  _moveView ;
    }else{
        
        view =  window;
        _moveView = view;
    }
  
    [view setNeedsLayout];
    view.transform = CGAffineTransformIdentity;
    if (_caculateView) {
        rect = [_caculateView.superview convertRect:_caculateView.originRect toView:window];
    }else{
        if (!self.responderView.superview) {
            return;
        }
        rect = [self.responderView.superview convertRect:self.responderView.originRect toView:window];
    }

    if (rect.size.height == 0) {
        return;
    }
    
    float toolHeight = self.isToolBar?40:0;
    BOOL addToolTransY = [view isEqual:window];
    if (toolHeight > 0 && self.toolBar.superview == nil) {
        [window addSubview:self.toolBar];
        [self.toolBar layoutIfNeeded];
    }
    NSLog(@"rect = %@",NSStringFromCGRect(rect));
    
    if (CGRectGetMaxY(rect) > self.keyboardRect.origin.y - toolHeight) {
        float transformY =  self.keyboardRect.origin.y -  CGRectGetMaxY(rect) - toolHeight - [self getDefaultMargin];

        [UIView animateWithDuration:value delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, transformY);
            if (toolHeight > 0) {
                
                if (addToolTransY) {
                    self.toolBar.frame = CGRectMake(0,SCREEN_HEIGHT - self.keyboardRect.size.height - transformY - toolHeight , SCREEN_WIDTH, toolHeight);
//                    self.toolBar.transform = CGAffineTransformMakeTranslation(0, -self.keyboardRect.size.height - transformY - toolHeight);
                }else{
                    self.toolBar.frame = CGRectMake(0,SCREEN_HEIGHT - self.keyboardRect.size.height  - toolHeight , SCREEN_WIDTH, toolHeight);
                }
            }
        } completion:^(BOOL finished) {

        }];
    }else{
        
        [UIView animateWithDuration:value delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.toolBar.frame = CGRectMake(0,SCREEN_HEIGHT - self.keyboardRect.size.height - toolHeight , SCREEN_WIDTH, toolHeight);
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
//
//    NSLog(@"aaa=== %@",NSStringFromCGRect(rect));
//    NSLog(@"bbbbb=== %@",NSStringFromCGRect(self.responderView.layer.presentationLayer.frame));
    
}


- (void)keyboardWillHide:(NSNotification *)tf{

    _moveView.transform = CGAffineTransformIdentity;
    [_responderView.window removeGestureRecognizer:_tap];
    _responderView = nil;
    _moveView = nil;
    _caculateView = nil;
    _isToolBar = false;
    _tapClose = true;
    if (_toolBar) {
        self.toolBar.transform = CGAffineTransformIdentity;
        _toolBar.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 40);
        [_toolBar removeFromSuperview];
    }
    self.defaultMargin = 0;
    _nf = nil;
}
- (float)getDefaultMargin{
    return self.defaultMargin?:k_defaultMargin;
}
- (void)setShowView:(UIView *)showView{
    _moveView =showView;
    [_moveView.superview layoutIfNeeded];
}
- (void)click_tool:(UIButton *)btn{
    [self.responderView endEditing:true];
}
- (void)endEditing{
    [self.responderView endEditing:true];
}
- (UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc]init];
        _toolBar.backgroundColor = UIColor.whiteColor;
        _toolBar.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 40);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        btn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
        
        [btn addTarget:self action:@selector(click_tool:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:btn];
        UIView *line = [[UIView alloc]init];
        [_toolBar addSubview:line];
        line.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        line.backgroundColor = UIColor.lightGrayColor;
    }
    return _toolBar;
}


    
@end
