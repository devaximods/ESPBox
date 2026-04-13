#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

static UIViewController *loginVC = nil;
static BOOL isLoggedIn = NO;

// === LOGIN VIEW CONTROLLER ===
@interface LoginViewController : UIViewController
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fond noir/vert néon
    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:1.0];
    
    // Titre
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 60)];
    self.titleLabel.text = @"🔥 NEXUS MOD 🔥";
    self.titleLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    // Sous-titre
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width - 40, 30)];
    subLabel.text = @"Connexion requise pour activer les cheats";
    subLabel.textColor = [UIColor lightGrayColor];
    subLabel.font = [UIFont systemFontOfSize:14];
    subLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subLabel];
    
    // Champ username
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 200, self.view.frame.size.width - 80, 50)];
    self.usernameField.placeholder = @"Nom d'utilisateur";
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.textColor = [UIColor blackColor];
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:self.usernameField];
    
    // Champ password
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(40, 270, self.view.frame.size.width - 80, 50)];
    self.passwordField.placeholder = @"Mot de passe";
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.textColor = [UIColor blackColor];
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    // Bouton login
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.frame = CGRectMake(40, 350, self.view.frame.size.width - 80, 50);
    [self.loginButton setTitle:@"SE CONNECTER" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
    self.loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.loginButton.layer.cornerRadius = 10;
    [self.loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    // Message d'erreur (caché au début)
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 420, self.view.frame.size.width - 80, 30)];
    errorLabel.text = @"⚠️ Login ou mot de passe incorrect";
    errorLabel.textColor = [UIColor redColor];
    errorLabel.font = [UIFont systemFontOfSize:12];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.tag = 999;
    errorLabel.hidden = YES;
    [self.view addSubview:errorLabel];
}

- (void)loginTapped {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    UILabel *errorLabel = (UILabel *)[self.view viewWithTag:999];
    
    // Vérification (tu peux changer les identifiants ici)
    if ([username isEqualToString:@"nexus"] && [password isEqualToString:@"admin"]) {
        // Login réussi
        isLoggedIn = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"✅ Connexion réussie - Cheats activés");
            [self showActivationMessage];
        }];
    } else {
        // Login échoué
        errorLabel.hidden = NO;
        
        // Faire trembler le champ
        [UIView animateWithDuration:0.1 animations:^{
            self.usernameField.transform = CGAffineTransformMakeTranslation(5, 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.usernameField.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)showActivationMessage {
    UIWindow *keyWindow = [self getKeyWindow];
    if (!keyWindow) return;
    
    UIView *toast = [[UIView alloc] initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100, 50)];
    toast.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    toast.layer.cornerRadius = 25;
    toast.layer.borderWidth = 1;
    toast.layer.borderColor = [UIColor greenColor].CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:toast.bounds];
    label.text = @"✅ NEXUS MOD ACTIVÉ - BONNE PARTIE !";
    label.textColor = [UIColor greenColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [toast addSubview:label];
    
    [keyWindow addSubview:toast];
    
    [UIView animateWithDuration:0.3 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toast.alpha = 0;
    } completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}

- (UIWindow *)getKeyWindow {
    if (@available(iOS 13, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
    }
    return nil;
}

@end

// === AFFICHER LE LOGIN AU DÉMARRAGE ===
%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!isLoggedIn && !loginVC) {
            loginVC = [[LoginViewController alloc] init];
            UIWindow *keyWindow = [self getKeyWindow];
            [keyWindow.rootViewController presentViewController:loginVC animated:YES completion:nil];
        }
    });
    
    return result;
}

- (UIWindow *)getKeyWindow {
    if (@available(iOS 13, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
    }
    return nil;
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

// === INIT ===
%ctor {
    NSLog(@"🔥 NEXUS MOD - En attente de login");
}