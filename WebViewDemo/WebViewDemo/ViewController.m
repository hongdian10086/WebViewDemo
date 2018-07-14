//
//  ViewController.m
//  WebViewDemo
//
//  Created by laikidi on 2018/7/13.
//  Copyright © 2018年 Algor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLabelText:) name:@"refreshNotification" object:nil];
    
}
- (void)refreshLabelText:(NSNotification *)no{
    
    self.label.text = no.object;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
