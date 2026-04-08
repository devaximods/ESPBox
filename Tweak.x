#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// ============ OFFSETS (à ajuster selon ton dump) ============
#define OFFSET_GET_PLAYERS      0x59D7AC4
#define OFFSET_GET_LOCAL_PLAYER 0x65BA5E8
#define OFFSET_GET_TRANSFORM    0x628EE64

// ============ STRUCTURES ============
typedef struct {
    float x;
    float y;
    float z;
} vec3_t;

// ============ FONCTIONS DE LECTURE ============

static void* GetLocalPlayer() {
    void* (*func)() = (void* (*)())OFFSET_GET_LOCAL_PLAYER;
    return func();
}

static void** GetPlayersList(int *count) {
    void** (*func)(int*) = (void** (*)(int*))OFFSET_GET_PLAYERS;
    return func(count);
}

static void* GetTransform(void* player) {
    void* (*func)(void*) = (void* (*)(void*))OFFSET_GET_TRANSFORM;
    return func(player);
}

static vec3_t GetPositionFromTransform(void* transform) {
    vec3_t pos;
    pos.x = *(float*)((uintptr_t)transform + 0x40);
    pos.y = *(float*)((uintptr_t)transform + 0x44);
    pos.z = *(float*)((uintptr_t)transform + 0x48);
    return pos;
}

static vec3_t GetPlayerPosition(void* player) {
    void* transform = GetTransform(player);
    if (transform) {
        return GetPositionFromTransform(transform);
    }
    vec3_t zero = {0,0,0};
    return zero;
}

// ============ RADAR ============
static UIView *radarView = nil;

static void SetupRadar() {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (radarView) return;
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) return;
        
        CGFloat size = 150;
        CGFloat x = [UIScreen mainScreen].bounds.size.width - size - 10;
        CGFloat y = [UIScreen mainScreen].bounds.size.height - size - 10;
        
        radarView = [[UIView alloc] initWithFrame:CGRectMake(x, y, size, size)];
        radarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        radarView.layer.cornerRadius = size / 2;
        radarView.layer.borderWidth = 2;
        radarView.layer.borderColor = [UIColor whiteColor].CGColor;
        radarView.clipsToBounds = YES;
        radarView.userInteractionEnabled = NO;
        
        // Point central (toi)
        UIView *centerDot = [[UIView alloc] initWithFrame:CGRectMake(size/2 - 3, size/2 - 3, 6, 6)];
        centerDot.backgroundColor = [UIColor cyanColor];
        centerDot.layer.cornerRadius = 3;
        [radarView addSubview:centerDot];
        
        [keyWindow addSubview:radarView];
    });
}

static void UpdateRadar() {
    if (!radarView) return;
    
    void* localPlayer = GetLocalPlayer();
    if (!localPlayer) return;
    
    vec3_t localPos = GetPlayerPosition(localPlayer);
    
    int playerCount = 0;
    void** players = GetPlayersList(&playerCount);
    if (!players || playerCount == 0) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Supprimer les anciens points (sauf le centre)
        for (UIView *subview in radarView.subviews) {
            if (subview.tag == 999) {
                [subview removeFromSuperview];
            }
        }
        
        float radarSize = 150;
        float center = radarSize / 2;
        float scale = 10.0f;
        
        for (int i = 0; i < playerCount; i++) {
            void* player = players[i];
            if (!player || player == localPlayer) continue;
            
            vec3_t pos = GetPlayerPosition(player);
            
            float dx = pos.x - localPos.x;
            float dz = pos.z - localPos.z;
            float distance = sqrt(dx*dx + dz*dz);
            
            if (distance > 40) continue;
            if (distance < 0.5) continue;
            
            float radarX = center + (dx / scale);
            float radarY = center + (dz / scale);
            
            if (radarX > 5 && radarX < radarSize-5 && radarY > 5 && radarY < radarSize-5) {
                UIView *enemyDot = [[UIView alloc] initWithFrame:CGRectMake(radarX-3, radarY-3, 6, 6)];
                enemyDot.backgroundColor = [UIColor redColor];
                enemyDot.layer.cornerRadius = 3;
                enemyDot.tag = 999;
                [radarView addSubview:enemyDot];
            }
        }
    });
}

// ============ HOOK ============
%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        SetupRadar();
    });
    
    // Mettre à jour le radar toutes les 0.1 secondes
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     repeats:YES
                                       block:^(NSTimer *timer) {
                                           UpdateRadar();
                                       }];
    return result;
}

%end

// Hook pour recréer le radar si l'écran tourne
%hook UIWindow

- (void)layoutSubviews {
    %orig;
    if (radarView) {
        [radarView removeFromSuperview];
        radarView = nil;
        SetupRadar();
    }
}

%end