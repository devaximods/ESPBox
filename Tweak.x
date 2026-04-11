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

// ============ FONCTION POUR OBTENIR LA KEY WINDOW (moderne iOS 13+) ============
static UIWindow* GetKeyWindow() {
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in scene.windows) {
                if (window.isKeyWindow) {
                    return window;
                }
            }
        }
    }
    return nil;
}

// ============ ACTIONS DES BOUTONS ============
static void ShowESP_PPX() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        UIView *toast = [[UIView alloc] initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100, 50)];
        toast.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        toast.layer.cornerRadius = 25;
        toast.layer.borderWidth = 1;
        toast.layer.borderColor = NeonGreen().CGColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:toast.bounds];
        label.text = @"🔴 ESP PPX ACTIVÉ";
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

static void ShowESP_BOX() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        UIView *toast = [[UIView alloc] initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100, 50)];
        toast.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        toast.layer.cornerRadius = 25;
        toast.layer.borderWidth = 1;
        toast.layer.borderColor = NeonRed().CGColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:toast.bounds];
        label.text = @"📦 ESP BOX ACTIVÉ";
        label.textColor = NeonRed();
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

// ============ EFFETS BOUTONS ============
static void ButtonTouchDown(UIButton *sender) {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
        sender.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    }];
}

static void ButtonTouchUp(UIButton *sender) {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformIdentity;
        sender.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    }];
}

// ============ DRAG MENU ============
static void DragMenu(UIPanGestureRecognizer *gesture) {
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
static void CreateStylishMenu() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = GetKeyWindow();
        if (!keyWindow) return;
        
        CGFloat menuWidth = 200;
        CGFloat menuHeight = 280;
        
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
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, menuWidth, 30)];
        titleLabel.text = @"⚡ NEXUS MOD ⚡";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [menuView addSubview:titleLabel];
        
        // Séparateur
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, 48, menuWidth - 20, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [menuView addSubview:separator];
        
        // Bouton ESP PPX
        UIButton *btnPPX = [UIButton buttonWithType:UIButtonTypeSystem];
        btnPPX.frame = CGRectMake(15, 65, menuWidth - 30, 45);
        btnPPX.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btnPPX.layer.cornerRadius = 12;
        btnPPX.layer.borderWidth = 0.5;
        btnPPX.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
        [btnPPX addTarget:nil action:@selector(ButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btnPPX addTarget:nil action:@selector(ButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *ppxIcon = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 30, 45)];
        ppxIcon.text = @"🔴";
        ppxIcon.font = [UIFont systemFontOfSize:20];
        ppxIcon.textAlignment = NSTextAlignmentCenter;
        [btnPPX addSubview:ppxIcon];
        
        UILabel *ppxLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 45)];
        ppxLabel.text = @"ESP POINTS";
        ppxLabel.textColor = [UIColor whiteColor];
        ppxLabel.font = [UIFont boldSystemFontOfSize:14];
        [btnPPX addSubview:ppxLabel];
        
        UILabel *ppxStatus = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 30, 45)];
        ppxStatus.text = @"OFF";
        ppxStatus.textColor = NeonGreen();
        ppxStatus.font = [UIFont boldSystemFontOfSize:11];
        ppxStatus.textAlignment = NSTextAlignmentCenter;
        [btnPPX addSubview:ppxStatus];
        
        [btnPPX addTarget:nil action:@selector(ShowESP_PPX) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btnPPX];
        
        // Bouton ESP BOX
        UIButton *btnBOX = [UIButton buttonWithType:UIButtonTypeSystem];
        btnBOX.frame = CGRectMake(15, 120, menuWidth - 30, 45);
        btnBOX.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btnBOX.layer.cornerRadius = 12;
        btnBOX.layer.borderWidth = 0.5;
        btnBOX.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
        [btnBOX addTarget:nil action:@selector(ButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btnBOX addTarget:nil action:@selector(ButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *boxIcon = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 30, 45)];
        boxIcon.text = @"📦";
        boxIcon.font = [UIFont systemFontOfSize:20];
        boxIcon.textAlignment = NSTextAlignmentCenter;
        [btnBOX addSubview:boxIcon];
        
        UILabel *boxLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 45)];
        boxLabel.text = @"ESP BOX";
        boxLabel.textColor = [UIColor whiteColor];
        boxLabel.font = [UIFont boldSystemFontOfSize:14];
        [btnBOX addSubview:boxLabel];
        
        UILabel *boxStatus = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 30, 45)];
        boxStatus.text = @"OFF";
        boxStatus.textColor = NeonGreen();
        boxStatus.font = [UIFont boldSystemFontOfSize:11];
        boxStatus.textAlignment = NSTextAlignmentCenter;
        [btnBOX addSubview:boxStatus];
        
        [btnBOX addTarget:nil action:@selector(ShowESP_BOX) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btnBOX];
        
        // Credits
        UIButton *btnCredits = [UIButton buttonWithType:UIButtonTypeSystem];
        btnCredits.frame = CGRectMake(15, 175, menuWidth - 30, 35);
        btnCredits.backgroundColor = [UIColor clearColor];
        [btnCredits setTitle:@"👤 NEXUS TEAM" forState:UIControlStateNormal];
        [btnCredits setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
        btnCredits.titleLabel.font = [UIFont systemFontOfSize:10];
        [menuView addSubview:btnCredits];
        
        // Handle
        UIView *dragHandle = [[UIView alloc] initWithFrame:CGRectMake(menuWidth/2 - 25, 220, 50, 4)];
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
        CreateStylishMenu();
    });
    
    return result;
}

%end