//
//  MUSAudioTool.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSAudioTool.h"

@implementation MUSAudioTool

+ (AVAudioPlayer *)audioPlayerWithURL:(NSURL *)url
{
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        return nil;
    }
    
    player.enableRate = YES;
    [player prepareToPlay];
    
    return player;
}


+ (void)playSoundWithURL:(NSURL *)url isAlert:(BOOL)isAlert completion:(void(^)())completion
{
    //强制转换
    CFURLRef ref = (__bridge CFURLRef)url;
    
    //给指针
    SystemSoundID soundId = 0;
    
    //创建音频指针
    AudioServicesCreateSystemSoundID(ref, &soundId);
    
    
    if (!isAlert) {
        
        AudioServicesPlaySystemSoundWithCompletion(soundId, ^{
           
            //释放
            AudioServicesDisposeSystemSoundID(soundId);
            
            !completion ?: completion();
            
        });
    }else
    {
        AudioServicesPlayAlertSoundWithCompletion(soundId, ^{
            //释放
            AudioServicesDisposeSystemSoundID(soundId);
            //通知外界
            !completion ?: completion();
        });
    }
    
}

+ (void)initialize
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    ///后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    ///激活会话
    [session setActive:YES error:nil];
    
    
    
}

@end
