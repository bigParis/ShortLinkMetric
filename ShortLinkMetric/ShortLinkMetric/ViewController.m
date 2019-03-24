//
//  ViewController.m
//  ShortLinkMetric
//
//  Created by yy on 2019/3/24.
//  Copyright © 2019年 BP. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, weak) UIButton *startBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)initViews
{
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setBackgroundColor:[UIColor redColor]];
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(onStartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.startBtn = startBtn;
    [self.view addSubview:startBtn];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.startBtn.frame = CGRectMake((self.view.bounds.size.width - 200) * 0.5, 100, 200, 50);
}

- (void)onStartBtnClicked:(UIButton *)sender
{
    [self download];
}

- (void)download
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    NSURL *url = [NSURL URLWithString:@"http://sznk.fcloud.store.qq.com/store_raw_download?buid=16821&uuid=b4c539a7ae1741cdb9950cbcde77030c&fsname=CourseTeacher_1.2.4.2_DailyBuild.dmg"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    [dataTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingPathComponent:dataTask.response.suggestedFilename];
    [[NSFileManager defaultManager] createFileAtPath:fullPath contents:nil attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:fullPath];
    NSLog(@"开始下载，文件路径:%@", fullPath);
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    NSLog(@"下载完成");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.fileHandle writeData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    NSLog(@"统计结果来了");
}

@end
