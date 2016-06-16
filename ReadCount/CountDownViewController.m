//
//  CountDownViewController.m
//  ReadCount
//
//  Created by wangmingquan on 16/6/16.
//  Copyright © 2016年 wangmingquan. All rights reserved.
//

#import "CountDownViewController.h"

@interface CountDownViewController ()
{
    UILabel *_countDownLabel;
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _countDownLabel.textColor = [UIColor blackColor];
    _countDownLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_countDownLabel];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimer
{
    
}

@end
