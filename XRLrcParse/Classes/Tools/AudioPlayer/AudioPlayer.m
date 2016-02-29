//
//  AudioPlayer.m
//  XRLrcParse
//
//  Created by xuran on 16/2/29.
//  Copyright © 2016年 X.R. All rights reserved.
//

/**
 *  音频播放
 *  by X.R
 */

#define XR_Player [AudioPlayer sharedAudioPlayer]

#import "AudioPlayer.h"

@implementation AudioPlayer

+ (instancetype)sharedAudioPlayer
{
    static AudioPlayer * player = nil;
    static dispatch_once_t onceToken = 0l;
    
    dispatch_once(&onceToken, ^{
        if (!player) {
            player = [[AudioPlayer alloc] init];
        }
    });
    
    return player;
}

- (void)playAudioWithAudioSourceURL:(NSString *)sourceURL
{
    if (!sourceURL || sourceURL.length == 0) {
        return ;
    }
    NSURL * audioURL = nil;
    if ([sourceURL hasPrefix:@"http://"] || [sourceURL hasPrefix:@"https://"]) {
        audioURL = [NSURL URLWithString:sourceURL];
    }else {
        audioURL = [NSURL fileURLWithPath:sourceURL];
    }
    
    [XR_Player playDataSource:[[XR_Player class] dataSourceFromURL:audioURL]];
}

@end
