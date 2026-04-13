// Tweak.xm - MENU COMPLET LOGIN + SWITCHES (Version Stable - Prête à compiler)

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// Variables globales
BOOL isLoggedIn = NO;
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL ppxEnabled = NO;

// Menu principal
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
    
    // Titre
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    title.text = @"NEXUS MENU - XSNPOWWWWWW";
    title.textColor = [UIColor redColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:title];
    
    // Login fields (si pas encore loggé)
    if (!isLoggedIn) {
        self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, self.view.frame.size.width - 100, 40)];
        self.usernameField.placeholder = @"Username (nexus ou admin)";
        self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
        self.usernameField.backgroundColor = [UIColor darkGrayColor];
        self.usernameField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.usernameField];
        
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width - 100, 40)];
        self.passwordField.placeholder = @"Password";
        self.passwordField.secureTextEntry = YES;
        self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordField.backgroundColor = [UIColor darkGrayColor];
        self.passwordField.textColor = [UIColor whiteColor];
        [self.view addSubview:self.passwordField];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        loginButton.frame = CGRectMake(50, 260, self.view.frame.size.width - 100, 50);
        [loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor redColor];
        loginButton.tintColor = [UIColor whiteColor];
        [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
    } else {
        // Switches une fois loggé
        UILabel *espLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 200, 30)];
        espLabel.text = @"ESP Box";
        espLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:espLabel];
        
        self.espBoxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 120, 50, 30)];
        self.espBoxSwitch.on = espBoxEnabled;
        [self.espBoxSwitch addTarget:self action:@selector(toggleEspBox) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.espBoxSwitch];
        
        // Même chose pour Line, Distance, PPX...
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 170, 200, 30)];
        lineLabel.text = @"ESP Line";
        lineLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:lineLabel];
        
        self.espLineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 170, 50, 30)];
        self.espLineSwitch.on = espLineEnabled;
        [self.espLineSwitch addTarget:self action:@selector(toggleEspLine) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.espLineSwitch];
        
        UILabel *distLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 220, 200, 30)];
        distLabel.text = @"ESP Distance";
        distLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:distLabel];
        
        self.espDistanceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 220, 50, 30)];
        self.espDistanceSwitch.on = espDistanceEnabled;
        [self.espDistanceSwitch addTarget:self action:@selector(toggleEspDistance) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.espDistanceSwitch];
        
        UILabel *ppxLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 270, 200, 30)];
        ppxLabel.text = @"PPX (Achats)";
        ppxLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:ppxLabel];
        
        self.ppxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 270, 50, 30)];
        self.ppxSwitch.on = ppxEnabled;
        [self.ppxSwitch addTarget:self action:@selector(togglePpx) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.ppxSwitch];
        
        UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        applyButton.frame = CGRectMake(50, 350, self.view.frame.size.width - 100, 50);
        [applyButton setTitle:@"APPLY & CLOSE" forState:UIControlStateNormal];
        applyButton.backgroundColor = [UIColor greenColor];
        applyButton.tintColor = [UIColor blackColor];
        [applyButton addTarget:self action:@selector(applyAndClose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyButton];
    }
}

- (void)loginAction {
    NSString *user = self.usernameField.text;
    NSString *pass = self.passwordField.text;
    
    if ([user isEqualToString:@"nexus"] || [user isEqualToString:@"admin"]) {
        // Mot de passe simple pour test (change-le comme tu veux)
        if ([pass isEqualToString:@"1234"] || [pass isEqualToString:@"xsn"]) {
            isLoggedIn = YES;
            [self dismissViewControllerAnimated:YES completion:^{
                // Réouvrir le menu avec les switches
                MenuViewController *newMenu = [[MenuViewController alloc] init];
                UIViewController *root = [[[UIApplication sharedApplication] connectedScenes] firstObject].delegate.window.rootViewController;
                [root presentViewController:newMenu animated:YES completion:nil];
            }];
        }
    }
}

- (void)toggleEspBox { espBoxEnabled = self.espBoxSwitch.on; }
- (void)toggleEspLine { espLineEnabled = self.espLineSwitch.on; }
- (void)toggleEspDistance { espDistanceEnabled = self.espDistanceSwitch.on; }
- (void)togglePpx { ppxEnabled = self.ppxSwitch.on; }

- (void)applyAndClose {
    // Ici on pourra plus tard appeler les hooks ESP
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

// Hook pour afficher le menu au démarrage (exemple simple)
%hook UIWindowScene
- (void)sceneDidBecomeActive:(UIScene *)scene {
    %orig;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!isLoggedIn) {
                MenuViewController *menu = [[MenuViewController alloc] init];
                UIViewController *rootVC = [[[UIApplication sharedApplication] connectedScenes] firstObject].delegate.window.rootViewController;
                [rootVC presentViewController:menu animated:YES completion:nil];
            }
        });
    });
}
%end

// Hook SKPaymentQueue pour PPX (achats gratuits) - déjà fonctionnel chez toi
%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    if (ppxEnabled) {
        // Simule achat réussi
        NSLog(@"[XSNPOWWWWWW] PPX - Achat gratuit activé !");
        return;
    }
    %orig;
}
%end

// Pour plus tard : hooks ESP Unity (à ajouter dans la prochaine étape)
%ctor {
    NSLog(@"[XSNPOWWWWWW] Dylib injecté avec succès - Menu prêt ! 👾");
}