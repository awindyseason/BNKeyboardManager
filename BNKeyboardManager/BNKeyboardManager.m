//
//  BNKeyboardManager.m
//  TikBeeStore
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

@property (nonatomic) BOOL hasKeyboradInit;
@property (nonatomic) UIView *toolBar;

@property (nonatomic) BOOL trans;
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
        _trans =true;
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
        NSLog(@"手勢ges=%@ \n other = %@",gestureRecognizer,otherGestureRecognizer);
    UIViewController *vc = [BNKeyboardManager currentController:self.responderView] ;
    if([vc isKindOfClass:UIViewController.class]){
        if([otherGestureRecognizer isEqual:vc.navigationController.interactivePopGestureRecognizer]){
            [self.responderView endEditing:true];
        }
        
    }
    return true;
}
+ (UIViewController *)currentController:(UIView *)view
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [view nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}
- (void)tap:(UITapGestureRecognizer  *)tap{
 
    [tap.view removeGestureRecognizer:tap];
    [_responderView endEditing:true];
    
    
}
- (void)setEnable:(BOOL)enable{
    _enable = enable;
    if (!enable) {
        if (_toolBar) {
            [_toolBar removeFromSuperview];
        }
    }
}
- (void)pan:(UIPanGestureRecognizer  *)pan{
    
    [_pan.view removeGestureRecognizer:_pan];
    [_responderView endEditing:true];
    
    
}
- (void)addKeyboardObserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
}


- (void)textFieldViewDidBeginEditing:(NSNotification*)notification
{
    if (self.enable == false) {
        return;
    }
    UIView *view = notification.object;
    //    if(_responderView && ![_responderView isEqual:view]){
    //        [self transform];
    //        return;
    //    }
    
    //    [self recover];
    if (view) {
        
//        if(_responderView && ![_responderView isEqual:view]){
//            [self recover];
//
//        }
        _responderView = view;
        //        if(b){
        //            [self transform];
        //        }
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
//    if ([view isKindOfClass:UITextView.class]) {
//        [self transform:false];
//    }
    NSLog(@"DidBeginEditing");
}

//- (void)keyboardWillShow:(NSNotification *)nf{
//    NSLog(@"2");
//}

- (void)keyboardChangeFrame:(NSNotification *)nf{
    
    NSLog(@"keyboardChangeFrame");
    if (self.enable == false) {
        return;
    }
    
    //  UIWindow *window = UIApplication.sharedApplication.keyWindow;
    self.hasKeyboradInit = true;
    CGRect r = _keyboardRect;
    _keyboardRect = [nf.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _beginKeyboardRect = [nf.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    float t = [nf.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _time = 0.25;
    //    if(![self.responderView isKindOfClass:UITextView.class]){
    if(t > 0 || r.size.height != _keyboardRect.size.height){
        
        [self transform:true];
    }
}

- (void)transform:(BOOL)changeKeyboard{
    
    if (self.enable == false) {
        return;
    }
    if (!self.responderView.superview) {
        return;
    }
  
    UIView *window = [[BNKeyboardManager currentController:self.responderView] view];
//    UIView *window = nil;
    if(!window){
        window = UIApplication.sharedApplication.keyWindow;
    }
    if (!window) {
        return;
    }
    
    CGRect rect;
    UIView *view;
    [self.responderView layoutIfNeeded];
    
    if (!_moveView) {
      
        _moveView =  window;
        
    }
    view =  _moveView ;
    //    view.transform = CGAffineTransformIdentity;
    float y = view.transform.ty;
    BOOL addToolTransY = [view isEqual:window];
    if(changeKeyboard){
        y = 0;
    }else{

    }
    
    if (_caculcationView) {
        CGRect r = _caculcationView.originRect;
        r.origin.y += y;
        rect = [_caculcationView.superview convertRect:r toView:window];
    }else{
        CGRect r = self.responderView.originRect;
        r.origin.y += y;
        rect = [self.responderView.superview convertRect:r toView:window];
    }
    
    if (rect.size.height == 0) {
        return;
    }
    float toolHeight = self.isToolBar?40:0;

    if (toolHeight > 0) {
        [window addSubview:self.toolBar];
    }
    
    if(!self.hasKeyboradInit){
        return;
    }
    //    float b = CGRectGetMaxY(rect) - self.keyboardRect.origin.y + toolHeight;
    //    NSLog(@"b = %f ,ty = %f",b,y);
    NSLog(@"鍵盤 = %@",NSStringFromCGRect(self.keyboardRect));
    NSLog(@"tf位置 = %@",NSStringFromCGRect(rect));
    NSLog(@"y = %f",view.transform.ty);
    if(changeKeyboard){
        y = view.transform.ty;
    }
    if (CGRectGetMaxY(rect) - y > self.keyboardRect.origin.y - toolHeight) {
        
        float transformY =  self.keyboardRect.origin.y -  CGRectGetMaxY(rect) - toolHeight - [self getDefaultMargin]  ;
        if(changeKeyboard){
            transformY += view.transform.ty;
        }
        
        [UIView animateWithDuration:self.time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, transformY);
//            view.y = transformY;
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
        
        if (!CGRectEqualToRect(self.toolBar.frame, r)) {
            [UIView animateWithDuration:self.time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                view.transform = CGAffineTransformMakeTranslation(0, 0);;
                window.transform = CGAffineTransformMakeTranslation(0, 0);;
                self.toolBar.frame = r;
            } completion:^(BOOL finished) {
            }];
        }
    }
    //
    //    NSLog(@"aaa=== %@",NSStringFromCGRect(rect));
    //    NSLog(@"bbbbb=== %@",NSStringFromCGRect(self.responderView.layer.presentationLayer.frame));
    
}
- (void)keyboardDidShow:(NSNotification *)tf{
    NSLog(@"keyboardDidShow");
 
}
- (void)keyboardDidHide:(NSNotification *)tf{
    _toolBar.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 40);
    
    NSLog(@"keyboardDidHide");
    NSLog(@"%@",_moveView);
  
}

- (void)keyboardWillHide:(NSNotification *)tf{
    if (self.enable == false) {
        return;
    }
    NSLog(@"keyboardWillHide");
    
    [self recover];
}
- (void)recover{
  
    
        _moveView.transform = CGAffineTransformIdentity;
        [_tap.view removeGestureRecognizer:_tap];
        [_pan.view removeGestureRecognizer:_pan];
        
        _responderView = nil;
        _moveView = nil;
        _caculcationView = nil;
        _isToolBar = false;
        _tapClose = true;
        //    if (_toolBar) {
        //        [_toolBar removeFromSuperview];
        //    }
        self.defaultMargin = 0;
   
    
    if (_toolBar) {
        [_toolBar removeFromSuperview];
    }
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


