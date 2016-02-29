//
//  AudioPlayer.h
//  XRLrcParse
//
//  Created by xuran on 16/2/29.
//  Copyright © 2016年 X.R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKAudioPlayer.h"

@interface AudioPlayer : STKAudioPlayer

/** 初始化播放器单例，sourceURL为音频的URL，若为本地地址，则播放本地的音频，若为网络的URL，则播放流媒体音频 */
+ (instancetype)sharedAudioPlayer;

/** 播放音频 */
- (void)playAudioWithAudioSourceURL:(NSString *)sourceURL;

@end
