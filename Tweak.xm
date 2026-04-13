// Tweak.xm - MOD MENU FLOTTANT + LOGIN - XSNPOWWWWWW Edition (Flottant comme une grosse bite)

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL ppxEnabled = NO;

@interface FloatingButton : UIButton
@end

@implementation FloatingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 30;
        self.clipsToBounds = YES;
        [self setTitle:@"☢️" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:30];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    CGPoint newCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    self.center = newCenter;
    [gesture setTranslation:CGPointZero inView:self.superview];
}
@end

@interface MenuViewController : UIViewController
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UISwitch *espBoxSwitch;
@property (nonatomic, strong) UISwitch *espLineSwitch;
@property (nonatomic, strong) UISwitch *espDistanceSwitch;
@property (nonatomic, strong) UISwitch *ppxSwitch;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.92];
    self.view.layer.cornerRadius = 15;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    title.text = @"NEXUS FLOATING MENU - XSNPOWWWWWW";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:title];
    
    if (!isLoggedIn) {
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 80, self.view.frame.size.width - 80, 40)];
        self.usernameField.placeholder = @"Username (nexus/admin)";
        self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
        self.usernameField.backgroundColor = [UIColor darkGrayColor];
        self.usernameField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.usernameField];
        
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40, 130, self.view.frame.size.width - 80, 40)];
        self.passwordField.placeholder = @"Password (1234/xsn)";
        self.passwordField.secureTextEntry = YES;
        self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordField.backgroundColor = [UIColor darkGrayColor];
        self.passwordField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.passwordField];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        loginBtn.frame = CGRectMake(40, 190, self.view.frame.size.width - 80, 50);
        [loginBtn setTitle:@"LOGIN TO FUCK THE GAME" forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor redColor];
        loginBtn.tintColor = [UIColor whiteColor];
        [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginBtn];
    } else {
        [self createSwitch:@"ESP Box (Rouge)" y:80 action:@selector(toggleEspBox) var:&espBoxEnabled];
        [self createSwitch:@"ESP Line (Cul transpercé)" y:130 action:@selector(toggleEspLine) var:&espLineEnabled];
        [self createSwitch:@"ESP Distance" y:180 action:@selector(toggleEspDistance) var:&espDistanceEnabled];
        [self createSwitch:@"PPX Achats Gratuits" y:230 action:@selector(togglePpx) var:&ppxEnabled];
        
        UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        applyBtn.frame = CGRectMake(40, 290, self.view.frame.size.width - 80, 50);
        [applyBtn setTitle:@"APPLY & HIDE MENU" forState:UIControlStateNormal];
        applyBtn.backgroundColor = [UIColor greenColor];
        applyBtn.tintColor = [UIColor blackColor];
        [applyBtn addTarget:self action:@selector(applyAndClose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyBtn];
    }
}

- (void)createSwitch:(NSString *)label y:(CGFloat)y action:(SEL)action var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, 200, 30)];
    lbl.text = label; lbl.textColor = [UIColor whiteColor];
    [self.view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, y, 50, 30)];
    sw.on = *var;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
    
    if ([label containsString:@"Box"]) self.espBoxSwitch = sw;
    else if ([label containsString:@"Line"]) self.espLineSwitch = sw;
    else if ([label containsString:@"Distance"]) self.espDistanceSwitch = sw;
    else if ([label containsString:@"PPX"]) self.ppxSwitch = sw;
}

- (void)loginAction {
    NSString *user = self.usernameField.text.lowercaseString;
    NSString *pass = self.passwordField.text;
    if (([user isEqualToString:@"nexus"] || [user isEqualToString:@"admin"]) && ([pass isEqualToString:@"1234"] || [pass isEqualToString:@"xsn"])) {
        isLoggedIn = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            // Réouvrir avec switches
            MenuViewController *newMenu = [[MenuViewController alloc] init];
            newMenu.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            [root presentViewController:newMenu animated:YES completion:nil];
        }];
    }
}

- (void)toggleEspBox { espBoxEnabled = self.espBoxSwitch.on; }
- (void)toggleEspLine { espLineEnabled = self.espLineSwitch.on; }
- (void)toggleEspDistance { espDistanceEnabled = self.espDistanceSwitch.on; }
- (void)togglePpx { ppxEnabled = self.ppxSwitch.on; }

- (void)applyAndClose {
    NSLog(@"[XSNPOWWWWWW] 🔥 Features appliquées : ESP Box=%d | Line=%d | Distance=%d | PPX=%d", espBoxEnabled, espLineEnabled, espDistanceEnabled, ppxEnabled);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

// Bouton flottant global
FloatingButton *floatingBtn = nil;

%hook UIApplication
- (void)sendEvent:(UIEvent *)event {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (!floatingBtn) {
                floatingBtn = [[FloatingButton alloc] initWithFrame:CGRectMake(30, 100, 60, 60)];
                UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
                [root.view addSubview:floatingBtn];
                
                [floatingBtn addTarget:floatingBtn action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
            }
        });
    });
}
%end

%hook FloatingButton
- (void)openMenu {
    if (!isLoggedIn || ![self.window.rootViewController.presentedViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *menu = [[MenuViewController alloc] init];
        menu.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        [root presentViewController:menu animated:YES completion:nil];
    }
}
%end

// PPX
%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) {
        NSLog(@"[XSNPOWWWWWW] PPX ACTIVÉ - Achat gratuit pour %@ 💰🍆", payment.productIdentifier);
        return;
    }
    %orig;
}
%end

%ctor {
    NSLog(@"[XSNPOWWWWWW] 🔥 MOD MENU FLOTTANT INJECTÉ - Bouton ☢️ prêt à te faire bander pendant le game !");
}