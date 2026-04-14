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
static UIButton *secretButton = nil;
static BOOL buttonsHidden = NO;
static NSTimer *aimbotTimer = nil;
static NSTimer *spinbotTimer = nil;

// ============ STRUCTURES ============
typedef struct {
    float x;
    float y;
    float z;
} vec3_t;

// ============ FONCTIONS MÉMOIRE ============
static void* GetLocalPlayer() {
    void* (*func)() = (void* (*)())OFFSET_GET_LOCAL_PLAYER;
    return func();
}

static void** GetPlayersList(int *count) {
    void** (*func)(int*) = (void** (*)(int*))OFFSET_GET_PLAYERS_LIST;
    return func(count);
}

static vec3_t GetPosition(void* player) {
    vec3_t (*func)(void*) = (vec3_t (*)(void*))OFFSET_GET_POSITION;
    return func(player);
}

static int GetTeam(void* player) {
    int (*func)(void*) = (int (*)(void*))OFFSET_GET_TEAM;
    return func(player);
}

static float GetRotation(void* player) {
    float (*func)(void*) = (float (*)(void*))OFFSET_GET_ROTATION;
    return func(player);
}

static void SetRotation(void* player, float rot) {
    void (*func)(void*, float) = (void (*)(void*, float))OFFSET_SET_ROTATION;
    func(player, rot);
}

// ============ AIMBOT ============
static void UpdateAimbot() {
    if (!aimbotEnabled) return;
    
    void* localPlayer = GetLocalPlayer();
    if (!localPlayer) return;
    
    vec3_t localPos = GetPosition(localPlayer);
    int localTeam = GetTeam(localPlayer);
    
    int playerCount = 0;
    void** players = GetPlayersList(&playerCount);
    if (!players) return;
    
    float closestAngle = 360.0f;
    void* closestEnemy = nil;
    float currentRot = GetRotation(localPlayer);
    
    for (int i = 0; i < playerCount; i++) {
        void* player = players[i];
        if (!player || player == localPlayer) continue;
        
        int team = GetTeam(player);
        if (team == localTeam) continue;
        
        vec3_t enemyPos = GetPosition(player);
        float dx = enemyPos.x - localPos.x;
        float dz = enemyPos.z - localPos.z;
        float angle = atan2(dz, dx) * 180.0 / M_PI;
        
        if (fabs(angle - currentRot) < closestAngle) {
            closestAngle = fabs(angle - currentRot);
            closestEnemy = player;
        }
    }
    
    if (closestEnemy) {
        vec3_t enemyPos = GetPosition(closestEnemy);
        float dx = enemyPos.x - localPos.x;
        float dz = enemyPos.z - localPos.z;
        float targetAngle = atan2(dz, dx) * 180.0 / M_PI;
        SetRotation(localPlayer, targetAngle);
    }
}

static void StartAimbotLoop() {
    if (aimbotTimer) [aimbotTimer invalidate];
    aimbotTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer *timer) {
        UpdateAimbot();
    }];
}

// ============ SPINBOT ============
static void UpdateSpinbot() {
    if (!spinbotEnabled) return;
    void* localPlayer = GetLocalPlayer();
    if (!localPlayer) return;
    float currentRot = GetRotation(localPlayer);
    currentRot += 30.0f;
    SetRotation(localPlayer, currentRot);
}

static void StartSpinbotLoop() {
    if (spinbotTimer) [spinbotTimer invalidate];
    spinbotTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 repeats:YES block:^(NSTimer *timer) {
        UpdateSpinbot();
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
    if (self.toggleBlock) {
        self.toggleBlock();
    }
    // Animation de clic
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

// === BOUTON SECRET ===
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
    for (UIView *btn in allButtons) {
        btn.hidden = buttonsHidden;
    }
    if (buttonsHidden) {
        [self setTitle:@"🔐" forState:UIControlStateNormal];
    } else {
        [self setTitle:@"🔓" forState:UIControlStateNormal];
    }
}

@end

// === ACTIONS ===
void updateESPBox() { espBoxEnabled = !espBoxEnabled; NSLog(@"ESP BOX: %@", espBoxEnabled ? @"ON" : @"OFF"); }
void updateESPLine() { espLineEnabled = !espLineEnabled; NSLog(@"ESP LINE: %@", espLineEnabled ? @"ON" : @"OFF"); }
void updateESPDistance() { espDistanceEnabled = !espDistanceEnabled; NSLog(@"ESP DIST: %@", espDistanceEnabled ? @"ON" : @"OFF"); }
void updateESPHealth() { espHealthEnabled = !espHealthEnabled; NSLog(@"ESP HEALTH: %@", espHealthEnabled ? @"ON" : @"OFF"); }
void updateAimbot() { 
    aimbotEnabled = !aimbotEnabled; 
    if (aimbotEnabled) StartAimbotLoop();
    NSLog(@"AIMBOT: %@", aimbotEnabled ? @"ON" : @"OFF");
}
void updateSpinbot() { 
    spinbotEnabled = !spinbotEnabled; 
    if (spinbotEnabled) StartSpinbotLoop(); else if (spinbotTimer) [spinbotTimer invalidate];
    NSLog(@"SPINBOT: %@", spinbotEnabled ? @"ON" : @"OFF");
}

// === CRÉATION DE L'UI ===
static void CreateUI() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        allButtons = [NSMutableArray new];
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat btnW = 100;
        CGFloat btnH = 40;
        
        // Petit texte XSNPMODZZZ
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 15)];
        xsnLabel.text = @"XSNPMODZZZ";
        xsnLabel.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.7];
        xsnLabel.font = [UIFont systemFontOfSize:9];
        [root.view addSubview:xsnLabel];
        
        // Bouton secret
        secretButton = [[SecretButton alloc] initWithFrame:CGRectMake(screenW - 50, 45, 40, 40)];
        [root.view addSubview:secretButton];
        
        // BOUTONS
        DraggableButton *btn1 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW/2 - btnW/2, 100, btnW, btnH) title:@"ESP BOX" block:^{ updateESPBox(); DraggableButton *b = (id)[allButtons firstObject]; [b setActive:espBoxEnabled]; }];
        [root.view addSubview:btn1];
        [allButtons addObject:btn1];
        
        DraggableButton *btn2 = [[DraggableButton alloc] initWithFrame:CGRectMake(20, 180, btnW, btnH) title:@"ESP LINE" block:^{ updateESPLine(); DraggableButton *b = (id)[allButtons objectAtIndex:1]; [b setActive:espLineEnabled]; }];
        [root.view addSubview:btn2];
        [allButtons addObject:btn2];
        
        DraggableButton *btn3 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW - btnW - 20, 180, btnW, btnH) title:@"ESP DIST" block:^{ updateESPDistance(); DraggableButton *b = (id)[allButtons objectAtIndex:2]; [b setActive:espDistanceEnabled]; }];
        [root.view addSubview:btn3];
        [allButtons addObject:btn3];
        
        DraggableButton *btn4 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW/2 - btnW/2, 270, btnW, btnH) title:@"ESP HEALTH" block:^{ updateESPHealth(); DraggableButton *b = (id)[allButtons objectAtIndex:3]; [b setActive:espHealthEnabled]; }];
        [root.view addSubview:btn4];
        [allButtons addObject:btn4];
        
        DraggableButton *btn5 = [[DraggableButton alloc] initWithFrame:CGRectMake(20, screenH - 100, btnW, btnH) title:@"AIMBOT" block:^{ updateAimbot(); DraggableButton *b = (id)[allButtons objectAtIndex:4]; [b setActive:aimbotEnabled]; }];
        [root.view addSubview:btn5];
        [allButtons addObject:btn5];
        
        DraggableButton *btn6 = [[DraggableButton alloc] initWithFrame:CGRectMake(screenW - btnW - 20, screenH - 100, btnW, btnH) title:@"SPINBOT" block:^{ updateSpinbot(); DraggableButton *b = (id)[allButtons objectAtIndex:5]; [b setActive:spinbotEnabled]; }];
        [root.view addSubview:btn6];
        [allButtons addObject:btn6];
        
        NSLog(@"✅ UI créée");
    });
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateUI();
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;
}
%end