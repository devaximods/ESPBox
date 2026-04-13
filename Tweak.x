#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// === CONFIG MENU ===
static BOOL enabled = YES;
static BOOL stealthMode = NO;
static BOOL espBox = NO;
static BOOL espLine = NO;
static BOOL espDistance = NO;
static BOOL ppxHack = NO;

static UIViewController *menuVC = nil;

// === MENU VIEW CONTROLLER ===
@interface NexusMenuViewController : UIViewController
@property (nonatomic, strong) UISwitch *stealthSwitch;
@property (nonatomic, strong) UISwitch *espBoxSwitch;
@property (nonatomic, strong) UISwitch *espLineSwitch;
@property (nonatomic, strong) UISwitch *espDistanceSwitch;
@property (nonatomic, strong) UISwitch *ppxSwitch;
@property (nonatomic, strong) UIButton *applyButton;
@end

@implementation NexusMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:0.95];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 300, 50)];
    title.text = @"🔥 NEXUS MOD 🔥";
    title.textColor = [UIColor redColor];
    title.font = [UIFont boldSystemFontOfSize:28];
    [self.view addSubview:title];
    
    // Stealth
    self.stealthSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 120, 0, 0)];
    [self.stealthSwitch addTarget:self action:@selector(toggleStealth:) forControlEvents:UIControlEventValueChanged];
    UILabel *stealthLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 120, 200, 30)];
    stealthLabel.text = @"Stealth Mode";
    stealthLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:stealthLabel];
    [self.view addSubview:self.stealthSwitch];
    
    // ESP Box
    self.espBoxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 170, 0, 0)];
    [self.espBoxSwitch addTarget:self action:@selector(toggleEspBox:) forControlEvents:UIControlEventValueChanged];
    UILabel *boxLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 170, 200, 30)];
    boxLabel.text = @"ESP Box";
    boxLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:boxLabel];
    [self.view addSubview:self.espBoxSwitch];
    
    // ESP Line
    self.espLineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 220, 0, 0)];
    [self.espLineSwitch addTarget:self action:@selector(toggleEspLine:) forControlEvents:UIControlEventValueChanged];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 220, 200, 30)];
    lineLabel.text = @"ESP Line";
    lineLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:lineLabel];
    [self.view addSubview:self.espLineSwitch];
    
    // ESP Distance
    self.espDistanceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 270, 0, 0)];
    [self.espDistanceSwitch addTarget:self action:@selector(toggleEspDistance:) forControlEvents:UIControlEventValueChanged];
    UILabel *distLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 270, 200, 30)];
    distLabel.text = @"ESP Distance";
    distLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:distLabel];
    [self.view addSubview:self.espDistanceSwitch];
    
    // PPX Hack
    self.ppxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 320, 0, 0)];
    [self.ppxSwitch addTarget:self action:@selector(togglePpx:) forControlEvents:UIControlEventValueChanged];
    UILabel *ppxLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 320, 200, 30)];
    ppxLabel.text = @"PPX Hack";
    ppxLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:ppxLabel];
    [self.view addSubview:self.ppxSwitch];
    
    // Apply Button
    self.applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.applyButton.frame = CGRectMake(50, 400, 250, 60);
    [self.applyButton setTitle:@"APPLY" forState:UIControlStateNormal];
    self.applyButton.backgroundColor = [UIColor redColor];
    self.applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.applyButton addTarget:self action:@selector(applySettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.applyButton];
}

- (void)toggleStealth:(UISwitch *)sender { stealthMode = sender.isOn; }
- (void)toggleEspBox:(UISwitch *)sender { espBox = sender.isOn; }
- (void)toggleEspLine:(UISwitch *)sender { espLine = sender.isOn; }
- (void)toggleEspDistance:(UISwitch *)sender { espDistance = sender.isOn; }
- (void)togglePpx:(UISwitch *)sender { ppxHack = sender.isOn; }

- (void)applySettings {
    NSLog(@"NEXUS MOD APPLIED - ESP Box: %d, Line: %d, Distance: %d, PPX: %d", espBox, espLine, espDistance, ppxHack);
}

@end

// === FONCTION POUR OBTENIR LA KEY WINDOW ===
static UIWindow* GetKeyWindow() {
    if (@available(iOS 13, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return nil;
}

// === GESTE 3 DOIGTS POUR OUVRIR LE MENU ===
%hook UIWindow

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    %orig;
    if (touches.count >= 3 && enabled && !stealthMode && !menuVC) {
        menuVC = [[NexusMenuViewController alloc] init];
        UIWindow *keyWindow = GetKeyWindow();
        [keyWindow.rootViewController presentViewController:menuVC animated:YES completion:nil];
    }
}

%end

// === HOOK POUR LES ACHATS ===
%hook SKPaymentQueue

- (void)finishTransaction:(SKPaymentTransaction *)transaction {
    %orig;
}

- (void)addPayment:(SKPayment *)payment {
    %orig;
}

%end

// === INIT TWEAK ===
%ctor {
    NSLog(@"NEXUS MOD LOADED");
}

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"NEXUS MOD - App launched");
    return %orig;
}

%end