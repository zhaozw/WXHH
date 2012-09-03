//
//  SoundManager.m
//  WXHH
//
//  Created by Chen Weigang on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameAudio.h"



static GameAudio *instance;

BOOL fEnableMusic = YES;
BOOL fEnableSoundEffect = YES;
BOOL fEnableFade = YES;
NSTimer *timerFade;

static AVAudioPlayer *bgMusicPlayer;
static AVAudioPlayer *betSoundEffect;


@implementation GameAudio

+ (GameAudio *)sharedInstance
{
    @synchronized(self)
    {
        if (instance==nil) {
            instance = [[GameAudio alloc] init];
        }
    }
    
    return instance;
}

+ (BOOL)isMusicEnable
{
    return fEnableMusic;
}

+ (BOOL)isSoundEffectEnable
{
    return fEnableSoundEffect;
}

+ (BOOL)isFadeEnable
{
    return fEnableFade;
}

# pragma mark - bg music 

+ (void)enableMusic:(BOOL)enable
{
    if (enable!=fEnableMusic) {
        fEnableMusic = enable;
    }
    
    if (!fEnableMusic) {
        [GameAudio stopBgMusic];
    }
}

+ (AVAudioPlayer *)playBgMusic:(NSString *)filename
{
    return [GameAudio playBgMusic:filename times:0];
}

+ (AVAudioPlayer *)playBgMusic:(NSString *)filename times:(int)times
{
    return [GameAudio playBgMusic:filename times:times startAt:0];
}

+ (AVAudioPlayer *)audioPlayerByName:(NSString *)filename
{
    NSArray *arr = [filename componentsSeparatedByString:@"."];
    
    assert([arr count]==2);
    
    NSString *prefix = [arr objectAtIndex:0];
    NSString *suffix = [arr objectAtIndex:1];
    NSString *path =[[NSBundle mainBundle] pathForResource:prefix ofType:suffix inDirectory:@"/"];
    NSURL *url = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
    
    NSError *error;
    AVAudioPlayer *av = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];

    if (av==nil) {
        NSLog(@"AVAudioPlayer filename = %@ error = %@", filename, [error localizedDescription]);
    }
    return av;
}

+ (AVAudioPlayer *)playBgMusic:(NSString *)filename times:(int)times startAt:(float)startTime
{    
    if (!fEnableMusic) {
        return nil;
    }
    
    if (bgMusicPlayer!=nil) {
        [bgMusicPlayer stop];
        [bgMusicPlayer release];
    }
    bgMusicPlayer = [[GameAudio audioPlayerByName:filename] retain];        
    bgMusicPlayer.numberOfLoops = times;
    bgMusicPlayer.currentTime = startTime;
    
    if (fEnableFade) {
        [timerFade invalidate];
        [timerFade release];
        bgMusicPlayer.volume = 0;
        timerFade = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(bgMusicVolumeFadeIn) userInfo:nil repeats:YES] retain];
        [timerFade fire];
    }
    else {        
        bgMusicPlayer.volume = 1.f;
    }
    
    if ([bgMusicPlayer prepareToPlay]) {
        [bgMusicPlayer play];
    }
    
    return bgMusicPlayer;
}

+ (void)stopBgMusic
{
    if (fEnableFade) {      
        if ([bgMusicPlayer isPlaying]) {            
            [timerFade invalidate];
            [timerFade release];
            timerFade = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(bgMusicVolumeFadeOut) userInfo:nil repeats:YES] retain];
            [timerFade fire];
        }        
    }
    else {        
        [bgMusicPlayer stop];
    }
}


+ (BOOL)isBgMusicPlaying
{
    return [bgMusicPlayer isPlaying];
}

+ (void)enableFade:(BOOL)enable
{
    fEnableFade = enable;
}

+ (void)bgMusicVolumeFadeIn
{
    NSLog(@"bgMusicVolumeFadeIn volume = %f", bgMusicPlayer.volume);

    // 声音渐强
    if (bgMusicPlayer.volume < 1.0) {
        bgMusicPlayer.volume = MIN(1.0, bgMusicPlayer.volume + 0.1);
    }
    else {
        [timerFade invalidate];
        [timerFade release], timerFade = nil;
    }
}

+ (void)bgMusicVolumeFadeOut
{
    NSLog(@"bgMusicVolumeFadeOut volume = %f", bgMusicPlayer.volume);
    // 声音渐弱
    if (bgMusicPlayer.volume > 0) {
        bgMusicPlayer.volume = MAX(0, bgMusicPlayer.volume - 0.1);        
    } else { // 停止
        [bgMusicPlayer stop];
        [timerFade invalidate];
        [timerFade release], timerFade = nil;
    }
}

# pragma mark - sound effect

+ (void)enableSoundEffect:(BOOL)enable
{
    if (enable!=fEnableSoundEffect) {
        fEnableSoundEffect = enable;
    } 
}

+ (AVAudioPlayer *)playSoundEffect:(NSString *)filename
{
    if (!fEnableSoundEffect) {
        return nil;
    }
    
    AVAudioPlayer *av = [[GameAudio audioPlayerByName:filename] retain];  
    
    if (av!=nil) {
        av.delegate = [GameAudio sharedInstance];        
    }
    
    if ([av prepareToPlay]) {
        [av play];
    }    
    else {
        [av release];
    }
    
    return av;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player release];
}

+ (AVAudioPlayer *)playBetSoundEffect
{
    if (![betSoundEffect isPlaying]) {
        if (betSoundEffect==nil) {
            betSoundEffect = [[GameAudio audioPlayerByName:@"下注.mp3"] retain];        
        }
        [betSoundEffect play];
    }
    
    return betSoundEffect;
}


@end
