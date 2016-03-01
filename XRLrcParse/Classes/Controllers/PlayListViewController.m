//
//  PlayListViewController.m
//  XRLrcParse
//
//  Created by xuran on 16/3/1.
//  Copyright © 2016年 X.R. All rights reserved.
//

#define FilePathForResource(songName)  [[NSBundle mainBundle] pathForResource:(songName) ofType:nil]

#import "PlayListViewController.h"
#import "PlayerViewController.h"
#import "SongModel.h"

@interface PlayListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray * dataArray;

@end

@implementation PlayListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        SongModel * model1 = [[SongModel alloc] init];
        model1.lrcName = @"你看蓝蓝的天.lrc";
        model1.songURL = FilePathForResource(@"你看蓝蓝的天.mp3");
        model1.songName = @"你看蓝蓝的天 - 杨钰莹";
        
        SongModel * model2 = [[SongModel alloc] init];
        model2.lrcName = @"落花.lrc";
        model2.songURL = FilePathForResource(@"落花.mp3");
        model2.songName = @"落花 - 杨钰莹";
        
        SongModel * model3 = [[SongModel alloc] init];
        model3.lrcName = @"";
        model3.songURL = @"http://202.204.208.83/gangqin/download/music/02/03/02/Track08.mp3";
        model3.songName = @"网络音频";
        
        self.dataArray = @[model1, model2, model3];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"播放列表";
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorColor = [UIColor lightGrayColor];
    self.myTableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    SongModel * model = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.text = model.songName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlayerViewController * playerVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    SongModel * model = self.dataArray[indexPath.row];
    playerVc.song = model;
    [self.navigationController pushViewController:playerVc animated:YES];
}

@end
