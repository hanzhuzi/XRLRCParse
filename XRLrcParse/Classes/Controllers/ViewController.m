//
//  ViewController.m
//  XRLrcParse
//
//  Created by xuran on 16/2/26.
//  Copyright © 2016年 X.R. All rights reserved.
//

/**
 *  歌词解析及动态显示
 *  by X.R
 */

#import "ViewController.h"
#import "LrcParseTool.h"
#import "LrcModel.h"
#import "LrcDisplayCell.h"

static NSString * const cellID = @"myCellID";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * lrcArray;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) double    seccond;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISlider *playCtrolSlider;

@end

@implementation ViewController

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        _lrcArray = [LrcParseTool lrcInfoFromLrcFileWithFileName:@"lrc.txt"];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _lrcArray = [LrcParseTool lrcInfoFromLrcFileWithFileName:@"lrc.txt"];
    }
    
    return self;
}

// 开启定时器
- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                            selector:@selector(updateLrcDisplay) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

// 关闭定时器
- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/**
 *  更新歌词显示
 */
- (void)updateLrcDisplay
{
    for (NSInteger i = 0; i< self.lrcArray.count - 1; i++) {
        LrcModel * model1 = self.lrcArray[i];
        LrcModel * model2 = self.lrcArray[i+1];
        if (self.seccond >= [model1.timeStr doubleValue] && self.seccond < [model2.timeStr doubleValue]) {
            [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
    self.seccond++;
}

- (void)setupTableView
{
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"LrcDisplayCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    self.myTableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.playCtrolSlider setThumbImage:[UIImage imageNamed:@"player-progress-point-h"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupUI];
    [self startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LrcDisplayCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LrcDisplayCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    LrcModel * model = self.lrcArray[indexPath.row];
    [cell configCellWithLrcModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 开启定时器
    [self startTimer];
}

@end
