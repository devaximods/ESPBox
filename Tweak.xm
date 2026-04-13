// Tweak.xm - MENU LOGIN + SWITCHES - VERSION ULTRA STABLE iOS 13+ (XSNPOWWWWWW)

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL ppxEnabled = NO;

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
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.95];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    title.text = @"NEXUS MENU - XSNPOWWWWWW";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:title];
    
    if (!isLoggedIn) {
        // Login
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, self.view.frame.size.width - 100, 40)];
        self.usernameField.placeholder = @"Username (nexus ou admin)";
        self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
        self.usernameField.backgroundColor = [UIColor darkGrayColor];
        self.usernameField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.usernameField];
        
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width - 100, 40)];
        self.passwordField.placeholder = @"Password (1234 ou xsn)";
        self.passwordField.secureTextEntry = YES;
        self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordField.backgroundColor = [UIColor darkGrayColor];
        self.passwordField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.passwordField];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        loginBtn.frame = CGRectMake(50, 260, self.view.frame.size.width - 100, 50);
        [loginBtn setTitle:@"LOGIN TO FUCK" forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor redColor];
        loginBtn.tintColor = [UIColor whiteColor];
        [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginBtn];
    } else {
        // Switches
        [self createSwitch:@"ESP Box" y:120 action:@selector(toggleEspBox) var:&espBoxEnabled];
        [self createSwitch:@"ESP Line" y:170 action:@selector(toggleEspLine) var:&espLineEnabled];
        [self createSwitch:@"ESP Distance" y:220 action:@selector(toggleEspDistance) var:&espDistanceEnabled];
        [self createSwitch:@"PPX Achats Gratuits" y:270 action:@selector(togglePpx) var:&ppxEnabled];
        
        UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        applyBtn.frame = CGRectMake(50, 350, self.view.frame.size.width - 100, 50);
        [applyBtn setTitle:@"APPLY & CLOSE MENU" forState:UIControlStateNormal];
        applyBtn.backgroundColor = [UIColor greenColor];
        applyBtn.tintColor = [UIColor blackColor];
        [applyBtn addTarget:self action:@selector(applyAndClose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyBtn];
    }
}

- (void)createSwitch:(NSString *)label y:(CGFloat)y action:(SEL)action var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 200, 30)];
    lbl.text = label; lbl.textColor = [UIColor whiteColor];
    [self.view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, y, 50, 30)];
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
            MenuViewController *newMenu = [[MenuViewController alloc] init];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            if (root) [root presentViewController:newMenu animated:YES completion:nil];
        }];
    }
}

- (void)toggleEspBox { espBoxEnabled = self.espBoxSwitch.on; }
- (void)toggleEspLine { espLineEnabled = self.espLineSwitch.on; }
- (void)toggleEspDistance { espDistanceEnabled = self.espDistanceSwitch.on; }
- (void)togglePpx { ppxEnabled = self.ppxSwitch.on; }

- (void)applyAndClose {
    NSLog(@"[XSNPOWWWWWW] Features appliquées : Box=%d | Line=%d | Distance=%d | PPX=%d 🔥", espBoxEnabled, espLineEnabled, espDistanceEnabled, ppxEnabled);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

// Hook simple pour ouvrir le menu après 3 secondes
%hook UIApplication
- (void)sendEvent:(UIEvent *)event {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (!isLoggedIn) {
                MenuViewController *menu = [[MenuViewController alloc] init];
                UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
                if (root) [root presentViewController:menu animated:YES completion:nil];
            }
        });
    });
}
%end

// PPX hook
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
    NSLog(@"[XSNPOWWWWWW] DYLIB INJECTÉ - MENU LOGIN PRÊT À TE FAIRE JOUIR SUR iOS 13+ 🔥👾");
}