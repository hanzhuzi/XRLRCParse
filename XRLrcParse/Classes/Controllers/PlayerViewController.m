//
//  PlayerViewController.m
//  XRLrcParse
//
//  Created by xuran on 16/3/1.
//  Copyright © 2016年 X.R. All rights reserved.
//
/**
 *  歌词解析及动态显示
 *  by X.R
 */

#import "PlayerViewController.h"
#import "LrcParseTool.h"
#import "LrcModel.h"
#import "LrcInfoModel.h"
#import "LrcDisplayCell.h"
#import "AudioPlayer.h"
#import "SongModel.h"

static NSString * const cellID = @"myCellID";
static int const spaceLineNumber = 5; // 空白行数

@interface PlayerViewController ()<UITableViewDataSource, UITableViewDelegate, STKAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray * lrcArray;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) LrcInfoModel * infoModel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISlider *playCtrolSlider;
@property (weak, nonatomic) IBOutlet UILabel *lrcTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lrcAuthorLabel;
@property (nonatomic, strong) AudioPlayer * player;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation PlayerViewController

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
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)setSong:(SongModel *)song
{
    _song = song;
    
    if (_song.lrcName && song.lrcName.length > 0) {
        __weak __typeof(self) weakSelf = self;
        
        [LrcParseTool lrcInfoFromLrcFileWithFileName:song.lrcName completion:^(NSMutableArray *lrcArray, LrcInfoModel *infoModel) {
            weakSelf.lrcArray = lrcArray;
            
            // 为了从中间开始滚动，添加几个空白歌词
            for (NSUInteger i = 0; i < spaceLineNumber; i++) {
                LrcModel * model = [[LrcModel alloc] init];
                model.timeStr = @"0.0";
                model.lrcStr  = @"";
                [weakSelf.lrcArray insertObject:model atIndex:0];
            }
            
            // 取出最后一个歌词
            LrcModel * lastLrc = [weakSelf.lrcArray lastObject];
            
            for (NSUInteger i = 0; i < spaceLineNumber; i++) {
                LrcModel * model = [[LrcModel alloc] init];
                model.timeStr = lastLrc.timeStr;
                model.lrcStr = @"";
                [weakSelf.lrcArray addObject:model];
            }
            
            weakSelf.infoModel = infoModel;
        }];
    }
}

// 开启定时器
- (void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                selector:@selector(updateLrcDisplay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
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
    self.playCtrolSlider.value = self.player.progress;
    [self updateTimeDisplay];
    if (self.lrcArray && self.lrcArray.count > 0) {
        for (NSInteger i = spaceLineNumber - 1; i< self.lrcArray.count - spaceLineNumber; i++) {
            LrcModel * model = self.lrcArray[i];
            if (self.player.progress >= [model.timeStr doubleValue]) {
                [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }
}

// 更新播放按钮
- (void)updatePlayButtonState
{
    if (self.player && self.player.state == STKAudioPlayerStatePlaying) {
        [self.playButton setImage:[UIImage imageNamed:@"pause-red"] forState:UIControlStateNormal];
        [self startTimer];
    }else {
        [self.playButton setImage:[UIImage imageNamed:@"play-red"] forState:UIControlStateNormal];
        [self stopTimer];
    }
}

- (void)updateSlider:(UISlider *)slider
{
    if (self.player) {
        [self.player seekToTime:slider.value];
    }
}

- (void)setupTableView
{
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerNib:[UINib nibWithNibName:@"LrcDisplayCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    self.myTableView.tableFooterView = [[UIView alloc] init];
}

// 秒转换成mm:ss格式的字符串
- (NSString *)timeStrWithSecconds:(double)secconds
{
    int totalMinite = (int)secconds / (60);
    int h = totalMinite / (60);
    int m = totalMinite % (60);
    int s = (int)secconds % (60);
    
    if (h <= 0) {
        return [NSString stringWithFormat:@"%02d:%02d", m, s];
    }else {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    }
}

- (IBAction)preAction:(UIButton *)sender {
    
}

- (IBAction)popBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)playAction:(UIButton *)sender {
    if (self.player && self.player.state == STKAudioPlayerStatePlaying) {
        [self.player pause];
        [self stopTimer];
    }else {
        [self.player resume];
        [self startTimer];
    }
    
    [self updatePlayButtonState];
}

- (IBAction)nextAction:(UIButton *)sender {
    
}

- (void)updateTimeDisplay
{
    self.leftTimeLabel.text = [self timeStrWithSecconds:self.player.progress];
    self.rightTimeLabel.text = [self timeStrWithSecconds:self.player.duration];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.lrcTitleLabel.text = self.infoModel.lrc_title;
    self.lrcAuthorLabel.text = self.infoModel.lrc_autor;
    
    [self.playCtrolSlider setThumbImage:[UIImage imageNamed:@"player-progress-point-h"] forState:UIControlStateNormal];
    self.playCtrolSlider.minimumValue = 0.0;
    [self.playCtrolSlider addTarget:self action:@selector(updateSlider:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupAudioPlayer
{
    self.player = [AudioPlayer sharedAudioPlayer];
    self.player.delegate = self;
    [self.player playAudioWithAudioSourceURL:_song.songURL];
    [self updateTimeDisplay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupUI];
    [self setupAudioPlayer];
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

#pragma mark - STKAudioPlayerDelegate

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId
{
    // 准备完毕，缓冲完成，开始播放
    NSLog(@"开始播放音频");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems
{
    // 取消音频播放
    
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    // 音频缓冲完毕
    NSLog(@"缓冲完毕");
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    // 音频播放完毕
    [self stopTimer];
    [self updatePlayButtonState];
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
    // 前期加载音频信息
    
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    // 播放状态发生变化，准备完毕，开始缓冲音频数据，数据缓冲完成后，开始播放。
    if (state == STKAudioPlayerStateReady) {
        
    }else if (state == STKAudioPlayerStateBuffering) {
        
    }else if (state == STKAudioPlayerStatePlaying) {
        self.playCtrolSlider.maximumValue = audioPlayer.duration;
        [self updateTimeDisplay];
        [self startTimer];
    }else if (state == STKAudioPlayerStatePaused) {
        
    }else if (state == STKAudioPlayerStateRunning) {
        
    }else if (state == STKAudioPlayerStateStopped) {
        
    }
    
    [self updatePlayButtonState];
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    NSLog(@"播放错误");
    [self updatePlayButtonState];
}

@end
