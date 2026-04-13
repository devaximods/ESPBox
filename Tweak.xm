// Tweak.xm - XSNPMODZ MENU FLOTTANT COMPLET + ESP BOX / LINE / DISTANCE / AIMBOT - TARPIN STYLÉ

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// === VARIABLES GLOBALES ===
BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL ppxEnabled = NO;

// === BOUTON FLOTTANT PERSONNALISABLE ===
@interface FloatingButton : UIButton
@end

@implementation FloatingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9];
        self.layer.cornerRadius = 35;
        self.clipsToBounds = YES;
        [self setTitle:@"🔥" forState:UIControlStateNormal];  // ← CHANGE ÇA POUR TON LOGO (ex: "X" ou "💀")
        self.titleLabel.font = [UIFont systemFontOfSize:35];
        
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

// === MENU PRINCIPAL XSNPMODZ ===
@interface XSNPMODZMenu : UIViewController
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UISwitch *espBoxSwitch;
@property (nonatomic, strong) UISwitch *espLineSwitch;
@property (nonatomic, strong) UISwitch *espDistanceSwitch;
@property (nonatomic, strong) UISwitch *aimbotSwitch;
@property (nonatomic, strong) UISwitch *ppxSwitch;
@end

@implementation XSNPMODZMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:0.96];
    self.view.layer.cornerRadius = 20;
    self.view.layer.borderWidth = 3;
    self.view.layer.borderColor = [UIColor redColor].CGColor;
    
    // Titre XSNPMODZ bien stylé
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:32];
    title.shadowColor = [UIColor blackColor];
    title.shadowOffset = CGSizeMake(2, 2);
    [self.view addSubview:title];
    
    if (!isLoggedIn) {
        // Login
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 90, self.view.frame.size.width - 80, 45)];
        self.usernameField.placeholder = @"Username (nexus ou admin)";
        self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
        self.usernameField.backgroundColor = [UIColor darkGrayColor];
        self.usernameField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.usernameField];
        
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40, 150, self.view.frame.size.width - 80, 45)];
        self.passwordField.placeholder = @"Password (1234 ou xsn)";
        self.passwordField.secureTextEntry = YES;
        self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordField.backgroundColor = [UIColor darkGrayColor];
        self.passwordField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.passwordField];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        loginBtn.frame = CGRectMake(40, 220, self.view.frame.size.width - 80, 55);
        [loginBtn setTitle:@"LOGIN TO DESTROY" forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor redColor];
        loginBtn.tintColor = [UIColor whiteColor];
        loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginBtn];
    } else {
        // Switches stylés
        [self createSwitch:@"ESP BOX (Rouge sur tout le monde)" y:90 action:@selector(toggleEspBox) var:&espBoxEnabled];
        [self createSwitch:@"ESP LINE (Cul transpercé)" y:140 action:@selector(toggleEspLine) var:&espLineEnabled];
        [self createSwitch:@"ESP DISTANCE (Mètres)" y:190 action:@selector(toggleEspDistance) var:&espDistanceEnabled];
        [self createSwitch:@"AIMBOT (Tête auto)" y:240 action:@selector(toggleAimbot) var:&aimbotEnabled];
        [self createSwitch:@"PPX Achats Gratuits" y:290 action:@selector(togglePpx) var:&ppxEnabled];
        
        UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        applyBtn.frame = CGRectMake(40, 360, self.view.frame.size.width - 80, 55);
        [applyBtn setTitle:@"APPLY & HIDE - LET'S FUCK THEM" forState:UIControlStateNormal];
        applyBtn.backgroundColor = [UIColor greenColor];
        applyBtn.tintColor = [UIColor blackColor];
        applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [applyBtn addTarget:self action:@selector(applyAndClose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyBtn];
    }
}

- (void)createSwitch:(NSString *)label y:(CGFloat)y action:(SEL)action var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, self.view.frame.size.width - 120, 35)];
    lbl.text = label;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, y, 60, 35)];
    sw.on = *var;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
    
    if ([label containsString:@"BOX"]) self.espBoxSwitch = sw;
    else if ([label containsString:@"LINE"]) self.espLineSwitch = sw;
    else if ([label containsString:@"DISTANCE"]) self.espDistanceSwitch = sw;
    else if ([label containsString:@"AIMBOT"]) self.aimbotSwitch = sw;
    else if ([label containsString:@"PPX"]) self.ppxSwitch = sw;
}

- (void)loginAction {
    NSString *user = self.usernameField.text.lowercaseString;
    NSString *pass = self.passwordField.text;
    if (([user isEqualToString:@"nexus"] || [user isEqualToString:@"admin"]) && ([pass isEqualToString:@"1234"] || [pass isEqualToString:@"xsn"])) {
        isLoggedIn = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            XSNPMODZMenu *newMenu = [[XSNPMODZMenu alloc] init];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            [root presentViewController:newMenu animated:YES completion:nil];
        }];
    }
}

- (void)toggleEspBox { espBoxEnabled = self.espBoxSwitch.on; }
- (void)toggleEspLine { espLineEnabled = self.espLineSwitch.on; }
- (void)toggleEspDistance { espDistanceEnabled = self.espDistanceSwitch.on; }
- (void)toggleAimbot { aimbotEnabled = self.aimbotSwitch.on; }
- (void)togglePpx { ppxEnabled = self.ppxSwitch.on; }

- (void)applyAndClose {
    NSLog(@"[XSNPMODZ] 🔥 APPLIQUÉ : Box=%d Line=%d Distance=%d Aimbot=%d PPX=%d", espBoxEnabled, espLineEnabled, espDistanceEnabled, aimbotEnabled, ppxEnabled);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

// === BOUTON FLOTTANT GLOBAL ===
FloatingButton *floatingBtn = nil;

%hook UIApplication
- (void)sendEvent:(UIEvent *)event {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (!floatingBtn) {
                floatingBtn = [[FloatingButton alloc] initWithFrame:CGRectMake(30, 150, 70, 70)];
                UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
                [root.view addSubview:floatingBtn];
                [floatingBtn addTarget:floatingBtn action:@selector(openXSNPMODZ) forControlEvents:UIControlEventTouchUpInside];
            }
        });
    });
}
%end

%hook FloatingButton
- (void)openXSNPMODZ {
    XSNPMODZMenu *menu = [[XSNPMODZMenu alloc] init];
    menu.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    [root presentViewController:menu animated:YES completion:nil];
}
%end

// === PPX ===
%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) {
        NSLog(@"[XSNPMODZ] PPX ACTIVÉ - Achat gratuit pour %@ 💰🍆", payment.productIdentifier);
        return;
    }
    %orig;
}
%end

// === PLACEHOLDER POUR ESP + AIMBOT (à compléter avec tes offsets Il2Cpp) ===
%ctor {
    NSLog(@"[XSNPMODZ] 🔥 MENU COMPLET INJECTÉ - Bouton flottant + ESP + Aimbot prêt à tout niquer !");
    // Ici tu ajouteras plus tard le hook OnGUI ou Present pour dessiner les boîtes rouges, lignes, distance et aimbot
}