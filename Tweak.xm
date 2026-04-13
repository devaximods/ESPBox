// Tweak.xm - XSNPMODZ POP-UP STYLÉ AU MILIEU + CODE 1 + MENU 3 SECTIONS

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables
BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL aimbotEnabled = NO;
BOOL ppxEnabled = NO;

// === POP-UP LOGIN STYLÉ AU MILIEU ===
@interface XSNPMODZLogin : UIViewController
@property (nonatomic, strong) UITextField *codeField;
@end

@implementation XSNPMODZLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.88];
    
    // Panel stylé avec bords très arrondis
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(40, 180, self.view.frame.size.width - 80, 240)];
    panel.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.15 alpha:0.98];
    panel.layer.cornerRadius = 28;           // bords super doux
    panel.layer.borderWidth = 4;
    panel.layer.borderColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0].CGColor;
    panel.layer.shadowColor = [UIColor redColor].CGColor;
    panel.layer.shadowOffset = CGSizeMake(0, 10);
    panel.layer.shadowRadius = 20;
    panel.layer.shadowOpacity = 0.6;
    [self.view addSubview:panel];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, panel.frame.size.width, 50)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:32];
    [panel addSubview:title];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(35, 95, panel.frame.size.width - 70, 55)];
    self.codeField.placeholder = @"Entre le code secret";
    self.codeField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeField.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.25 alpha:1.0];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.font = [UIFont systemFontOfSize:22];
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeField.textAlignment = NSTextAlignmentCenter;
    [panel addSubview:self.codeField];
    
    UIButton *unlockBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    unlockBtn.frame = CGRectMake(35, 170, panel.frame.size.width - 70, 55);
    [unlockBtn setTitle:@"UNLOCK CHEAT" forState:UIControlStateNormal];
    unlockBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.15 blue:0.15 alpha:1.0];
    unlockBtn.layer.cornerRadius = 14;
    unlockBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    unlockBtn.tintColor = [UIColor whiteColor];
    [unlockBtn addTarget:self action:@selector(unlock) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:unlockBtn];
}

- (void)unlock {
    if ([self.codeField.text isEqualToString:@"1"]) {
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

// === MENU BEAU AVEC 3 SECTIONS ===
@interface XSNPMODZMenu : UIViewController
@end

@implementation XSNPMODZMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.08 alpha:0.96];
    
    UILabel *bigTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 70)];
    bigTitle.text = @"XSNPMODZ";
    bigTitle.textColor = [UIColor redColor];
    bigTitle.textAlignment = NSTextAlignmentCenter;
    bigTitle.font = [UIFont boldSystemFontOfSize:38];
    [self.view addSubview:bigTitle];
    
    // MAIN
    [self createSection:@"MAIN" atY:140];
    [self createSwitch:@"Aimbot (Tête auto)" atY:180 var:&aimbotEnabled];
    
    // ESP
    [self createSection:@"ESP" atY:240];
    [self createSwitch:@"ESP BOX" atY:280 var:&espBoxEnabled];
    [self createSwitch:@"ESP LINE" atY:320 var:&espLineEnabled];
    [self createSwitch:@"ESP DISTANCE" atY:360 var:&espDistanceEnabled];
    
    // EXTRA
    [self createSection:@"EXTRA" atY:420];
    [self createSwitch:@"PPX Achats Gratuits" atY:460 var:&ppxEnabled];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(60, self.view.frame.size.height - 110, self.view.frame.size.width - 120, 65);
    [close setTitle:@"CLOSE MENU" forState:UIControlStateNormal];
    close.backgroundColor = [UIColor greenColor];
    close.layer.cornerRadius = 18;
    close.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    close.tintColor = [UIColor blackColor];
    [close addTarget:self action:@selector(dismissViewControllerAnimated:completion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
}

- (void)createSection:(NSString *)name atY:(CGFloat)y {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 300, 40)];
    lbl.text = name;
    lbl.textColor = [UIColor redColor];
    lbl.font = [UIFont boldSystemFontOfSize:21];
    [self.view addSubview:lbl];
}

- (void)createSwitch:(NSString *)label atY:(CGFloat)y var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, y, 240, 40)];
    lbl.text = label; lbl.textColor = [UIColor whiteColor]; lbl.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, y + 6, 70, 35)];
    sw.on = *var;
    [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
}

- (void)switchChanged:(UISwitch *)sw {
    // Pour l'instant on met juste les variables (à lier correctement plus tard)
}

@end

// Injection directe du login stylé
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XSNPMODZLogin *login = [[XSNPMODZLogin alloc] init];
        login.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (root) {
            [root presentViewController:login animated:YES completion:nil];
            NSLog(@"[XSNPMODZ] 🔥 Pop-up login stylé injecté - Code = 1");
        }
    });
}

// PPX
%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) return;
    %orig;
}
%end