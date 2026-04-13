// Tweak.xm - XSNPMODZ MENU CACHÉ 3 CLICS + LOGIN CODE "1" + 3 SECTIONS STYLÉES

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables globales
BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL ppxEnabled = NO;
int clickCount = 0;

// Déclarations anticipées
@interface XSNPMODZLogin : UIViewController
@end

@interface XSNPMODZMenu : UIViewController
@end

// === BOUTON FLOTTANT (triple clic) ===
@interface FloatingButton : UIButton
@end

@implementation FloatingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.0]; // invisible
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap)];
        tap.numberOfTapsRequired = 3;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handleTripleTap {
    clickCount++;
    if (clickCount >= 3) {
        clickCount = 0;
        XSNPMODZLogin *login = [[XSNPMODZLogin alloc] init];
        login.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        [root presentViewController:login animated:YES completion:nil];
    }
}
@end

// === LOGIN DISCRET AU MILIEU (code = 1) ===
@implementation XSNPMODZLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(50, 220, self.view.frame.size.width-100, 200)];
    panel.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.12 alpha:0.98];
    panel.layer.cornerRadius = 18;
    panel.layer.borderWidth = 3;
    panel.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:panel];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, panel.frame.size.width, 40)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:28];
    [panel addSubview:title];
    
    UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(30, 90, panel.frame.size.width-60, 50)];
    codeField.placeholder = @"Entre le code (1)";
    codeField.borderStyle = UITextBorderStyleRoundedRect;
    codeField.backgroundColor = [UIColor darkGrayColor];
    codeField.textColor = [UIColor whiteColor];
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.tag = 999;
    [panel addSubview:codeField];
    
    UIButton *validateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    validateBtn.frame = CGRectMake(30, 155, panel.frame.size.width-60, 45);
    [validateBtn setTitle:@"VALIDATE" forState:UIControlStateNormal];
    validateBtn.backgroundColor = [UIColor redColor];
    validateBtn.tintColor = [UIColor whiteColor];
    [validateBtn addTarget:self action:@selector(validateCode) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:validateBtn];
}

- (void)validateCode {
    UITextField *codeField = (UITextField *)[self.view viewWithTag:999];
    if ([codeField.text isEqualToString:@"1"]) {
        isLoggedIn = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            XSNPMODZMenu *menu = [[XSNPMODZMenu alloc] init];
            menu.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            [root presentViewController:menu animated:YES completion:nil];
        }];
    }
}

@end

// === MENU PRINCIPAL AVEC 3 SECTIONS ===
@implementation XSNPMODZMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.92];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 60)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:34];
    [self.view addSubview:title];
    
    // MAIN
    [self createSection:@"MAIN" y:130];
    [self createSwitch:@"Aimbot (Tête auto)" y:170 action:@selector(toggleAimbot) var:&aimbotEnabled];
    
    // ESP
    [self createSection:@"ESP" y:220];
    [self createSwitch:@"ESP BOX" y:260 action:@selector(toggleEspBox) var:&espBoxEnabled];
    [self createSwitch:@"ESP LINE" y:300 action:@selector(toggleEspLine) var:&espLineEnabled];
    [self createSwitch:@"ESP DISTANCE" y:340 action:@selector(toggleEspDistance) var:&espDistanceEnabled];
    
    // EXTRA
    [self createSection:@"EXTRA" y:390];
    [self createSwitch:@"PPX Achats Gratuits" y:430 action:@selector(togglePpx) var:&ppxEnabled];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(60, self.view.frame.size.height - 120, self.view.frame.size.width - 120, 60);
    [closeBtn setTitle:@"CLOSE MENU" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor greenColor];
    closeBtn.tintColor = [UIColor blackColor];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [closeBtn addTarget:self action:@selector(dismissViewControllerAnimated:completion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)createSection:(NSString *)name y:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 250, 35)];
    lbl.text = name;
    lbl.textColor = [UIColor redColor];
    lbl.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:lbl];
}

- (void)createSwitch:(NSString *)label y:(CGFloat)y action:(SEL)action var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 220, 40)];
    lbl.text = label; lbl.textColor = [UIColor whiteColor]; lbl.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, y+5, 60, 35)];
    sw.on = *var;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
}

- (void)toggleEspBox { espBoxEnabled = YES; } // À améliorer plus tard avec vraie référence
- (void)toggleEspLine { espLineEnabled = YES; }
- (void)toggleEspDistance { espDistanceEnabled = YES; }
- (void)toggleAimbot { aimbotEnabled = YES; }
- (void)togglePpx { ppxEnabled = YES; }

@end

// Injection
FloatingButton *floatingBtn = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!floatingBtn) {
            floatingBtn = [[FloatingButton alloc] initWithFrame:CGRectMake(30, 150, 44, 44)];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            if (root && root.view) {
                [root.view addSubview:floatingBtn];
                NSLog(@"[XSNPMODZ] 🔥 Menu caché 3 clics + login code 1 injecté !");
            }
        }
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) return;
    %orig;
}
%end