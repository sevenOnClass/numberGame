//
//  ViewController.m
//  猜数字
//
//  Created by 庄琦 on 15/11/25.
//  Copyright © 2015年 Seven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)btnClick:(id)sender;
@property(weak, nonatomic) IBOutlet UITextField *textField;
//系统的答案
@property(nonatomic, strong) NSArray *answer;
@property(nonatomic, copy) NSString *answerStr;
@property (nonatomic, strong) NSMutableArray *lableArray;
//用户的答案
@property(nonatomic, copy) NSString *userStr;
//用户答案提示结果
@property(nonatomic, copy) NSString *currentResult;
//游戏进行的次数
@property(nonatomic, assign) NSInteger resultCount;
- (IBAction)textValueChanged:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

}

-(NSMutableArray *)lableArray{
    if (!_lableArray) {
        _lableArray = [NSMutableArray array];
    }
    return _lableArray;
}
- (NSArray *)answer {
  if (!_answer) {
    _answerStr = @"";
    NSMutableArray *answer = [NSMutableArray array];

    do {
      NSInteger tempAnswer = arc4random() % 9 + 1;
      NSString *str = [NSString stringWithFormat:@"%ld", tempAnswer];
      if (![answer containsObject:str]) {
          _answerStr = [_answerStr stringByAppendingString:str];
        [answer addObject:str];
      }

    } while (answer.count != 4);
    _answer = answer;
  }
  return _answer;
}

- (IBAction)textValueChanged:(id)sender {
  if (self.textField.text.length == 4) {
    [self.view endEditing:YES];
    _userStr = @"";
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSInteger num = [self.textField.text integerValue];
    NSInteger temp = 0;
    for (int i = 0; i < 4; ++i) {
      temp = num % 10;
      NSString *tempStr = [NSString stringWithFormat:@"%ld", temp];
      [mutableArray addObject:tempStr];
      num = num / 10;
    }
    NSArray *array = [[mutableArray reverseObjectEnumerator] allObjects];
    for (int i = 0; i < array.count; ++i) {
      _userStr = [_userStr stringByAppendingString:array[i]];
    }
    //这个时候比较会重新生成self.answer
    [self compareWithArray:array andOtherArray:self.answer];
        NSLog(@"%@", self.answer);
//    NSLog(@"%@", self.currentResult);
    [self showResult];
  }
}

- (void)showResult {
  self.resultCount++;
  if (self.resultCount <= 8) {
    UILabel *label = [[UILabel alloc] init];
    float x = 20 + (self.resultCount - 1) % 2 * (150 + 20);
    float y = 300 + (self.resultCount - 1) / 2 * (30 + 20);
    [label setFrame:CGRectMake(x, y, 150, 40)];
    label.text = [NSString stringWithFormat:@"%ld次 %@ %@", self.resultCount,
                                            _userStr, _currentResult];
    [label setBackgroundColor:
               [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0)
                               green:((float)arc4random_uniform(256) / 255.0)
                                blue:((float)arc4random_uniform(256) / 255.0)
                               alpha:1.0]];
    [self.view addSubview:label];
      //添加入数组
      [self.lableArray addObject:label];
    if ([self.currentResult isEqualToString:@"AAAA"]) {
      UIAlertController *alert = [UIAlertController
          alertControllerWithTitle:@"恭喜你猜中"
                           message:[NSString
                                       stringWithFormat:@"答案是%@",
                                                        _answerStr]
                    preferredStyle:UIAlertControllerStyleActionSheet];
      UIAlertAction *action =
          [UIAlertAction actionWithTitle:@"完成"
                                   style:UIAlertActionStyleDefault
                                 handler:nil];

      [alert addAction:action];
      [self presentViewController:alert animated:YES completion:nil];
    }
  } else {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"很遗憾"
                         message:[NSString
                                     stringWithFormat:@"正确答案是%@",
                                                      _answerStr]
                  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action =
        [UIAlertAction actionWithTitle:@"完成"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

- (void)compareWithArray:(NSArray *)array1 andOtherArray:(NSArray *)array2 {
  NSInteger countA = 0;
  NSInteger countB = 0;
  for (int i = 0; i < 4; ++i) {
    for (int j = 0; j < 4; ++j) {
      if ([array2[j] isEqualToString:array1[i]]) {
        if (i == j) {
          countA++;
        } else {
          countB++;
        }
      }
    }
  }
  NSString *str = @"";
  for (int i = 0; i < countA; ++i) {
    str = [str stringByAppendingString:@"A"];
  }
  for (int i = 0; i < countB; ++i) {
    str = [str stringByAppendingString:@"B"];
  }

  self.currentResult = str;
}

- (IBAction)btnClick:(id)sender {
    self.answer = nil;
    for (UILabel *lable in self.lableArray) {
        [lable removeFromSuperview];
    }
    [self.lableArray removeAllObjects];
    self.resultCount = 0;
    self.textField.text = @"";
}
@end
