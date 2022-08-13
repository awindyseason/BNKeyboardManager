//
//  BNKeyboardManager.m
//  BNKeyboardManager
//
//  Created by yh on 2020/7/17.
//  Copyright © 2020 TikBee. All rights reserved.
//

#import "BNKeyboardManager.h"
#define k_defaultMargin 10
@interface BNKeyboardManager()<UIGestureRecognizerDelegate>
@property (nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic) UITapGestureRecognizer *tap;
//@property (nonatomic) CGRect originRect;
@property (nonatomic) CGRect keyboardRect;
@property (nonatomic) CGRect beginKeyboardRect;
@property (nonatomic) CGFloat time;


@property (nonatomic) UIView *toolBar;
//@property (nonatomic) UIView *tapView;
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
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        _pan.delegate = self;
        // 優先響應pan 取消其他touch
//        _pan.cancelsTouchesInView = false;
        _pan.delaysTouchesBegan = true;
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        _tap.cancelsTouchesInView = false;
    
        _tapClose = true;
        [self toolBar];
        [self addKeyboardObserver];
        
    }
    return self;
}

- (void)start{
    self.enable = true;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    NSLog(@"手勢");
    return true;
}
- (void)tap:(UITapGestureRecognizer  *)tap{

    [tap.view removeGestureRecognizer:tap];
    [_responderView endEditing:true];

    
}
- (void)pan:(UIPanGestureRecognizer  *)pan{

    [_pan.view removeGestureRecognizer:_pan];
    [_responderView endEditing:true];

    
}
- (void)addKeyboardObserver{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
}


-(void)textFieldViewDidBeginEditing:(NSNotification*)notification
{
    if (self.enable == false) {
        return;
    }
    UIView *view = notification.object;
    if (view) {
        _responderView = view;
    }
    if (_tapClose) {

//        [_tapView removeFromSuperview];
//        _tapView = [[UIView alloc]init];
////        _tapView.userInteractionEnabled = false;
//        // tap失效问题  需- 1
//        _tapView.frame = CGRectMake(40, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT-1);
        //    _tapView.frame = self.bounds;
        [_responderView.window addGestureRecognizer:_pan];
        [_responderView.window addGestureRecognizer:_tap];
//        [_responderView.superview.superview.superview insertSubview:_tapView atIndex:0];
//        _tap.delegate = _tapView;
//        [_tapView addGestureRecognizer:_tap];
//        [_responderView.window addGestureRecognizer:_tap];
    }
    if ([view isKindOfClass:UITextView.class]) {
        [self transform];
    }
    NSLog(@"1");
}

//- (void)keyboardWillShow:(NSNotification *)nf{
//    NSLog(@"2");
//}

- (void)keyboardChangeFrame:(NSNotification *)nf{
    NSLog(@"3");
    if (self.enable == false) {
        return;
    }
//    NSLog(@"%@--%f",NSStringFromCGRect(_keyboardRect),value);
//    UIWindow *window = UIApplication.sharedApplication.keyWindow;

    _keyboardRect = [nf.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _beginKeyboardRect = [nf.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    _time = [nf.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _time = 0.25;
//    if(![self.responderView isKindOfClass:UITextView.class]){
        [self transform];
//    }
}
- (void)transform{
    if (!self.responderView.superview) {
        return;
    }
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    if (!window) {
        return;
    }
    
    CGRect rect;
    UIView *view;
    [self.responderView layoutIfNeeded];
    if (_moveView) {
        view =  _moveView ;
    }else{
        
        view =  window;
        _moveView = view;
    }
  
//    view.transform = CGAffineTransformIdentity;
    if (_caculcationView) {
        rect = [_caculcationView.superview convertRect:_caculcationView.originRect toView:window];
    }else{
     
        rect = [self.responderView.superview convertRect:self.responderView.originRect toView:window];
    }

    if (rect.size.height == 0) {
        return;
    }
    float toolHeight = self.isToolBar?40:0;
    BOOL addToolTransY = [view isEqual:window];
    if (toolHeight > 0) {
        [window addSubview:self.toolBar];
//        self.toolBar.frame = CGRectMake(self.beginKeyboardRect.origin.x,SCREEN_HEIGHT - self.beginKeyboardRect.size.height - toolHeight , SCREEN_WIDTH, toolHeight);
        
    }
   
    
    if (CGRectGetMaxY(rect) > self.keyboardRect.origin.y - toolHeight) {
        float transformY =  self.keyboardRect.origin.y -  CGRectGetMaxY(rect) - toolHeight - [self getDefaultMargin];
        [UIView animateWithDuration:self.time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, transformY);
            if (toolHeight > 0) {
                
                if (addToolTransY) {
                    self.toolBar.frame = CGRectMake(0,SCREEN_HEIGHT - self.keyboardRect.size.height - transformY - toolHeight , SCREEN_WIDTH, toolHeight);
                }else{
                    
                    self.toolBar.frame = CGRectMake(0,SCREEN_HEIGHT - self.keyboardRect.size.height  - toolHeight , SCREEN_WIDTH, toolHeight);
                }
            }
        } completion:^(BOOL finished) {

        }];
    }else{
        CGRect r = CGRectMake(0,SCREEN_HEIGHT - self.keyboardRect.size.height - toolHeight , SCREEN_WIDTH, toolHeight);;
//        NSLog(@"%@\n%@",NSStringFromCGRect(self.keyboardRect),NSStringFromCGRect(self.toolBar.frame));
        if (!CGRectEqualToRect(self.toolBar.frame, r)) {
            [UIView animateWithDuration:self.time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.toolBar.frame = r;
            } completion:^(BOOL finished) {
            }];
        }
    }
//
//    NSLog(@"aaa=== %@",NSStringFromCGRect(rect));
//    NSLog(@"bbbbb=== %@",NSStringFromCGRect(self.responderView.layer.presentationLayer.frame));
    
}

- (void)keyboardDidHide:(NSNotification *)tf{
    _toolBar.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 40);
}

- (void)keyboardWillHide:(NSNotification *)tf{
    if (self.enable == false) {
        return;
    }
//    NSLog(@"end");
//    [_moveView.layer removeAllAnimations];
    _moveView.transform = CGAffineTransformIdentity;
    [_tap.view removeGestureRecognizer:_tap];
    [_pan.view removeGestureRecognizer:_pan];
    _responderView = nil;
    _moveView = nil;
    _caculcationView = nil;
    _isToolBar = false;
    _tapClose = true;
    if (_toolBar) {
        [_toolBar removeFromSuperview];
    }
    self.defaultMargin = 0;
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
        line.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
    }
    return _toolBar;
}


    
@end


