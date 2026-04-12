#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static UIWindow *menuWindow = nil;
static UIView *menuView = nil;
static UIVisualEffectView *blurView = nil;

// ============ COULEURS ============
static UIColor* NeonGreen() {
    return [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
}

static UIColor* NeonRed() {
    return [UIColor colorWithRed:1.0 green:0.2 blue:0.3 alpha:1.0];
}

static UIColor* NeonBlue() {
    return [UIColor colorWithRed:0.2 green:0.5 blue:1.0 alpha:1.0];
}

// ============ FENÊTRE PRINCIPALE ============
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

// ============ FONCTIONS DE TEST ============
__attribute__((used)) static void TestAlert() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"✅ TEST ALERTE" 
                                                                       message:@"Le dylib est bien injecté et fonctionne !" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

__attribute__((used)) static void TestRectangle() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        // Supprimer l'ancien rectangle s'il existe
        UIView *oldRect = [keyWindow viewWithTag:9999];
        [oldRect removeFromSuperview];
        
        // Créer un rectangle rouge
        UIView *rect = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 100, 100)];
        rect.backgroundColor = [UIColor redColor];
        rect.layer.borderWidth = 2;
        rect.layer.borderColor = [UIColor whiteColor].CGColor;
        rect.layer.cornerRadius = 10;
        rect.tag = 9999;
        [keyWindow addSubview:rect];
        
        // Disparaît après 2 secondes
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [rect removeFromSuperview];
        });
    });
}

__attribute__((used)) static void TestToast() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        UIView *toast = [[UIView alloc] initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100, 50)];
        toast.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        toast.layer.cornerRadius = 25;
        toast.layer.borderWidth = 1;
        toast.layer.borderColor = NeonGreen().CGColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:toast.bounds];
        label.text = @"✨ TOAST TEST - DYLIB ACTIF ✨";
        label.textColor = NeonGreen();
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [toast addSubview:label];
        
        [keyWindow addSubview:toast];
        
        [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toast.alpha = 0;
        } completion:^(BOOL finished) {
            [toast removeFromSuperview];
        }];
    });
}

__attribute__((used)) static void TestInfo() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        NSString *info = [NSString stringWithFormat:
            @"📱 APP: %@\n"
            @"🔧 iOS: %@\n"
            @"💉 DYLIB: INJECTÉ\n"
            @"🎮 STATUS: OK",
            [[NSBundle mainBundle] bundleIdentifier],
            [[UIDevice currentDevice] systemVersion]];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ℹ️ INFOS INJECTION" 
                                                                       message:info 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

__attribute__((used)) static void TestCrash() {
    // Test de sécurité : demande confirmation avant de crasher
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️ CRASH TEST" 
                                                                       message:@"Voulez-vous vraiment crasher l'application pour tester la stabilité ?" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"NON" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"OUI" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // Crash volontaire
            abort();
        }]];
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

// ============ EFFETS BOUTONS ============
__attribute__((used)) static void ButtonTouchDown(UIButton *sender) {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
        sender.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    }];
}

__attribute__((used)) static void ButtonTouchUp(UIButton *sender) {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformIdentity;
        sender.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    }];
}

// ============ DRAG MENU ============
__attribute__((used)) static void DragMenu(UIPanGestureRecognizer *gesture) {
    CGPoint translation = [gesture translationInView:menuWindow];
    CGRect newFrame = menuWindow.frame;
    newFrame.origin.x += translation.x;
    newFrame.origin.y += translation.y;
    
    if (newFrame.origin.x < 0) newFrame.origin.x = 0;
    if (newFrame.origin.y < 40) newFrame.origin.y = 40;
    if (newFrame.origin.x + newFrame.size.width > [UIScreen mainScreen].bounds.size.width) {
        newFrame.origin.x = [UIScreen mainScreen].bounds.size.width - newFrame.size.width;
    }
    if (newFrame.origin.y + newFrame.size.height > [UIScreen mainScreen].bounds.size.height - 50) {
        newFrame.origin.y = [UIScreen mainScreen].bounds.size.height - newFrame.size.height - 50;
    }
    
    menuWindow.frame = newFrame;
    [gesture setTranslation:CGPointZero inView:menuWindow];
}

// ============ CRÉATION DU MENU ============
static void CreateMenu() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        CGFloat menuWidth = 220;
        CGFloat menuHeight = 320;
        
        menuWindow = [[UIWindow alloc] initWithFrame:CGRectMake(20, 80, menuWidth, menuHeight)];
        menuWindow.backgroundColor = [UIColor clearColor];
        menuWindow.windowLevel = UIWindowLevelAlert + 2;
        menuWindow.hidden = NO;
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.frame = menuWindow.bounds;
        blurView.layer.cornerRadius = 20;
        blurView.clipsToBounds = YES;
        blurView.layer.borderWidth = 1;
        blurView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
        [menuWindow addSubview:blurView];
        
        menuView = [[UIView alloc] initWithFrame:menuWindow.bounds];
        menuView.backgroundColor = [UIColor clearColor];
        
        // Bandeau néon
        UIView *neonBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, 3)];
        neonBar.backgroundColor = NeonGreen();
        neonBar.layer.shadowColor = NeonGreen().CGColor;
        neonBar.layer.shadowRadius = 5;
        neonBar.layer.shadowOpacity = 1;
        [menuView addSubview:neonBar];
        
        // Titre
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, menuWidth, 30)];
        titleLabel.text = @"⚡ NEXUS MOD ⚡";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [menuView addSubview:titleLabel];
        
        // Sous-titre
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, menuWidth, 15)];
        subLabel.text = @"MENU DE TEST";
        subLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        subLabel.font = [UIFont systemFontOfSize:10];
        subLabel.textAlignment = NSTextAlignmentCenter;
        [menuView addSubview:subLabel];
        
        // Séparateur
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, 55, menuWidth - 20, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [menuView addSubview:separator];
        
        // Bouton 1 - TEST ALERTE
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn1.frame = CGRectMake(10, 70, menuWidth - 20, 40);
        btn1.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btn1.layer.cornerRadius = 10;
        [btn1 setTitle:@"✅ TEST ALERTE" forState:UIControlStateNormal];
        [btn1 setTitleColor:NeonGreen() forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn1 addTarget:nil action:@selector(ButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn1 addTarget:nil action:@selector(ButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 addTarget:nil action:@selector(TestAlert) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn1];
        
        // Bouton 2 - TEST RECTANGLE
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn2.frame = CGRectMake(10, 120, menuWidth - 20, 40);
        btn2.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btn2.layer.cornerRadius = 10;
        [btn2 setTitle:@"🔴 TEST RECTANGLE" forState:UIControlStateNormal];
        [btn2 setTitleColor:NeonRed() forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn2 addTarget:nil action:@selector(ButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn2 addTarget:nil action:@selector(ButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:nil action:@selector(TestRectangle) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn2];
        
        // Bouton 3 - TEST TOAST
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn3.frame = CGRectMake(10, 170, menuWidth - 20, 40);
        btn3.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btn3.layer.cornerRadius = 10;
        [btn3 setTitle:@"✨ TEST TOAST" forState:UIControlStateNormal];
        [btn3 setTitleColor:NeonBlue() forState:UIControlStateNormal];
        btn3.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn3 addTarget:nil action:@selector(ButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn3 addTarget:nil action:@selector(ButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addTarget:nil action:@selector(TestToast) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn3];
        
        // Bouton 4 - INFOS
        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn4.frame = CGRectMake(10, 220, menuWidth - 20, 40);
        btn4.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btn4.layer.cornerRadius = 10;
        [btn4 setTitle:@"ℹ️ INFOS INJECTION" forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn4.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn4 addTarget:nil action:@selector(ButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn4 addTarget:nil action:@selector(ButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [btn4 addTarget:nil action:@selector(TestInfo) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn4];
        
        // Bouton 5 - CRASH (danger)
        UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn5.frame = CGRectMake(10, 270, menuWidth - 20, 35);
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 setTitle:@"⚠️ CRASH TEST" forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn5.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn5 addTarget:nil action:@selector(TestCrash) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn5];
        
        // Handle
        UIView *dragHandle = [[UIView alloc] initWithFrame:CGRectMake(menuWidth/2 - 25, 305, 50, 4)];
        dragHandle.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
        dragHandle.layer.cornerRadius = 2;
        [menuView addSubview:dragHandle];
        
        [blurView.contentView addSubview:menuView];
        
        // Animation d'apparition
        menuWindow.transform = CGAffineTransformMakeScale(0.8, 0.8);
        menuWindow.alpha = 0;
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            menuWindow.transform = CGAffineTransformIdentity;
            menuWindow.alpha = 1;
        } completion:nil];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(DragMenu:)];
        [menuWindow addGestureRecognizer:pan];
    });
}

// ============ HOOK ============
%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateMenu();
    });
    
    return result;
}

%end