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

@interface FloatingText : UILabel
@end

@implementation FloatingText

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = @"XSNPMODZMENU";
        self.textColor = [UIColor colorWithRed:0.7 green:0.2 blue:1.0 alpha:1.0];
        self.font = [UIFont boldSystemFontOfSize:20];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.layer.cornerRadius = 15;
        self.clipsToBounds = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

- (void)toggleMenu {
    static UIView *menuPanel = nil;
    if (menuPanel && menuPanel.superview) {
        [menuPanel removeFromSuperview];
        menuPanel = nil;
    } else {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        
        menuPanel = [[UIView alloc] initWithFrame:CGRectMake(20, 100, screenW - 40, 430)];
        menuPanel.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:0.95];
        menuPanel.layer.cornerRadius = 20;
        menuPanel.layer.borderWidth = 1;
        menuPanel.layer.borderColor = [UIColor colorWithRed:0.7 green:0.2 blue:1.0 alpha:1.0].CGColor;
        
        // Titre
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, menuPanel.frame.size.width, 30)];
        title.text = @"🔥 XSNP MOD MENU 🔥";
        title.textColor = [UIColor colorWithRed:0.7 green:0.2 blue:1.0 alpha:1.0];
        title.font = [UIFont boldSystemFontOfSize:18];
        title.textAlignment = NSTextAlignmentCenter;
        [menuPanel addSubview:title];
        
        // Ligne séparatrice
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 55, menuPanel.frame.size.width - 20, 1)];
        line.backgroundColor = [UIColor grayColor];
        [menuPanel addSubview:line];
        
        // BOUTONS (style Free Fire)
        [self addButton:@"ESP BOX" y:70 action:@selector(toggleESPBox) color:[UIColor cyanColor] to:menuPanel];
        [self addButton:@"ESP LINE" y:115 action:@selector(toggleESPLine) color:[UIColor cyanColor] to:menuPanel];
        [self addButton:@"ESP DISTANCE" y:160 action:@selector(toggleESPDistance) color:[UIColor cyanColor] to:menuPanel];
        [self addButton:@"ESP HEALTH" y:205 action:@selector(toggleESPHealth) color:[UIColor cyanColor] to:menuPanel];
        [self addButton:@"FLY HACK" y:250 action:@selector(toggleFlyHack) color:[UIColor orangeColor] to:menuPanel];
        [self addButton:@"SPEED HACK" y:295 action:@selector(toggleSpeedHack) color:[UIColor orangeColor] to:menuPanel];
        [self addButton:@"NO RECOIL" y:340 action:@selector(toggleNoRecoil) color:[UIColor redColor] to:menuPanel];
        [self addButton:@"TELEPORT" y:385 action:@selector(toggleTeleport) color:[UIColor redColor] to:menuPanel];
        
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        [root.view addSubview:menuPanel];
    }
}

- (void)addButton:(NSString *)title y:(CGFloat)y action:(SEL)action color:(UIColor *)color to:(UIView *)panel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, y, panel.frame.size.width - 40, 38);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    btn.layer.cornerRadius = 8;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:btn];
}

// === ACTIONS DES BOUTONS ===
- (void)toggleESPBox {
    espBoxEnabled = !espBoxEnabled;
    NSLog(@"ESP BOX: %@", espBoxEnabled ? @"ON" : @"OFF");
}

- (void)toggleESPLine {
    espLineEnabled = !espLineEnabled;
    NSLog(@"ESP LINE: %@", espLineEnabled ? @"ON" : @"OFF");
}

- (void)toggleESPDistance {
    espDistanceEnabled = !espDistanceEnabled;
    NSLog(@"ESP DISTANCE: %@", espDistanceEnabled ? @"ON" : @"OFF");
}

- (void)toggleESPHealth {
    espHealthEnabled = !espHealthEnabled;
    NSLog(@"ESP HEALTH: %@", espHealthEnabled ? @"ON" : @"OFF");
}

- (void)toggleFlyHack {
    flyHackEnabled = !flyHackEnabled;
    NSLog(@"FLY HACK: %@", flyHackEnabled ? @"ON" : @"OFF");
}

- (void)toggleSpeedHack {
    speedHackEnabled = !speedHackEnabled;
    NSLog(@"SPEED HACK: %@", speedHackEnabled ? @"ON" : @"OFF");
}

- (void)toggleNoRecoil {
    noRecoilEnabled = !noRecoilEnabled;
    NSLog(@"NO RECOIL: %@", noRecoilEnabled ? @"ON" : @"OFF");
}

- (void)toggleTeleport {
    teleportEnabled = !teleportEnabled;
    NSLog(@"TELEPORT: %@", teleportEnabled ? @"ON" : @"OFF");
}

@end

FloatingText *floatingText = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!floatingText) {
            floatingText = [[FloatingText alloc] initWithFrame:CGRectMake(70, 80, 200, 40)];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            if (root && root.view) {
                [root.view addSubview:floatingText];
                NSLog(@"✅ XSNPMODZMENU chargé");
            }
        }
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;
}
%end