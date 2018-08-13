

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>


typedef enum {
    
    SoundTypeStart = 0,
    SoundTypeMoreItem,
    SoundTypePanicSuccess,
    SoundTypeMore,
    SoundTypeMenuOpen,
    SoundTypeMenuClose,
    SoundTypeShare,
    SoundTypeHeartbeat,
    SoundTypePush,
    SoundTypeAddAlert
}SoundType;


@interface AudioUtils : NSObject<AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

+ (instancetype)sheardAudioUtils;

+ (void)stop;
+ (void)playSoundType:(SoundType) type loopCount:(NSInteger)loop;
+ (NSString *)soundNameWithType:(SoundType)type;
@end
