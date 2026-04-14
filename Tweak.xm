#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// ============ OFFSETS (remplace par TES valeurs de Bullet Force) ============
// Dump avec Il2CppDumper et cherche ces noms dans dump.cs

#define OFFSET_GET_LOCAL_PLAYER    0x00000000  // ← À REMPLACER
#define OFFSET_GET_PLAYERS_LIST    0x00000000  // ← À REMPLACER
#define OFFSET_GET_POSITION        0x00000000  // ← À REMPLACER
#define OFFSET_GET_HEALTH          0x00000000  // ← À REMPLACER
#define OFFSET_GET_TEAM            0x00000000  // ← À REMPLACER
#define OFFSET_GET_ROTATION        0x00000000  // ← À REMPLACER (pour aimbot)
#define OFFSET_SET_ROTATION        0x00000000  // ← À REMPLACER (pour aimbot)
#define OFFSET_WORLD_TO_SCREEN     0x00000000  // ← À REMPLACER
#define OFFSET_CAMERA_GET_MAIN     0x00000000  // ← À REMPLACER

// ============ VARIABLES ============
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL aimbotEnabled = NO;

static NSMutableArray *allContainers = nil;
static UIButton *secretButton = nil;
static BOOL switchesHidden = NO;
static NSTimer *rgbTimer = nil;

// ============ STRUCTURES ============
typedef struct {
    float x;
    float y;
    float z;
} vec3_t;

// ============ FONCTIONS DE LECTURE MÉMOIRE ============
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

static float GetHealth(void* player) {
    float (*func)(void*) = (float (*)(void*))OFFSET_GET_HEALTH;
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
        
        // Calculer l'angle vers l'ennemi
        float dx = enemyPos.x - localPos.x;
        float dz = enemyPos.z - localPos.z;
        float angle = atan2(dz, dx) * 180.0 / M_PI;
        
        float angleDiff = fabs(angle - currentRot);
        if (angleDiff < closestAngle) {
            closestAngle = angleDiff;
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

// ============ RGB ANIMATION ============
static void startRGBAnimation(UIView *view) {
    if (rgbTimer) [rgbTimer invalidate];
    rgbTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *timer) {
        static int step = 0;
        step++;
        CGFloat hue = (step % 360) / 360.0;
        UIColor *color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
        view.backgroundColor = color;
    }];
}

static void stopRGBAnimation(UIView *view) {
    if (rgbTimer) {
        [rgbTimer invalidate];
        rgbTimer = nil;
    }
    view.backgroundColor = [UIColor redColor];
}

// === CLASSE CONTAINER DRAGGABLE AVEC RGB ===
@interface DraggableContainer : UIView
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, copy) NSString *cheatName;
@end

@implementation DraggableContainer

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action {
    self = [super initWithFrame:frame];
    if (self) {
        self.cheatName = title;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        // Vue de couleur (rouge par défaut)
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.colorView.backgroundColor = [UIColor redColor];
        self.colorView.layer.cornerRadius = 10;
        self.colorView.userInteractionEnabled = NO;
        [self addSubview:self.colorView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        self.label.text = title;
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont boldSystemFontOfSize:11];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.colorView addSubview:self.label];
        
        self.switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(frame.size.width/2 - 25, 22, 50, 35)];
        self.switchControl.on = NO;
        [self.switchControl addTarget:nil action:action forControlEvents:UIControlEventValueChanged];
        [self.colorView addSubview:self.switchControl];
        
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

- (void)setActive:(BOOL)active {
    if (active) {
        startRGBAnimation(self.colorView);
    } else {
        stopRGBAnimation(self.colorView);
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    self.colorView.hidden = hidden;
}

@end

// === BOUTON SECRET DRAGGABLE ===
@interface SecretDraggableButton : UIButton
@end

@implementation SecretDraggableButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.layer.cornerRadius = frame.size.width / 2;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self setTitle:@"🔓" forState:UIControlStateNormal];
        
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

@end

// === ACTIONS DES SWITCHES ===
void switchESPBox(UISwitch *sender) {
    espBoxEnabled = sender.isOn;
    UIView *container = (UIView *)sender.superview.superview;
    if ([container isKindOfClass:[DraggableContainer class]]) {
        [(DraggableContainer *)container setActive:espBoxEnabled];
    }
    NSLog(@"ESP BOX: %@", espBoxEnabled ? @"ON" : @"OFF");
}
void switchESPLine(UISwitch *sender) {
    espLineEnabled = sender.isOn;
    UIView *container = (UIView *)sender.superview.superview;
    if ([container isKindOfClass:[DraggableContainer class]]) {
        [(DraggableContainer *)container setActive:espLineEnabled];
    }
    NSLog(@"ESP LINE: %@", espLineEnabled ? @"ON" : @"OFF");
}
void switchESPDistance(UISwitch *sender) {
    espDistanceEnabled = sender.isOn;
    UIView *container = (UIView *)sender.superview.superview;
    if ([container isKindOfClass:[DraggableContainer class]]) {
        [(DraggableContainer *)container setActive:espDistanceEnabled];
    }
    NSLog(@"ESP DISTANCE: %@", espDistanceEnabled ? @"ON" : @"OFF");
}
void switchESPHealth(UISwitch *sender) {
    espHealthEnabled = sender.isOn;
    UIView *container = (UIView *)sender.superview.superview;
    if ([container isKindOfClass:[DraggableContainer class]]) {
        [(DraggableContainer *)container setActive:espHealthEnabled];
    }
    NSLog(@"ESP HEALTH: %@", espHealthEnabled ? @"ON" : @"OFF");
}
void switchAimbot(UISwitch *sender) {
    aimbotEnabled = sender.isOn;
    UIView *container = (UIView *)sender.superview.superview;
    if ([container isKindOfClass:[DraggableContainer class]]) {
        [(DraggableContainer *)container setActive:aimbotEnabled];
    }
    NSLog(@"AIMBOT: %@", aimbotEnabled ? @"ON" : @"OFF");
}

// === TIMER POUR AIMBOT ===
static NSTimer *aimbotTimer = nil;

static void StartAimbotLoop() {
    if (aimbotTimer) [aimbotTimer invalidate];
    aimbotTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer *timer) {
        UpdateAimbot();
    }];
}

// === SECRET MOD ===
@implementation UIButton (SecretMod)

- (void)toggleSecret {
    switchesHidden = !switchesHidden;
    for (DraggableContainer *container in allContainers) {
        container.hidden = switchesHidden;
    }
    if (switchesHidden) {
        [secretButton setTitle:@"🔐" forState:UIControlStateNormal];
    } else {
        [secretButton setTitle:@"🔓" forState:UIControlStateNormal];
    }
    NSLog(@"SECRET MOD: %@", switchesHidden ? @"CACHÉ" : @"VISIBLE");
}

@end

// === CRÉATION DE L'UI ===
static void CreateUI() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        allContainers = [NSMutableArray new];
        
        CGFloat containerW = 100;
        CGFloat containerH = 70;
        CGFloat startX = 15;
        CGFloat startY = 60;
        CGFloat spacing = 10;
        
        // Petit texte XSNPMODZZZ
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 15)];
        xsnLabel.text = @"XSNPMODZZZ";
        xsnLabel.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.7];
        xsnLabel.font = [UIFont systemFontOfSize:9];
        [root.view addSubview:xsnLabel];
        
        // Bouton secret
        secretButton = [[SecretDraggableButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 40, 40, 40)];
        [secretButton addTarget:secretButton action:@selector(toggleSecret) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:secretButton];
        
        // Ligne 1
        DraggableContainer *c1 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX, startY, containerW, containerH) title:@"ESP BOX" action:@selector(switchESPBox:)];
        [root.view addSubview:c1];
        [allContainers addObject:c1];
        
        DraggableContainer *c2 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX + containerW + spacing, startY, containerW, containerH) title:@"ESP LINE" action:@selector(switchESPLine:)];
        [root.view addSubview:c2];
        [allContainers addObject:c2];
        
        // Ligne 2
        CGFloat startY2 = startY + containerH + spacing;
        
        DraggableContainer *c3 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX, startY2, containerW, containerH) title:@"ESP DIST" action:@selector(switchESPDistance:)];
        [root.view addSubview:c3];
        [allContainers addObject:c3];
        
        DraggableContainer *c4 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX + containerW + spacing, startY2, containerW, containerH) title:@"ESP HEALTH" action:@selector(switchESPHealth:)];
        [root.view addSubview:c4];
        [allContainers addObject:c4];
        
        // Ligne 3
        CGFloat startY3 = startY2 + containerH + spacing;
        
        DraggableContainer *c5 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX, startY3, containerW, containerH) title:@"AIMBOT" action:@selector(switchAimbot:)];
        [root.view addSubview:c5];
        [allContainers addObject:c5];
        
        // Démarrer la boucle aimbot
        StartAimbotLoop();
        
        NSLog(@"✅ UI créée : ESP BOX, LINE, DIST, HEALTH, AIMBOT");
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