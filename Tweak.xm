#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// ============ OFFSETS (remplace par TES valeurs) ============
#define OFFSET_GET_LOCAL_PLAYER    0x00000000
#define OFFSET_GET_PLAYERS_LIST    0x00000000
#define OFFSET_GET_POSITION        0x00000000
#define OFFSET_GET_TEAM            0x00000000
#define OFFSET_GET_ROTATION        0x00000000
#define OFFSET_SET_ROTATION        0x00000000

// ============ VARIABLES ============
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL spinbotEnabled = NO;

static NSMutableArray *allButtons = nil;
static UIButton *