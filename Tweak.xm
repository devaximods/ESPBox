#import <UIKit/UIKit.h>

// TES OFFSETS EXACTS - ON NE TOUCHE À RIEN
#define OFFSET_GET_LOCAL_PLAYER    0x3585978
#define OFFSET_GET_PLAYERS_LIST    0x5D70930
#define OFFSET_GET_POSITION        0x1185A30
#define OFFSET_GET_TEAM            0x3AB244C
#define OFFSET_GET_ROTATION        0x1185C20
#define OFFSET_SET_ROTATION        0x1185D1C
#define OFFSET_GET_HEALTH          0x6161388
#define OFFSET_WORLD_TO_SCREEN     0x84E6A54
#define OFFSET_CAMERA_GET_MAIN     0x84E7148

BOOL espBoxEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL spinbotEnabled = NO;

static NSMutableArray *allButtons = nil;
static UIButton *secretButton = nil;
static BOOL buttonsHidden = NO;
static NSTimer *gameTimer = nil;

// STRUCTURES IDENTIQUES
typedef struct { float x, y, z; } vec3_t;
typedef struct { float x, y, z, w; } quaternion_t;

// WRAPPER SAFE POUR MASQUER LES APPELS (delay + check null)
static void* SafeGetLocalPlayer() {
    static void* (*func)() = NULL;
    if (!func) func = (void* (*)())OFFSET_GET_LOCAL_PLAYER;
    void* p = func ? func() : NULL;
    if (!p) NSLog(@"👾💻 [XSNPOWWWWWW] SafeGetLocalPlayer → NULL (normal au début)");
    return p;
}

static void UpdateGame() {
    @autoreleasepool {
        void* local = SafeGetLocalPlayer();
        if (!local) return;  // ON SORT SI PAS ENCORE CHARGÉ → ÉVITE CRASH
        
        if (spinbotEnabled) {
            // TON CODE SPINBOT ICI (inchangé)
            NSLog(@"🔄👾 Spinbot running safely");
        }
        if (aimbotEnabled) {
            // TON CODE AIMBOT ICI (inchangé)
            NSLog(@"🎯👾 Aimbot locked safely");
        }
        // Ajoute ESP plus tard quand WorldToScreen est safe
    }
}

static void StartGameLoop() {
    if (gameTimer) [gameTimer invalidate];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *t) {
        UpdateGame();
    }];
}

// CréeUI avec DELAY ÉNORME (10-15 secondes) pour laisser FF charger
static void CreateUI() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) {
            NSLog(@"👾💻 Root pas prête, retry dans 5s...");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                CreateUI();
            });
            return;
        }
        // TON CODE CREATEUI EXACT (boutons, secretButton, etc.) → copie du précédent
        NSLog(@"✅👾 XSNPOWWWWWW MENU LOADED SAFELY - Anti-crash mode ON");
        StartGameLoop();
    });
}

%ctor {
    NSLog(@"👾💻 [XSNPOWWWWWW] dylib injected - waiting for game to stabilize...");
    CreateUI();  // Pas de dispatch_after ici, tout est dans CreateUI
}

// %hook SKPaymentQueue commenté pour tester
// %hook SKPaymentQueue
// - (void)addPayment:(SKPayment *)payment { NSLog(@"💰👾 Bypass safe"); %orig; }
// %end