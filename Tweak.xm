#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <QuartzCore/QuartzCore.h>

// ============ COULEURS ============
#define NEON_GREEN [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0]
#define NEON_RED [UIColor colorWithRed:1.0 green:0.2 blue:0.3 alpha:1.0]
#define NEON_BLUE [UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0]
#define NEON_PINK [UIColor colorWithRed:1.0 green:0.3 blue:0.8 alpha:1.0]
#define DARK_BG [UIColor colorWithRed:0.05 green:0.05 blue:0.12 alpha:0.95]

// ============ VARIABLES ============
static BOOL isLoggedIn = NO;
static BOOL espBox = NO;
static BOOL espLine = NO;
static BOOL espDistance = NO;
static BOOL aimbot = NO;
static BOOL ppx = NO;

static UIButton *floatingBtn = nil;
static UIView *menuView = nil;

// ============ BOUTON FLOTTANT ============
@interface StylishButton : UIButton
@end

@implementation StylishButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = NEON_RED;
        self.layer.cornerRadius = 30;
        self.layer.shadowColor = NEON_RED.CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 0.8;
        [self setTitle:@"⚡" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightBold];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:pan];
        [self addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        
        // Animation pulsante
        CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.duration = 0.8;
        pulse.fromValue = @1.0;
        pulse.toValue = @1.1;
        pulse.autoreverses = YES;
        pulse.repeatCount = HUGE_VALF;
        [self.layer addAnimation:pulse forKey:@"pulse"];
    }
    return self;
}
- (void)drag:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:self.superview];
    self.center = CGPointMake(self.center.x + t.x, self.center.y + t.y);
    [g setTranslation:CGPointZero inView:self.superview];
}
- (void)toggleMenu {
    if (menuView && menuView.superview) {
        [UIView animateWithDuration:0.3 animations:^{
            menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            menuView.alpha = 0;
        } completion:^(BOOL finished) {
            [menuView removeFromSuperview];
            menuView = nil;
        }];
    } else {
        [self showMenu];
    }
}
- (void)showMenu {
    UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    if (!root) return;
    
    menuView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 320, 480)];
    menuView.backgroundColor = DARK_BG;
    menuView.layer.cornerRadius = 25;
    menuView.layer.borderWidth = 1;
    menuView.layer.borderColor = NEON_GREEN.CGColor;
    menuView.layer.shadowColor = NEON_GREEN.CGColor;
    menuView.layer.shadowOffset = CGSizeZero;
    menuView.layer.shadowRadius = 15;
    menuView.layer.shadowOpacity = 0.5;
    menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    menuView.alpha = 0;
    
    // Effet glassmorphism
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = menuView.bounds;
    blurView.layer.cornerRadius = 25;
    blurView.clipsToBounds = YES;
    [menuView addSubview:blurView];
    
    // Bandeau néon haut
    UIView *neonTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 3)];
    neonTop.backgroundColor = NEON_GREEN;
    neonTop.layer.shadowColor = NEON_GREEN.CGColor;
    neonTop.layer.shadowRadius = 5;
    neonTop.layer.shadowOpacity = 1;
    [menuView addSubview:neonTop];
    
    // Titre
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    title.text = @"⚡ XSNPMODZ ⚡";
    title.textColor = NEON_GREEN;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28];
    title.textAlignment = NSTextAlignmentCenter;
    title.shadowColor = NEON_GREEN;
    title.shadowOffset = CGSizeZero;
    [menuView addSubview:title];
    
    // Sous-titre
    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320, 20)];
    sub.text = @"PREMIUM MOD MENU";
    sub.textColor = [UIColor whiteColor];
    sub.font = [UIFont systemFontOfSize:12];
    sub.textAlignment = NSTextAlignmentCenter;
    [menuView addSubview:sub];
    
    if (!isLoggedIn) {
        [self addLoginUI:menuView];
    } else {
        [self addSwitchesUI:menuView];
    }
    
    // Bouton fermer
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(270, 15, 35, 35);
    close.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    close.layer.cornerRadius = 17.5;
    [close setTitle:@"✕" forState:UIControlStateNormal];
    [close setTitleColor:NEON_RED forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [close addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:close];
    
    [root.view addSubview:menuView];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        menuView.transform = CGAffineTransformIdentity;
        menuView.alpha = 1;
    } completion:nil];
}

- (void)addLoginUI:(UIView *)parent {
    UITextField *user = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 280, 45)];
    user.placeholder = @"🔑 NOM D'UTILISATEUR";
    user.borderStyle = UITextBorderStyleRoundedRect;
    user.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    user.textColor = [UIColor whiteColor];
    user.font = [UIFont systemFontOfSize:14];
    user.tag = 100;
    [parent addSubview:user];
    
    UITextField *pass = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, 280, 45)];
    pass.placeholder = @"🔒 MOT DE PASSE";
    pass.secureTextEntry = YES;
    pass.borderStyle = UITextBorderStyleRoundedRect;
    pass.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    pass.textColor = [UIColor whiteColor];
    pass.font = [UIFont systemFontOfSize:14];
    pass.tag = 101;
    [parent addSubview:pass];
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeSystem];
    login.frame = CGRectMake(20, 250, 280, 50);
    login.backgroundColor = NEON_GREEN;
    login.layer.cornerRadius = 25;
    login.layer.shadowColor = NEON_GREEN.CGColor;
    login.layer.shadowRadius = 8;
    login.layer.shadowOpacity = 0.6;
    [login setTitle:@"🚀 SE CONNECTER" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [login addTarget:self action:@selector(doLogin:) forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:login];
}

- (void)doLogin:(UIButton *)sender {
    UIView *parent = sender.superview;
    UITextField *user = [parent viewWithTag:100];
    UITextField *pass = [parent viewWithTag:101];
    
    if (([user.text isEqualToString:@"xsnp"] || [user.text isEqualToString:@"nexus"]) && 
        ([pass.text isEqualToString:@"1234"] || [pass.text isEqualToString:@"xsn"])) {
        isLoggedIn = YES;
        [self toggleMenu];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self toggleMenu];
        });
    } else {
        [self shakeView:user];
        [self shakeView:pass];
    }
}

- (void)addSwitchesUI:(UIView *)parent {
    NSArray *items = @[
        @{@"name":@"ESP BOX", @"y":@120, @"color":NEON_RED, @"var":&espBox},
        @{@"name":@"ESP LINE", @"y":@175, @"color":NEON_GREEN, @"var":&espLine},
        @{@"name":@"ESP DIST", @"y":@230, @"color":NEON_BLUE, @"var":&espDistance},
        @{@"name":@"AIMBOT", @"y":@285, @"color":NEON_PINK, @"var":&aimbot},
        @{@"name":@"PPX HACK", @"y":@340, @"color":[UIColor orangeColor], @"var":&ppx}
    ];
    
    for (int i = 0; i < items.count; i++) {
        NSDictionary *item = items[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, [item[@"y"] intValue], 180, 40)];
        label.text = item[@"name"];
        label.textColor = item[@"color"];
        label.font = [UIFont boldSystemFontOfSize:16];
        [parent addSubview:label];
        
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(220, [item[@"y"] intValue], 60, 40)];
        sw.on = *(BOOL *)item[@"var"];
        sw.tag = 1000 + i;
        [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [parent addSubview:sw];
    }
    
    UIButton *apply = [UIButton buttonWithType:UIButtonTypeSystem];
    apply.frame = CGRectMake(20, 410, 280, 50);
    apply.backgroundColor = NEON_GREEN;
    apply.layer.cornerRadius = 25;
    apply.layer.shadowColor = NEON_GREEN.CGColor;
    apply.layer.shadowRadius = 8;
    apply.layer.shadowOpacity = 0.6;
    [apply setTitle:@"💾 APPLIQUER & FERMER" forState:UIControlStateNormal];
    [apply setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    apply.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [apply addTarget:self action:@selector(applyAndClose) forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:apply];
}

- (void)switchChanged:(UISwitch *)sender {
    switch (sender.tag - 1000) {
        case 0: espBox = sender.on; break;
        case 1: espLine = sender.on; break;
        case 2: espDistance = sender.on; break;
        case 3: aimbot = sender.on; break;
        case 4: ppx = sender.on; break;
    }
}

- (void)applyAndClose {
    NSLog(@"[XSNPMODZ] 🔥 ESP: Box=%d Line=%d Dist=%d | Aimbot=%d | PPX=%d", espBox, espLine, espDistance, aimbot, ppx);
    [self toggleMenu];
}

- (void)shakeView:(UIView *)view {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.duration = 0.1;
    shake.repeatCount = 2;
    shake.autoreverses = YES;
    shake.fromValue = @(-5);
    shake.toValue = @(5);
    [view.layer addAnimation:shake forKey:@"shake"];
}
@end

// ============ INIT ============
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (root) {
            floatingBtn = [[StylishButton alloc] initWithFrame:CGRectMake(20, 120, 60, 60)];
            [root.view addSubview:floatingBtn];
            NSLog(@"[XSNPMODZ] 🔥 Menu stylé chargé !");
        }
    });
}

// ============ PPX HOOK ============
%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppx) {
        NSLog(@"[XSNPMODZ] 💰 PPX - Produit gratuit: %@", payment.productIdentifier);
        return;
    }
    %orig;
}
%end