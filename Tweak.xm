#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// ============ OFFSETS (Bullet Force) ============
#define OFFSET_GET_LOCAL_PLAYER    0x334B268
#define OFFSET_GET_PLAYERS_LIST    0x5D70930
#define OFFSET_GET_TEAM            0x3D496E0
#define OFFSET_GET_HEALTH          0x100
#define OFFSET_GET_TRANSFORM       0x6021A2C
#define OFFSET_GET_POSITION        0x602EC28
#define OFFSET_GET_ROTATION        0x602EF18
#define OFFSET_SET_ROTATION        0x602EFF0
#define OFFSET_CAMERA_GET_MAIN     0x84E7148
#define OFFSET_WORLD_TO_SCREEN     0x84E6A54

// ============ VARIABLES ============
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL spinbotEnabled = NO;

static NSMutableArray *allButtons = nil;
static UIButton *secretButton = nil;
static NSTimer *gameTimer = nil;
static BOOL isGameReady = NO;
static UIView *espContainer = nil;

// ============ STRUCTURES ============
typedef struct { float x; float y; float z; } vec3_t;
typedef struct { float x; float y; float z; float w; } quaternion_t;

// ============ FONCTION POUR OBTENIR LA KEY WINDOW (iOS 13+ seulement) ============
static UIWindow* GetKeyWindow() {
    if (@available(iOS 13, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
    }
    return nil;
}

// ============ FONCTIONS MÉMOIRE ============
static void* GetLocalPlayer() {
    void* (*func)() = (void* (*)())OFFSET_GET_LOCAL_PLAYER;
    return func ? func() : NULL;
}

static void** GetPlayersList(int *count) {
    void** (*func)(int*) = (void** (*)(int*))OFFSET_GET_PLAYERS_LIST;
    return func ? func(count) : NULL;
}

static void* GetTransform(void* player) {
    void* (*func)(void*) = (void* (*)(void*))OFFSET_GET_TRANSFORM;
    return func ? func(player) : NULL;
}

static vec3_t GetPosition(void* player) {
    void* transform = GetTransform(player);
    if (!transform) return (vec3_t){0,0,0};
    vec3_t (*func)(void*) = (vec3_t (*)(void*))OFFSET_GET_POSITION;
    return func ? func(transform) : (vec3_t){0,0,0};
}

static int GetTeam(void* player) {
    int (*func)(void*) = (int (*)(void*))OFFSET_GET_TEAM;
    return func ? func(player) : 0;
}

static quaternion_t GetRotationQuat(void* player) {
    void* transform = GetTransform(player);
    if (!transform) return (quaternion_t){0,0,0,1};
    quaternion_t (*func)(void*) = (quaternion_t (*)(void*))OFFSET_GET_ROTATION;
    return func ? func(transform) : (quaternion_t){0,0,0,1};
}

static void SetRotationQuat(void* player, quaternion_t rot) {
    void* transform = GetTransform(player);
    if (!transform) return;
    void (*func)(void*, quaternion_t) = (void (*)(void*, quaternion_t))OFFSET_SET_ROTATION;
    if (func) func(transform, rot);
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
    q.y = sin(halfRad);
    q.z = 0.0f;
    q.w = cos(halfRad);
    return q;
}

// ============ CAMERA & ESP ============
static void* GetMainCamera() {
    void* (*func)() = (void* (*)())OFFSET_CAMERA_GET_MAIN;
    return func ? func() : NULL;
}

static CGPoint WorldToScreen(vec3_t worldPos, CGSize screenSize) {
    vec3_t (*func)(void*, vec3_t) = (vec3_t (*)(void*, vec3_t))OFFSET_WORLD_TO_SCREEN;
    void* camera = GetMainCamera();
    if (!camera) return CGPointMake(-1, -1);
    vec3_t result = func(camera, worldPos);
    return CGPointMake(result.x, result.y);
}

static void SetupESP() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        if (!espContainer) {
            espContainer = [[UIView alloc] initWithFrame:keyWindow.bounds];
            espContainer.backgroundColor = [UIColor clearColor];
            espContainer.userInteractionEnabled = NO;
            [keyWindow addSubview:espContainer];
        }
    });
}

static void ClearESP() {
    if (!espContainer) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subview in espContainer.subviews) {
            [subview removeFromSuperview];
        }
    });
}

static void DrawBox(CGPoint center, float distance) {
    if (!espContainer) return;
    
    float size = 60.0f / distance;
    if (size < 10) size = 10;
    if (size > 50) size = 50;
    
    CGRect rect = CGRectMake(center.x - size/2, center.y - size, size, size);
    
    UIView *box = [[UIView alloc] initWithFrame:rect];
    box.backgroundColor = [UIColor clearColor];
    box.layer.borderWidth = 2;
    box.layer.borderColor = [UIColor redColor].CGColor;
    box.tag = 999;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [espContainer addSubview:box];
    });
}

static void DrawDistance(CGPoint pos, float distance) {
    if (!espContainer) return;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pos.x - 20, pos.y - 25, 40, 15)];
    label.text = [NSString stringWithFormat:@"%.0fm", distance];
    label.textColor = [UIColor yellowColor];
    label.font = [UIFont systemFontOfSize:10];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 999;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [espContainer addSubview:label];
    });
}

// ============ UPDATE GAME ============
static void UpdateGame() {
    if (!isGameReady) return;
    
    // Vérification des offsets
    if (!ValidatePointers()) return;
    
    @autoreleasepool {
        void* localPlayer = GetLocalPlayer();
        if (!localPlayer) return;
        
        // SPINBOT - avec vérification
        if (spinbotEnabled) {
            quaternion_t rot = GetRotationQuat(localPlayer);
            // Vérifier que la rotation est valide (pas de valeurs NaN)
            if (!isnan(rot.x) && !isnan(rot.y) && !isnan(rot.z) && !isnan(rot.w)) {
                float yaw = QuaternionToYaw(rot);
                yaw += 30.0f;
                SetRotationQuat(localPlayer, YawToQuaternion(yaw));
            }
        }
        // AIMBOT
        else if (aimbotEnabled) {
            vec3_t localPos = GetPosition(localPlayer);
            int localTeam = GetTeam(localPlayer);
            quaternion_t localRot = GetRotationQuat(localPlayer);
            float currentYaw = QuaternionToYaw(localRot);
            
            int playerCount = 0;
            void** players = GetPlayersList(&playerCount);
            if (!players || playerCount == 0) return;
            
            float closestAngle = 360.0f;
            vec3_t closestEnemyPos = {0,0,0};
            int found = 0;
            
            for (int i = 0; i < playerCount && i < 50; i++) {
                void* player = players[i];
                if (!player || player == localPlayer) continue;
                
                int team = GetTeam(player);
                if (team == localTeam) continue;
                
                vec3_t enemyPos = GetPosition(player);
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
                SetRotationQuat(localPlayer, YawToQuaternion(targetYaw));
            }
        }
        
        // ESP - uniquement si activé et que la caméra existe
        if ((espBoxEnabled || espLineEnabled || espDistanceEnabled || espHealthEnabled)) {
            void* camera = GetMainCamera();
            if (!camera) return;
            
            ClearESP();
            
            int playerCount = 0;
            void** players = GetPlayersList(&playerCount);
            if (!players || playerCount == 0) return;
            
            vec3_t localPos = GetPosition(localPlayer);
            int localTeam = GetTeam(localPlayer);
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            
            for (int i = 0; i < playerCount && i < 50; i++) {
                void* player = players[i];
                if (!player || player == localPlayer) continue;
                
                int team = GetTeam(player);
                if (team == localTeam) continue;
                
                vec3_t enemyPos = GetPosition(player);
                float dx = enemyPos.x - localPos.x;
                float dz = enemyPos.z - localPos.z;
                float distance = sqrt(dx*dx + dz*dz);
                
                if (distance < 50 && distance > 1) {
                    CGPoint screenPos = WorldToScreen(enemyPos, screenSize);
                    
                    if (screenPos.x > 0 && screenPos.x < screenSize.width &&
                        screenPos.y > 0 && screenPos.y < screenSize.height) {
                        if (espBoxEnabled) DrawBox(screenPos, distance);
                        if (espDistanceEnabled) DrawDistance(screenPos, distance);
                    }
                }
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

// === BOUTON DRAGGABLE ===
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

// === BOUTON SECRET ===
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
    isGameReady = !isGameReady;
    
    if (isGameReady) {
        [self setTitle:@"🔓 ON" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:0.9];
        SetupESP();
        StartGameLoop();
        NSLog(@"✅ Cheats activés");
        
        for (UIView *btn in allButtons) {
            if (btn != secretButton) btn.hidden = NO;
        }
    } else {
        [self setTitle:@"🔒 OFF" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:0.85];
        ClearESP();
        NSLog(@"❌ Cheats désactivés");
        
        for (UIView *btn in allButtons) {
            if (btn != secretButton) btn.hidden = YES;
        }
    }
}

@end

// === ACTIONS ===
void updateESPBox() { espBoxEnabled = !espBoxEnabled; }
void updateESPLine() { espLineEnabled = !espLineEnabled; }
void updateESPDistance() { espDistanceEnabled = !espDistanceEnabled; }
void updateESPHealth() { espHealthEnabled = !espHealthEnabled; }
void updateAimbot() { aimbotEnabled = !aimbotEnabled; }
void updateSpinbot() { spinbotEnabled = !spinbotEnabled; if (spinbotEnabled && aimbotEnabled) aimbotEnabled = NO; }

// === CRÉATION DE L'UI ===
static void CreateUI() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        UIViewController *root = keyWindow.rootViewController;
        if (!root || !root.view) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                CreateUI();
            });
            return;
        }
        
        allButtons = [NSMutableArray new];
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat btnW = 100, btnH = 40;
        
        // Texte XSNPMODZZZ
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
        xsnLabel.text = @"XSNPMODZZZ";
        xsnLabel.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.8];
        xsnLabel.font = [UIFont systemFontOfSize:10];
        [root.view addSubview:xsnLabel];
        
        // Bouton secret
        secretButton = [[SecretButton alloc] initWithFrame:CGRectMake(screenW - 55, 45, 45, 45)];
        [root.view addSubview:secretButton];
        
        // Positions des boutons
        NSArray *titles = @[@"ESP BOX", @"ESP LINE", @"ESP DIST", @"ESP HEALTH", @"AIMBOT", @"SPINBOT"];
        NSArray *selectors = @[^{ updateESPBox(); }, ^{ updateESPLine(); }, ^{ updateESPDistance(); }, ^{ updateESPHealth(); }, ^{ updateAimbot(); }, ^{ updateSpinbot(); }];
        NSArray *positions = @[
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 100, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(20, 170, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 20, 170, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 240, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(20, screenH - 100, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 20, screenH - 100, btnW, btnH)]
        ];
        
        for (int i = 0; i < 6; i++) {
            DraggableButton *btn = [[DraggableButton alloc] initWithFrame:[positions[i] CGRectValue] title:titles[i] block:selectors[i]];
            btn.hidden = YES;
            [root.view addSubview:btn];
            [allButtons addObject:btn];
        }
        
        NSLog(@"✅ UI créée - 6 boutons");
    });
}

%ctor {
    NSLog(@"👾 Dylib chargé - Appuie sur 🔓 en jeu");
    CreateUI();
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment { %orig; }
%end