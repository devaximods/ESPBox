#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// ============ TES OFFSETS (AUCUN CHANGEMENT) ============
#define OFFSET_GET_LOCAL_PLAYER    0x3585978
#define OFFSET_GET_PLAYERS_LIST    0x5D70930
#define OFFSET_GET_POSITION        0x1185A30
#define OFFSET_GET_TEAM            0x3AB244C
#define OFFSET_GET_ROTATION        0x1185C20
#define OFFSET_SET_ROTATION        0x1185D1C
#define OFFSET_GET_HEALTH          0x6161388
#define OFFSET_WORLD_TO_SCREEN     0x84E6A54
#define OFFSET_CAMERA_GET_MAIN     0x84E7148

// ============ VARIABLES ============
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL spinbotEnabled = NO;

static NSMutableArray *allButtons = nil;
static UIButton *secretButton = nil;
static __unused BOOL buttonsHidden = NO;
static NSTimer *gameTimer = nil;

static BOOL isFreeFire = NO;
static BOOL cheatsEnabled = NO;

// ============ STRUCTURES ============
typedef struct { float x; float y; float z; } vec3_t;
typedef struct { float x; float y; float z; float w; } quaternion_t;

// ============ RESET GUEST (version encore plus agressive) ============
static void resetGuestAccount() {
    NSLog(@"👾💻 [XSNPOWWWWWW] RESET GUEST FULL FORCE démarré");
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:bundleID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Documents
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if (documents) [[NSFileManager defaultManager] removeItemAtPath:documents error:nil];
    
    // Library
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    if (library) [[NSFileManager defaultManager] removeItemAtPath:library error:nil];
    
    // Caches
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    if (caches) [[NSFileManager defaultManager] removeItemAtPath:caches error:nil];
    
    // Garena/Free Fire dossiers spécifiques
    if (documents) {
        NSString *garena = [documents stringByAppendingPathComponent:@"Garena"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:garena]) {
            [[NSFileManager defaultManager] removeItemAtPath:garena error:nil];
        }
        NSString *ff = [documents stringByAppendingPathComponent:@"com.garena.game.ff"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:ff]) {
            [[NSFileManager defaultManager] removeItemAtPath:ff error:nil];
        }
    }
    
    NSLog(@"👾💻 [XSNPOWWWWWW] RESET GUEST terminé - toutes les données invité supprimées");
    exit(0);
}

// ============ WRAPPERS SAFE (encore plus prudent) ============
static void* SafeGetLocalPlayer() {
    if (!isFreeFire || !cheatsEnabled) return NULL;
    static void* (*func)() = NULL;
    if (!func) func = (void* (*)())OFFSET_GET_LOCAL_PLAYER;
    return func ? func() : NULL;
}

static void** SafeGetPlayersList(int *count) {
    if (!isFreeFire || !cheatsEnabled) return NULL;
    static void** (*func)(int*) = NULL;
    if (!func) func = (void** (*)(int*))OFFSET_GET_PLAYERS_LIST;
    return func ? func(count) : NULL;
}

static vec3_t SafeGetPosition(void* player) {
    if (!isFreeFire || !cheatsEnabled || !player) return (vec3_t){0,0,0};
    static vec3_t (*func)(void*) = NULL;
    if (!func) func = (vec3_t (*)(void*))OFFSET_GET_POSITION;
    return func ? func(player) : (vec3_t){0,0,0};
}

static int SafeGetTeam(void* player) {
    if (!isFreeFire || !cheatsEnabled || !player) return 0;
    static int (*func)(void*) = NULL;
    if (!func) func = (int (*)(void*))OFFSET_GET_TEAM;
    return func ? func(player) : 0;
}

static quaternion_t SafeGetRotationQuat(void* player) {
    if (!isFreeFire || !cheatsEnabled || !player) return (quaternion_t){0,0,0,1};
    static quaternion_t (*func)(void*) = NULL;
    if (!func) func = (quaternion_t (*)(void*))OFFSET_GET_ROTATION;
    return func ? func(player) : (quaternion_t){0,0,0,1};
}

static void SafeSetRotationQuat(void* player, quaternion_t rot) {
    if (!isFreeFire || !cheatsEnabled || !player) return;
    static void (*func)(void*, quaternion_t) = NULL;
    if (!func) func = (void (*)(void*, quaternion_t))OFFSET_SET_ROTATION;
    if (func) func(player, rot);
}

static float QuaternionToYaw(quaternion_t q) {
    float yaw = atan2(2.0f * (q.y * q.w + q.x * q.z), 1.0f - 2.0f * (q.y * q.y + q.x * q.x));
    return yaw * 180.0f / M_PI;
}

static quaternion_t YawToQuaternion(float yaw) {
    float rad = yaw * M_PI / 180.0f;
    float halfRad = rad / 2.0f;
    quaternion_t q;
    q.x = 0.0f;
    q.y = (float)sin(halfRad);
    q.z = 0.0f;
    q.w = (float)cos(halfRad);
    return q;
}

// ============ UPDATE GAME (delay très long + protection) ============
static void UpdateGame() {
    if (!isFreeFire || !cheatsEnabled) return;
    static int delayCounter = 0;
    delayCounter++;
    if (delayCounter < 200) return;   // ~10 secondes avant de toucher la mémoire
    
    @autoreleasepool {
        void* localPlayer = SafeGetLocalPlayer();
        if (!localPlayer) return;
        
        if (spinbotEnabled) {
            quaternion_t rot = SafeGetRotationQuat(localPlayer);
            float yaw = QuaternionToYaw(rot);
            yaw += 30.0f;
            SafeSetRotationQuat(localPlayer, YawToQuaternion(yaw));
        }
        else if (aimbotEnabled) {
            vec3_t localPos = SafeGetPosition(localPlayer);
            int localTeam = SafeGetTeam(localPlayer);
            quaternion_t localRot = SafeGetRotationQuat(localPlayer);
            float currentYaw = QuaternionToYaw(localRot);
            
            int playerCount = 0;
            void** players = SafeGetPlayersList(&playerCount);
            if (!players) return;
            
            float closestAngle = 360.0f;
            vec3_t closestEnemyPos = {0,0,0};
            int found = 0;
            
            for (int i = 0; i < playerCount && i < 50; i++) {
                void* player = players[i];
                if (!player || player == localPlayer) continue;
                if (SafeGetTeam(player) == localTeam) continue;
                
                vec3_t enemyPos = SafeGetPosition(player);
                float dx = enemyPos.x - localPos.x;
                float dz = enemyPos.z - localPos.z;
                float angle = atan2(dz, dx) * 180.0f / M_PI;
                float diff = fabs(angle - currentYaw);
                
                if (diff < closestAngle) {
                    closestAngle = diff;
                    closestEnemyPos = enemyPos;
                    found = 1;
                }
            }
            
            if (found) {
                float targetYaw = atan2(closestEnemyPos.z - localPos.z, closestEnemyPos.x - localPos.x) * 180.0f / M_PI;
                SafeSetRotationQuat(localPlayer, YawToQuaternion(targetYaw));
            }
        }
    }
}

static void StartGameLoop() {
    if (gameTimer) [gameTimer invalidate];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer *timer) {
        UpdateGame();
    }];
}

// === BOUTON DRAGGABLE (100% TON CODE ORIGINAL) ===
@interface DraggableButton : UIButton
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, copy) void (^toggleBlock)(void);
@end

@implementation DraggableButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title block:(void (^)(void))block {
    self = [super initWithFrame:frame];
    if (self) {
        self.toggleBlock = block;
        self.isActive = NO;
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.85];
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)buttonTapped {
    if (self.toggleBlock) self.toggleBlock();
    
    self.isActive = !self.isActive;
    if (self.isActive) {
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.9];
        self.layer.borderColor = [UIColor greenColor].CGColor;
    } else {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.85];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

@end

// === BOUTON SECRET = ACTIVATE ALL ============
@interface SecretButton : UIButton
@end

@implementation SecretButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:0.85];
        self.layer.cornerRadius = frame.size.width / 2;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [self setTitle:@"🔓" forState:UIControlStateNormal];
        [self addTarget:self action:@selector(toggleSecret) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

- (void)toggleSecret {
    cheatsEnabled = !cheatsEnabled;
    
    if (cheatsEnabled) {
        [self setTitle:@"🔓 ON" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:0.9];
        if (!gameTimer) StartGameLoop();
        NSLog(@"👾💻 [XSNPOWWWWWW] TOUS LES CHEATS ACTIVÉS");
        
        for (UIView *btn in allButtons) {
            if (btn != secretButton) btn.hidden = NO;
        }
    } else {
        [self setTitle:@"🔒 OFF" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:0.85];
        NSLog(@"👾💻 [XSNPOWWWWWW] Cheats désactivés");
        
        for (UIView *btn in allButtons) {
            if (btn != secretButton) btn.hidden = YES;
        }
    }
}

@end

// === RESET GUEST (draggable) ===
@interface ResetButton : UIButton
@end

@implementation ResetButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"RESET GUEST" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:0.9];
        self.layer.cornerRadius = 12;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [self addTarget:self action:@selector(resetTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)resetTapped {
    resetGuestAccount();
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

@end

// === ACTIONS ===
void updateESPBox() { espBoxEnabled = !espBoxEnabled; if (!gameTimer) StartGameLoop(); }
void updateESPLine() { espLineEnabled = !espLineEnabled; }
void updateESPDistance() { espDistanceEnabled = !espDistanceEnabled; }
void updateESPHealth() { espHealthEnabled = !espHealthEnabled; }
void updateAimbot() { aimbotEnabled = !aimbotEnabled; if (!gameTimer) StartGameLoop(); }
void updateSpinbot() { spinbotEnabled = !spinbotEnabled; if (spinbotEnabled && aimbotEnabled) aimbotEnabled = NO; if (!gameTimer) StartGameLoop(); }

// === CRÉATION DE L'UI ===
static void CreateUI() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        isFreeFire = [bundleID containsString:@"garena"] || [bundleID containsString:@"freefire"];
        
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                CreateUI();
            });
            return;
        }
        
        allButtons = [NSMutableArray new];
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat btnW = 100, btnH = 40;
        
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 280, 20)];
        xsnLabel.text = @"XSNPMODZCHEATFFGOTHACKED";
        xsnLabel.textColor = [UIColor blackColor];
        xsnLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];
        xsnLabel.alpha = 0.75;
        [root.view addSubview:xsnLabel];
        
        secretButton = [[SecretButton alloc] initWithFrame:CGRectMake(screenW - 65, 45, 55, 55)];
        [root.view addSubview:secretButton];
        
        NSArray *titles = @[@"ESP BOX", @"ESP LINE", @"ESP DIST", @"ESP HEALTH", @"AIMBOT", @"SPINBOT"];
        NSArray *selectors = @[^{ updateESPBox(); }, ^{ updateESPLine(); }, ^{ updateESPDistance(); }, ^{ updateESPHealth(); }, ^{ updateAimbot(); }, ^{ updateSpinbot(); }];
        NSArray *positions = @[
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 130, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(25, 200, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 25, 200, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 270, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(25, screenH - 170, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 25, screenH - 170, btnW, btnH)]
        ];
        
        for (int i = 0; i < 6; i++) {
            DraggableButton *btn = [[DraggableButton alloc] initWithFrame:[positions[i] CGRectValue] title:titles[i] block:selectors[i]];
            btn.hidden = YES;
            [root.view addSubview:btn];
            [allButtons addObject:btn];
        }
        
        ResetButton *resetBtn = [[ResetButton alloc] initWithFrame:CGRectMake(screenW/2 - 80, screenH - 100, 160, 45)];
        [root.view addSubview:resetBtn];
        [allButtons addObject:resetBtn];
        
        NSLog(@"✅👾 [XSNPOWWWWWW] MENU chargé - Appuie sur 🔓 quand tu es en game");
    });
}

%ctor {
    NSLog(@"👾💻 [XSNPOWWWWWW] dylib chargé - cheats OFF au début");
    CreateUI();
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment { %orig; }
%end