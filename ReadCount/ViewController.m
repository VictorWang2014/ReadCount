//
//  ViewController.m
//  ReadCount
//
//  Created by wangmingquan on 15/6/16.
//  Copyright © 2016年 wangmingquan. All rights reserved.
//

#import "ViewController.h"
#import "ReaderViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, ReaderViewControllerDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.array = [@[@"2016年初级会计实务.pdf", @"网页－2分钟倒计时(可以设置时间)"] copy];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    CGRect fr = _tableView.frame;
    fr.origin.y = 20;
    fr.size.height -= 20;
    _tableView.frame = fr;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aaaaa"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaaaa"];
    }
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2016年初级会计实务" ofType:@"pdf"];
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:readerViewController animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
