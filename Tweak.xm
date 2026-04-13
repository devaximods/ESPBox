// Tweak.xm - XSNPMODZ MOD MENU DISCRET FLOTTANT - PETIT ET PROPRE

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables
BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL ppxEnabled = NO;

@interface XSNPMODZMenu : UIView
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UISwitch *espBoxSwitch;
@property (nonatomic, strong) UISwitch *espLineSwitch;
@property (nonatomic, strong) UISwitch *espDistanceSwitch;
@property (nonatomic, strong) UISwitch *aimbotSwitch;
@property (nonatomic, strong) UISwitch *ppxSwitch;
@end

@interface FloatingButton : UIButton
@end

@implementation FloatingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9];
        self.layer.cornerRadius = 25;
        [self setTitle:@"🔥" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
        
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
    static XSNPMODZMenu *menu = nil;
    if (menu && menu.superview) {
        [menu removeFromSuperview];
        menu = nil;
    } else {
        menu = [[XSNPMODZMenu alloc] initWithFrame:CGRectMake(20, 80, 280, 380)];
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        [root.view addSubview:menu];
    }
}
@end

@implementation XSNPMODZMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.12 alpha:0.92];
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor redColor].CGColor;
        
        // Titre discret
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 40)];
        title.text = @"XSNPMODZ";
        title.textColor = [UIColor redColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:22];
        [self addSubview:title];
        
        if (!isLoggedIn) {
            // Login compact
            self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(15, 60, frame.size.width-30, 35)];
            self.usernameField.placeholder = @"Username";
            self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
            self.usernameField.backgroundColor = [UIColor darkGrayColor];
            self.usernameField.textColor = [UIColor whiteColor];
            [self addSubview:self.usernameField];
            
            self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(15, 105, frame.size.width-30, 35)];
            self.passwordField.placeholder = @"Password";
            self.passwordField.secureTextEntry = YES;
            self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
            self.passwordField.backgroundColor = [UIColor darkGrayColor];
            self.passwordField.textColor = [UIColor whiteColor];
            [self addSubview:self.passwordField];
            
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            loginBtn.frame = CGRectMake(15, 155, frame.size.width-30, 40);
            [loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
            loginBtn.backgroundColor = [UIColor redColor];
            loginBtn.tintColor = [UIColor whiteColor];
            [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:loginBtn];
        } else {
            // Switches discrets
            [self createSwitch:@"ESP BOX" y:60 action:@selector(toggleEspBox) var:&espBoxEnabled];
            [self createSwitch:@"ESP LINE" y:105 action:@selector(toggleEspLine) var:&espLineEnabled];
            [self createSwitch:@"ESP DIST" y:150 action:@selector(toggleEspDistance) var:&espDistanceEnabled];
            [self createSwitch:@"AIMBOT" y:195 action:@selector(toggleAimbot) var:&aimbotEnabled];
            [self createSwitch:@"PPX" y:240 action:@selector(togglePpx) var:&ppxEnabled];
            
            UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            applyBtn.frame = CGRectMake(15, 300, frame.size.width-30, 45);
            [applyBtn setTitle:@"APPLY & HIDE" forState:UIControlStateNormal];
            applyBtn.backgroundColor = [UIColor greenColor];
            applyBtn.tintColor = [UIColor blackColor];
            [applyBtn addTarget:self action:@selector(applyAndClose) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:applyBtn];
        }
        
        // Bouton fermer discret
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(frame.size.width-40, 10, 30, 30);
        [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        closeBtn.tintColor = [UIColor whiteColor];
        [closeBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)createSwitch:(NSString *)label y:(CGFloat)y action:(SEL)action var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 180, 30)];
    lbl.text = label; lbl.textColor = [UIColor whiteColor]; lbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(200, y, 60, 30)];
    sw.on = *var;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self addSubview:sw];
    
    if ([label containsString:@"BOX"]) self.espBoxSwitch = sw;
    else if ([label containsString:@"LINE"]) self.espLineSwitch = sw;
    else if ([label containsString:@"DIST"]) self.espDistanceSwitch = sw;
    else if ([label containsString:@"AIMBOT"]) self.aimbotSwitch = sw;
    else if ([label containsString:@"PPX"]) self.ppxSwitch = sw;
}

- (void)loginAction {
    NSString *user = self.usernameField.text.lowercaseString;
    NSString *pass = self.passwordField.text;
    if (([user isEqualToString:@"nexus"] || [user isEqualToString:@"admin"]) && ([pass isEqualToString:@"1234"] || [pass isEqualToString:@"xsn"])) {
        isLoggedIn = YES;
        [self removeFromSuperview];
        // Réouvrir le menu avec switches
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            FloatingButton *btn = (FloatingButton *)[[[UIApplication sharedApplication] windows] firstObject].rootViewController.view.subviews.lastObject;
            if ([btn isKindOfClass:[FloatingButton class]]) [btn toggleMenu];
        });
    }
}

- (void)toggleEspBox { espBoxEnabled = self.espBoxSwitch.on; }
- (void)toggleEspLine { espLineEnabled = self.espLineSwitch.on; }
- (void)toggleEspDistance { espDistanceEnabled = self.espDistanceSwitch.on; }
- (void)toggleAimbot { aimbotEnabled = self.aimbotSwitch.on; }
- (void)togglePpx { ppxEnabled = self.ppxSwitch.on; }

- (void)applyAndClose {
    NSLog(@"[XSNPMODZ] 🔥 APPLIQUÉ : Box=%d Line=%d Dist=%d Aimbot=%d PPX=%d", espBoxEnabled, espLineEnabled, espDistanceEnabled, aimbotEnabled, ppxEnabled);
    [self removeFromSuperview];
}

@end

FloatingButton *floatingBtn = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!floatingBtn) {
            floatingBtn = [[FloatingButton alloc] initWithFrame:CGRectMake(30, 150, 50, 50)];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            if (root && root.view) {
                [root.view addSubview:floatingBtn];
                NSLog(@"[XSNPMODZ] 🔥 Menu discret injecté - Bouton petit et menu flottant prêt !");
            }
        }
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) {
        NSLog(@"[XSNPMODZ] PPX gratuit pour %@ 💰", payment.productIdentifier);
        return;
    }
    %orig;
}
%end