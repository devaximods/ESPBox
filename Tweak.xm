#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// === VARIABLES DES CHEATS ===
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL flyHackEnabled = NO;
BOOL speedHackEnabled = NO;
BOOL teleportEnabled = NO;
BOOL noRecoilEnabled = NO;

// === CLASSE BOUTON DRAGGABLE ===
@interface DraggableButton : UIButton
@end

@implementation DraggableButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.9];
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 1;
        self.layer.borderColor = color.CGColor;
        
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

// === ACTIONS DES BOUTONS ===
void toggleESPBox() {
    espBoxEnabled = !espBoxEnabled;
    NSLog(@"ESP BOX: %@", espBoxEnabled ? @"ON" : @"OFF");
}
void toggleESPLine() {
    espLineEnabled = !espLineEnabled;
    NSLog(@"ESP LINE: %@", espLineEnabled ? @"ON" : @"OFF");
}
void toggleESPDistance() {
    espDistanceEnabled = !espDistanceEnabled;
    NSLog(@"ESP DISTANCE: %@", espDistanceEnabled ? @"ON" : @"OFF");
}
void toggleESPHealth() {
    espHealthEnabled = !espHealthEnabled;
    NSLog(@"ESP HEALTH: %@", espHealthEnabled ? @"ON" : @"OFF");
}
void toggleFlyHack() {
    flyHackEnabled = !flyHackEnabled;
    NSLog(@"FLY HACK: %@", flyHackEnabled ? @"ON" : @"OFF");
}
void toggleSpeedHack() {
    speedHackEnabled = !speedHackEnabled;
    NSLog(@"SPEED HACK: %@", speedHackEnabled ? @"ON" : @"OFF");
}
void toggleTeleport() {
    teleportEnabled = !teleportEnabled;
    NSLog(@"TELEPORT: %@", teleportEnabled ? @"ON" : @"OFF");
}
void toggleNoRecoil() {
    noRecoilEnabled = !noRecoilEnabled;
    NSLog(@"NO RECOIL: %@", noRecoilEnabled ? @"ON" : @"OFF");
}

// === CRÉATION DES BOUTONS DISPERSÉS ===
static void CreateButtons() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        // Bouton ESP BOX (en haut à gauche)
        DraggableButton *btnESPBox = [[DraggableButton alloc] initWithFrame:CGRectMake(20, 80, 110, 45) title:@"ESP BOX" color:[UIColor cyanColor]];
        [btnESPBox addTarget:nil action:@selector(toggleESPBox) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPBox];
        
        // Bouton ESP LINE (à côté)
        DraggableButton *btnESPLine = [[DraggableButton alloc] initWithFrame:CGRectMake(140, 80, 110, 45) title:@"ESP LINE" color:[UIColor cyanColor]];
        [btnESPLine addTarget:nil action:@selector(toggleESPLine) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPLine];
        
        // Bouton ESP DISTANCE (en dessous)
        DraggableButton *btnESPDistance = [[DraggableButton alloc] initWithFrame:CGRectMake(20, 135, 120, 45) title:@"ESP DIST" color:[UIColor cyanColor]];
        [btnESPDistance addTarget:nil action:@selector(toggleESPDistance) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPDistance];
        
        // Bouton ESP HEALTH (à côté)
        DraggableButton *btnESPHealth = [[DraggableButton alloc] initWithFrame:CGRectMake(150, 135, 120, 45) title:@"ESP HEALTH" color:[UIColor cyanColor]];
        [btnESPHealth addTarget:nil action:@selector(toggleESPHealth) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPHealth];
        
        // Bouton FLY HACK (à gauche, en bas)
        DraggableButton *btnFly = [[DraggableButton alloc] initWithFrame:CGRectMake(20, screenSize.height - 180, 100, 45) title:@"FLY HACK" color:[UIColor orangeColor]];
        [btnFly addTarget:nil action:@selector(toggleFlyHack) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnFly];
        
        // Bouton SPEED HACK (à côté)
        DraggableButton *btnSpeed = [[DraggableButton alloc] initWithFrame:CGRectMake(130, screenSize.height - 180, 110, 45) title:@"SPEED" color:[UIColor orangeColor]];
        [btnSpeed addTarget:nil action:@selector(toggleSpeedHack) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnSpeed];
        
        // Bouton TELEPORT (à gauche, plus bas)
        DraggableButton *btnTeleport = [[DraggableButton alloc] initWithFrame:CGRectMake(20, screenSize.height - 125, 100, 45) title:@"TELEPORT" color:[UIColor redColor]];
        [btnTeleport addTarget:nil action:@selector(toggleTeleport) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnTeleport];
        
        // Bouton NO RECOIL (à côté)
        DraggableButton *btnNoRecoil = [[DraggableButton alloc] initWithFrame:CGRectMake(130, screenSize.height - 125, 110, 45) title:@"NO RECOIL" color:[UIColor redColor]];
        [btnNoRecoil addTarget:nil action:@selector(toggleNoRecoil) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnNoRecoil];
        
        NSLog(@"✅ 8 boutons dispersés créés (draggables)");
    });
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateButtons();
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;
}
%end