// Tweak.xm - XSNPMODZ POP-UP STYLÉ + LOGIN CODE 1 + MENU TRIANGLE DÉROULANT

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables
BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL ppxEnabled = NO;

// Déclarations anticipées
@interface XSNPMODZLogin : UIViewController
@end

@interface XSNPMODZMenu : UIViewController
@end

// === POP-UP LOGIN STYLÉ AU MILIEU ===
@implementation XSNPMODZLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.88];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(40, 180, self.view.frame.size.width - 80, 240)];
    panel.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.15 alpha:0.98];
    panel.layer.cornerRadius = 28;
    panel.layer.borderWidth = 4;
    panel.layer.borderColor = [UIColor redColor].CGColor;
    panel.layer.shadowColor = [UIColor redColor].CGColor;
    panel.layer.shadowRadius = 25;
    panel.layer.shadowOpacity = 0.7;
    [self.view addSubview:panel];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, panel.frame.size.width, 50)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:32];
    [panel addSubview:title];
    
    UITextField *codeField = [[UITextField alloc] initWithFrame:CGRectMake(35, 95, panel.frame.size.width - 70, 55)];
    codeField.placeholder = @"Entre le code (1)";
    codeField.borderStyle = UITextBorderStyleRoundedRect;
    codeField.backgroundColor = [UIColor darkGrayColor];
    codeField.textColor = [UIColor whiteColor];
    codeField.font = [UIFont systemFontOfSize:24];
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.textAlignment = NSTextAlignmentCenter;
    codeField.tag = 999;
    [panel addSubview:codeField];
    
    UIButton *unlockBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    unlockBtn.frame = CGRectMake(35, 170, panel.frame.size.width - 70, 55);
    [unlockBtn setTitle:@"UNLOCK CHEAT" forState:UIControlStateNormal];
    unlockBtn.backgroundColor = [UIColor redColor];
    unlockBtn.layer.cornerRadius = 16;
    unlockBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    unlockBtn.tintColor = [UIColor whiteColor];
    [unlockBtn addTarget:self action:@selector(unlock) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:unlockBtn];
}

- (void)unlock {
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

// === MENU AVEC TRIANGLE DÉROULANT ===
@implementation XSNPMODZMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.08 alpha:0.95];
    
    // Header avec triangle
    UIButton *header = [UIButton buttonWithType:UIButtonTypeSystem];
    header.frame = CGRectMake(0, 40, self.view.frame.size.width, 55);
    header.backgroundColor = [UIColor colorWithRed:0.15 green:0 blue:0 alpha:0.9];
    [header setTitle:@"XSNPMODZ ▼" forState:UIControlStateNormal];
    [header setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    header.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [header addTarget:self action:@selector(toggleTriangle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:header];
    
    // Content qui se déroule
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 0)];
    content.tag = 777;
    [self.view addSubview:content];
    
    // MAIN
    [self createSection:@"MAIN" inView:content atY:10];
    [self createSwitch:@"Aimbot (Tête auto)" inView:content atY:50 var:&aimbotEnabled];
    
    // ESP
    [self createSection:@"ESP" inView:content atY:110];
    [self createSwitch:@"ESP BOX" inView:content atY:150 var:&espBoxEnabled];
    [self createSwitch:@"ESP LINE" inView:content atY:190 var:&espLineEnabled];
    [self createSwitch:@"ESP DISTANCE" inView:content atY:230 var:&espDistanceEnabled];
    
    // EXTRA
    [self createSection:@"EXTRA" inView:content atY:290];
    [self createSwitch:@"PPX Achats Gratuits" inView:content atY:330 var:&ppxEnabled];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(50, 420, self.view.frame.size.width - 100, 55);
    [close setTitle:@"CLOSE MENU" forState:UIControlStateNormal];
    close.backgroundColor = [UIColor greenColor];
    close.layer.cornerRadius = 15;
    close.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [close addTarget:self action:@selector(dismissViewControllerAnimated:completion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
}

- (void)toggleTriangle {
    UIView *content = [self.view viewWithTag:777];
    BOOL expanded = content.frame.size.height > 0;
    CGFloat newH = expanded ? 0 : 380;
    [UIView animateWithDuration:0.3 animations:^{
        content.frame = CGRectMake(0, 95, self.view.frame.size.width, newH);
        [((UIButton *)self.view.subviews[0]) setTitle:expanded ? @"XSNPMODZ ▼" : @"XSNPMODZ ▲" forState:UIControlStateNormal];
    }];
}

- (void)createSection:(NSString *)name inView:(UIView *)view atY:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 300, 40)];
    lbl.text = name;
    lbl.textColor = [UIColor redColor];
    lbl.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:lbl];
}

- (void)createSwitch:(NSString *)label inView:(UIView *)view atY:(CGFloat)y var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 240, 40)];
    lbl.text = label; lbl.textColor = [UIColor whiteColor];
    [view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, y + 6, 70, 35)];
    sw.on = *var;
    [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sw];
}

- (void)switchChanged:(UISwitch *)sw {
    // variables mises à jour ici plus tard
}

@end

// Injection directe du pop-up stylé
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XSNPMODZLogin *login = [[XSNPMODZLogin alloc] init];
        login.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (root) [root presentViewController:login animated:YES completion:nil];
        NSLog(@"[XSNPMODZ] 🔥 Pop-up stylé + triangle déroulant injecté - Code = 1");
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) return;
    %orig;
}
%end