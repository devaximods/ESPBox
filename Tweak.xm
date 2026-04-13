// Tweak.xm - XSNPMODZ MENU CACHÉ 3 CLICS + LOGIN CODE UNIQUE + 3 SECTIONS STYLÉES

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables
BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL ppxEnabled = NO;
int clickCount = 0;

// === BOUTON FLOTTANT CACHÉ ===
@interface FloatingButton : UIButton
@end

@implementation FloatingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.0]; // Invisible au départ
        self.layer.cornerRadius = 22;
        [self setTitle:@"" forState:UIControlStateNormal];
        
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
        [self showLogin];
    }
}

- (void)showLogin {
    XSNPMODZLogin *login = [[XSNPMODZLogin alloc] init];
    login.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    [root presentViewController:login animated:YES completion:nil];
}
@end

// === LOGIN DISCRET AU MILIEU ===
@interface XSNPMODZLogin : UIViewController
@property (nonatomic, strong) UITextField *codeField;
@end

@implementation XSNPMODZLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width-100, 180)];
    panel.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.12 alpha:0.98];
    panel.layer.cornerRadius = 15;
    panel.layer.borderWidth = 3;
    panel.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:panel];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, panel.frame.size.width, 40)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:26];
    [panel addSubview:title];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, panel.frame.size.width-60, 45)];
    self.codeField.placeholder = @"Entre le code (1)";
    self.codeField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeField.backgroundColor = [UIColor darkGrayColor];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    [panel addSubview:self.codeField];
    
    UIButton *validateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    validateBtn.frame = CGRectMake(30, 140, panel.frame.size.width-60, 45);
    [validateBtn setTitle:@"VALIDATE" forState:UIControlStateNormal];
    validateBtn.backgroundColor = [UIColor redColor];
    validateBtn.tintColor = [UIColor whiteColor];
    [validateBtn addTarget:self action:@selector(validateCode) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:validateBtn];
}

- (void)validateCode {
    if ([self.codeField.text isEqualToString:@"1"]) {
        isLoggedIn = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            [self showMainMenu];
        }];
    }
}

- (void)showMainMenu {
    XSNPMODZMenu *menu = [[XSNPMODZMenu alloc] init];
    menu.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    [root presentViewController:menu animated:YES completion:nil];
}

@end

// === MENU PRINCIPAL AVEC 3 SECTIONS ===
@interface XSNPMODZMenu : UIViewController
@end

@implementation XSNPMODZMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.92];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 50)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:32];
    [self.view addSubview:title];
    
    // MAIN
    [self createSection:@"MAIN" y:120];
    [self createSwitch:@"Aimbot (Tête auto)" y:160 action:@selector(toggleAimbot) var:&aimbotEnabled];
    
    // ESP
    [self createSection:@"ESP" y:210];
    [self createSwitch:@"ESP BOX" y:250 action:@selector(toggleEspBox) var:&espBoxEnabled];
    [self createSwitch:@"ESP LINE" y:290 action:@selector(toggleEspLine) var:&espLineEnabled];
    [self createSwitch:@"ESP DISTANCE" y:330 action:@selector(toggleEspDistance) var:&espDistanceEnabled];
    
    // EXTRA
    [self createSection:@"EXTRA" y:380];
    [self createSwitch:@"PPX Achats Gratuits" y:420 action:@selector(togglePpx) var:&ppxEnabled];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(50, self.view.frame.size.height - 100, self.view.frame.size.width - 100, 55);
    [closeBtn setTitle:@"CLOSE MENU" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor greenColor];
    closeBtn.tintColor = [UIColor blackColor];
    [closeBtn addTarget:self action:@selector(dismissViewControllerAnimated:completion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)createSection:(NSString *)name y:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, 200, 30)];
    lbl.text = name;
    lbl.textColor = [UIColor redColor];
    lbl.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:lbl];
}

- (void)createSwitch:(NSString *)label y:(CGFloat)y action:(SEL)action var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 220, 35)];
    lbl.text = label; lbl.textColor = [UIColor whiteColor];
    [self.view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, y, 60, 35)];
    sw.on = *var;
    [sw addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
}

- (void)toggleEspBox { espBoxEnabled = ((UISwitch *)self.view.subviews.lastObject).on; } // Simplifié pour l'exemple
- (void)toggleEspLine { espLineEnabled = ((UISwitch *)self.view.subviews.lastObject).on; }
- (void)toggleEspDistance { espDistanceEnabled = ((UISwitch *)self.view.subviews.lastObject).on; }
- (void)toggleAimbot { aimbotEnabled = ((UISwitch *)self.view.subviews.lastObject).on; }
- (void)togglePpx { ppxEnabled = ((UISwitch *)self.view.subviews.lastObject).on; }

@end

FloatingButton *floatingBtn = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!floatingBtn) {
            floatingBtn = [[FloatingButton alloc] initWithFrame:CGRectMake(30, 150, 44, 44)];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            if (root && root.view) [root.view addSubview:floatingBtn];
            NSLog(@"[XSNPMODZ] 🔥 Menu caché 3 clics injecté - Code login = 1");
        }
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) return;
    %orig;
}
%end