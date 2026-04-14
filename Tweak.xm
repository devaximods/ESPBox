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

// ============ VARIABLES (boutonsHidden maintenant __unused pour build) ============
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL spinbotEnabled = NO;

static NSMutableArray *allButtons = nil;
static UIButton *secretButton = nil;
static __unused BOOL buttonsHidden = NO;   // <-- FIX ICI (le reste inchangé)
static NSTimer *gameTimer = nil;

// ============ STRUCTURES (identiques) ============
typedef struct {
    float x; float y; float z;
} vec3_t;

typedef struct {
    float x; float y; float z; float w;
} quaternion_t;

// ============ WRAPPERS SAFE (pour éviter crash) ============
static void* SafeGetLocalPlayer() {
    static void* (*func)() = NULL;
    if (!func) func = (void* (*)())OFFSET_GET_LOCAL_PLAYER;
    return func ? func() : NULL;
}

static void** SafeGetPlayersList(int *count) {
    static void** (*func)(int*) = NULL;
    if (!func) func = (void** (*)(int*))OFFSET_GET_PLAYERS_LIST;
    return func ? func(count) : NULL;
}

static vec3_t SafeGetPosition(void* player) {
    static vec3_t (*func)(void*) = NULL;
    if (!func) func = (vec3_t (*)(void*))OFFSET_GET_POSITION;
    return func && player ? func(player) : (vec3_t){0,0,0};
}

static int SafeGetTeam(void* player) {
    static int (*func)(void*) = NULL;
    if (!func) func = (int (*)(void*))OFFSET_GET_TEAM;
    return func && player ? func(player) : 0;
}

static quaternion_t SafeGetRotationQuat(void* player) {
    static quaternion_t (*func)(void*) = NULL;
    if (!func) func = (quaternion_t (*)(void*))OFFSET_GET_ROTATION;
    return func && player ? func(player) : (quaternion_t){0,0,0,1};
}

static void SafeSetRotationQuat(void* player, quaternion_t rot) {
    static void (*func)(void*, quaternion_t) = NULL;
    if (!func) func = (void (*)(void*, quaternion_t))OFFSET_SET_ROTATION;
    if (func && player) func(player, rot);
}

static float QuaternionToYaw(quaternion_t q) {
    float yaw = atan2(2.0f * (q.y * q.w + q.x * q.z), 1.0f - 2.0f * (q.y * q.y + q.x * q.x));
    return yaw * 180.0f / M_PI;
}

static quaternion_t YawToQuaternion(float yaw) {
    quaternion_t q;
    float rad = yaw * M_PI / 180.0f;
    float halfRad = rad / 2.0f;
    q.x = 0; q.y = sin(halfRad); q.z = 0; q.w = cos(halfRad);
    return q;
}

// ============ UPDATE GAME (protégé) ============
static void UpdateGame() {
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
                float dx = closestEnemyPos.x - localPos.x;
                float dz = closestEnemyPos.z - localPos.z;
                float targetYaw = atan2(dz, dx) * 180.0f / M_PI;
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

// === BOUTON DRAGGABLE (100% TON CODE ORIGINAL - AUCUNE MODIF) ===
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

- (void)setActive:(BOOL)active {
    _isActive = active;
    if (active) {
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.9];
        self.layer.borderColor = [UIColor greenColor].CGColor;
    } else {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.85];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end

// === BOUTON SECRET (100% TON CODE ORIGINAL - AUCUNE MODIF) ===
@interface SecretButton : UIButton
@end

@implementation SecretButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.layer.cornerRadius = frame.size.width / 2;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
    buttonsHidden = !buttonsHidden;
    for (UIView *btn in allButtons) btn.hidden = buttonsHidden;
    [self setTitle:buttonsHidden ? @"🔐" : @"🔓" forState:UIControlStateNormal];
}

@end

// === ACTIONS (identiques) ===
void updateESPBox() { espBoxEnabled = !espBoxEnabled; if (!gameTimer) StartGameLoop(); }
void updateESPLine() { espLineEnabled = !espLineEnabled; }
void updateESPDistance() { espDistanceEnabled = !espDistanceEnabled; }
void updateESPHealth() { espHealthEnabled = !espHealthEnabled; }
void updateAimbot() { aimbotEnabled = !aimbotEnabled; if (!gameTimer) StartGameLoop(); }
void updateSpinbot() { spinbotEnabled = !spinbotEnabled; if (spinbotEnabled && aimbotEnabled) aimbotEnabled = NO; if (!gameTimer) StartGameLoop(); }

// === CRÉATION DE L'UI (avec delay safe) ===
static void CreateUI() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                CreateUI();
            });
            return;
        }
        
        allButtons = [NSMutableArray new];
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat btnW = 100, btnH = 40;
        
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 15)];
        xsnLabel.text = @"XSNPMODZZZ";
        xsnLabel.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.7];
        xsnLabel.font = [UIFont systemFontOfSize:9];
        [root.view addSubview:xsnLabel];
        
        secretButton = [[SecretButton alloc] initWithFrame:CGRectMake(screenW - 50, 45, 40, 40)];
        [root.view addSubview:secretButton];
        
        NSArray *titles = @[@"ESP BOX", @"ESP LINE", @"ESP DIST", @"ESP HEALTH", @"AIMBOT", @"SPINBOT"];
        NSArray *selectors = @[^{ updateESPBox(); }, ^{ updateESPLine(); }, ^{ updateESPDistance(); }, ^{ updateESPHealth(); }, ^{ updateAimbot(); }, ^{ updateSpinbot(); }];
        NSArray *positions = @[
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 100, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(20, 180, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 20, 180, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 270, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(20, screenH - 100, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 20, screenH - 100, btnW, btnH)]
        ];
        
        for (int i = 0; i < 6; i++) {
            DraggableButton *btn = [[DraggableButton alloc] initWithFrame:[positions[i] CGRectValue] title:titles[i] block:selectors[i]];
            [root.view addSubview:btn];
            [allButtons addObject:btn];
        }
        
        StartGameLoop();
        NSLog(@"✅👾 UI créée avec delay safe - boutons 100% identiques à l'original");
    });
}

%ctor {
    NSLog(@"👾💻 XSNPOWWWWWW dylib injected - waiting for Free Fire...");
    CreateUI();
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment { %orig; }
%end