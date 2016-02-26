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

@interface ViewController ()

@property (nonatomic, strong) NSArray * lrcArray;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) double    seccond;
@property (weak, nonatomic) IBOutlet UILabel *lrcLabel;

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
            self.lrcLabel.text = model1.lrcStr;
        }else if (self.seccond >= [model2.timeStr doubleValue]) {
            self.lrcLabel.text = model2.lrcStr;
        }
    }
    
    self.seccond++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
