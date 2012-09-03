//
//  SoundManager.h
//  WXHH
//
//  Created by Chen Weigang on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface GameAudio : NSObject <AVAudioPlayerDelegate>



+ (void)enableMusic:(BOOL)enable;       // 播放背景音乐 
+ (void)enableSoundEffect:(BOOL)enable; // 播放音效
+ (void)enableFade:(BOOL)enable;        // 开启渐变

+ (BOOL)isMusicEnable;
+ (BOOL)isSoundEffectEnable;
+ (BOOL)isFadeEnable;


// 播放背景音乐，背景音乐永远只有一个
+ (AVAudioPlayer *)playBgMusic:(NSString *)filename; // play once
+ (AVAudioPlayer *)playBgMusic:(NSString *)filename times:(int)times;
+ (AVAudioPlayer *)playBgMusic:(NSString *)filename times:(int)times startAt:(float)startTime;
+ (void)stopBgMusic;
+ (BOOL)isBgMusicPlaying;

// 播放音效，音效可以多个，可叠加
+ (AVAudioPlayer *)playSoundEffect:(NSString *)filename;


// 特殊需求
+ (AVAudioPlayer *)playBetSoundEffect;


@end
