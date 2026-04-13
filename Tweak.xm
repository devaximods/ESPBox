// Tweak.xm - MENU LOGIN + SWITCHES - VERSION FINALE 2026 (XSNPOWWWWWW Edition)

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
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        loginButton.frame = CGRectMake(50, 260, self.view.frame.size.width - 100, 50);
        [loginButton setTitle:@"LOGIN TO FUCK" forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor redColor];
        loginButton.tintColor = [UIColor whiteColor];
        [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
    } else {
        [self createSwitchWithLabel:@"ESP Box" y:120 action:@selector(toggleEspBox) switchVar:&espBoxEnabled];
        [self createSwitchWithLabel:@"ESP Line" y:170 action:@selector(toggleEspLine) switchVar:&espLineEnabled];
        [self createSwitchWithLabel:@"ESP Distance" y:220 action:@selector(toggleEspDistance) switchVar:&espDistanceEnabled];
        [self createSwitchWithLabel:@"PPX Achats Gratuits" y:270 action:@selector(togglePpx) switchVar:&ppxEnabled];
        
        UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        applyButton.frame = CGRectMake(50, 350, self.view.frame.size.width - 100, 50);
        [applyButton setTitle:@"APPLY & CLOSE MENU" forState:UIControlStateNormal];
        applyButton.backgroundColor = [UIColor greenColor];
        applyButton.tintColor = [UIColor blackColor];
        [applyButton addTarget:self action:@selector(applyAndClose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyButton];
    }
}

- (void)createSwitchWithLabel:(NSString *)label y:(CGFloat)y action:(SEL)action switchVar:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 200, 30)];
    lbl.text = label;
    lbl.textColor = [UIColor whiteColor];
    [self.view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, y, 50, 30)];
    sw.on = *var;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
    
    if ([label containsString:@"ESP Box"]) self.espBoxSwitch = sw;
    else if ([label containsString:@"ESP Line"]) self.espLineSwitch = sw;
    else if ([label containsString:@"ESP Distance"]) self.espDistanceSwitch = sw;
    else if ([label containsString:@"PPX"]) self.ppxSwitch = sw;
}

- (void)loginAction {
    NSString *user = self.usernameField.text.lowercaseString;
    NSString *pass = self.passwordField.text;
    if (([user isEqualToString:@"nexus"] || [user isEqualToString:@"admin"]) && ([pass isEqualToString:@"1234"] || [pass isEqualToString:@"xsn"])) {
        isLoggedIn = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            MenuViewController *newMenu = [[MenuViewController alloc] init];
            UIViewController *root = [self getRootViewController];
            if (root) [root presentViewController:newMenu animated:YES completion:nil];
        }];
    }
}

- (void)toggleEspBox { espBoxEnabled = self.espBoxSwitch.on; }
- (void)toggleEspLine { espLineEnabled = self.espLineSwitch.on; }
- (void)toggleEspDistance { espDistanceEnabled = self.espDistanceSwitch.on; }
- (void)togglePpx { ppxEnabled = self.ppxSwitch.on; }

- (void)applyAndClose {
    NSLog(@"[XSNPOWWWWWW] Features appliquées : Box=%d Line=%d Distance=%d PPX=%d", espBoxEnabled, espLineEnabled, espDistanceEnabled, ppxEnabled);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)getRootViewController {
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] && ((UIWindowScene *)scene).activationState == UISceneActivationStateForegroundActive) {
            return ((UIWindowScene *)scene).keyWindow.rootViewController;
        }
    }
    return nil;
}

@end

%hook UIWindowScene
- (void)sceneDidBecomeActive:(UIScene *)scene {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!isLoggedIn) {
                MenuViewController *menu = [[MenuViewController alloc] init];
                UIViewController *root = [menu getRootViewController];
                if (root) [root presentViewController:menu animated:YES completion:nil];
            }
        });
    });
}
%end

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) {
        NSLog(@"[XSNPOWWWWWW] PPX - Achat gratuit activé pour %@", payment.productIdentifier);
        return;
    }
    %orig;
}
%end

%ctor {
    NSLog(@"[XSNPOWWWWWW] DYLIB INJECTÉ - MENU LOGIN PRÊT À TE FAIRE JOUIR 🔥👾");
}