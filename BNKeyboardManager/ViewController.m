//
//  ViewController.m
//  BNKeyboardManager
//
//  Created by Tikbee on 2021/7/29.
//

#import "ViewController.h"
#import "BNKeyboardManager.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *moveView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *textFieldBGView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)test:(id)sender {
    BNKeyboardManager.shared.isToolBar = true;
//    BNKeyboardManager.shared.defaultMargin = 50;
    [self.textField becomeFirstResponder];
}

- (IBAction)test1:(id)sender {
    BNKeyboardManager.shared.isToolBar = true;
    [self.textView becomeFirstResponder];
}

- (IBAction)test2:(id)sender {

    BNKeyboardManager.shared.caculcationView = self.textFieldBGView;
    
    [self.textView becomeFirstResponder];
    
}
- (IBAction)test3:(id)sender {
//    if (BNKeyboardManager.shared.isFirstResponder) {
//        [BNKeyboardManager.shared endEditing];
//        return;
//    }
    // 测试moveView
    BNKeyboardManager.shared.caculcationView = _moveView;
    BNKeyboardManager.shared.moveView = _moveView;
    [self.textField becomeFirstResponder];
}
- (IBAction)test4:(id)sender {
    // 测试 textField的背景view
    BNKeyboardManager.shared.moveView = _textFieldBGView;
    [self.textField becomeFirstResponder];
    
}

@end
