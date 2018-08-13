
#import "AudioUtils.h"


static AudioUtils *sheardUtils = nil;

@implementation AudioUtils
- (void)dealloc
{
    self.audioPlayer.delegate = nil;
    self.audioPlayer = nil;
}

+ (instancetype)sheardAudioUtils{

    if (nil==sheardUtils) {
        sheardUtils = [[AudioUtils alloc] init];
    }
    return sheardUtils;
}


- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
        
        if (nil==self.audioPlayer) {
            
            
        }
    }
    return self;
}

+ (void)stop{

    AudioUtils *utils = [AudioUtils sheardAudioUtils];
    if (utils.audioPlayer) {
        [utils.audioPlayer pause];
        utils.audioPlayer = nil;
    }
    
}

+ (void)playSoundType:(SoundType) type loopCount:(NSInteger)loop{
    
//    return;
    [AudioUtils soundNameWithType:type];
    [AudioUtils stop];
    AudioUtils *utils = [AudioUtils sheardAudioUtils];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    // Gets the file system path to the sound to play.
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:[AudioUtils soundNameWithType:type] ofType:nil];
    // Converts the sound's file path to an NSURL object
    
    if (soundFilePath) {
        NSURL *soundURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        utils.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundURL error:nil];
        [utils.audioPlayer prepareToPlay];
        // set it up and play
        [utils.audioPlayer setNumberOfLoops:loop];
        [utils.audioPlayer setDelegate:utils];
        [utils.audioPlayer play];
    }
}

+ (NSString *)soundNameWithType:(SoundType)type{
    /*
     SoundTypeStart = 0,
     SoundTypeMoreItem,
     SoundTypePanicSuccess,
     SoundTypeMore,
     SoundTypeMenuOpen,
     SoundTypeMenuClose,
     SoundTypeShare,
     SoundTypeHeartbeat,
     SoundTypePush,
     */
    NSString *soundName = nil;
    switch (type) {
        case SoundTypeStart:
            soundName = @"shake.wav";
            break;
        case SoundTypeMoreItem:
            soundName = @"详情功能选中item.aif";
            break;
        case SoundTypePanicSuccess:
            soundName = @"抢购成功.aif";
            break;
        case SoundTypeMore:
            soundName = @"详情功能按钮.aif";
            break;
        case SoundTypeMenuOpen:
            soundName = @"主页按钮打开.aif";
            break;
        case SoundTypeMenuClose:
            soundName = @"主页按钮收起.aif";
            break;
        case SoundTypeShare:
            soundName = @"分享按钮点击.aif";
            break;
        case SoundTypeHeartbeat:
            soundName = @"抢购心跳.mp3";
            break;
        case SoundTypePush:
            soundName = @"4085.mp3";
            break;
            case SoundTypeAddAlert:
            soundName = @"零元抢购添加闹铃.aif";
            break;
        default:
            break;
    }
    return soundName;
}
@end
