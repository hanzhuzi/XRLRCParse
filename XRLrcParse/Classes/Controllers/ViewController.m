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
#import "LrcInfoModel.h"
#import "LrcDisplayCell.h"

static NSString * const cellID = @"myCellID";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * lrcArray;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) double    seccond;
@property (nonatomic, strong) LrcInfoModel * infoModel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISlider *playCtrolSlider;
@property (weak, nonatomic) IBOutlet UILabel *lrcTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lrcAuthorLabel;

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
        __weak __typeof(self) weakSelf = self;
        
        [LrcParseTool lrcInfoFromLrcFileWithFileName:@"lrc.txt" completion:^(NSMutableArray *lrcArray, LrcInfoModel *infoModel) {
            weakSelf.lrcArray = lrcArray;
            weakSelf.infoModel = infoModel;
        }];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        __weak __typeof(self) weakSelf = self;
        
        [LrcParseTool lrcInfoFromLrcFileWithFileName:@"lrc.txt" completion:^(NSMutableArray *lrcArray, LrcInfoModel *infoModel) {
            weakSelf.lrcArray = lrcArray;
            
            // 为了从中间开始滚动，添加几个空白歌词
            for (NSUInteger i = 0; i < 4; i++) {
                LrcModel * model = [[LrcModel alloc] init];
                model.timeStr = @"0.0";
                model.lrcStr  = @"";
                [weakSelf.lrcArray insertObject:model atIndex:0];
            }
            
            weakSelf.infoModel = infoModel;
        }];
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
    
    self.lrcTitleLabel.text = self.infoModel.lrc_title;
    self.lrcAuthorLabel.text = self.infoModel.lrc_autor;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
