//
//  LrcInfoModel.h
//  XRLrcParse
//
//  Created by xuran on 16/2/27.
//  Copyright © 2016年 X.R. All rights reserved.
//

/**
 *  歌词头部信息
 */

#import <Foundation/Foundation.h>

@interface LrcInfoModel : NSObject

@property (nonatomic, copy) NSString * lrc_title;  // 歌曲名称
@property (nonatomic, copy) NSString * lrc_autor;  // 演唱者
@property (nonatomic, copy) NSString * lrc_create; // 歌词制作
@property (nonatomic, copy) NSString * lrc_album;  // 专辑

@end
