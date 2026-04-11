#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static UIWindow *menuWindow = nil;
static UIView *menuView = nil;
static BOOL isMenuExpanded = YES;
static UIVisualEffectView *blurView = nil;

// ============ EFFETS VISUELS ============

static UIColor* NeonGreen() {
    return [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];
}

static UIColor* NeonRed() {
    return [UIColor colorWithRed:1.0 green:0.2 blue:0.3 alpha:1.0];
}

static UIColor* DarkGlow() {
    return [UIColor colorWithWhite:0.1 alpha:0.95];
}

// Ajouter une lueur à un bouton
static void AddGlow(UIView *view, UIColor *color) {
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = CGSizeZero;
    view.layer.shadowRadius = 8;
    view.layer.shadowOpacity = 0.8;
}

// Animation de pulsation
static void PulseAnimation(UIView *view) {
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = 0.8;
    pulse.fromValue = [NSNumber numberWithFloat:1.0];
    pulse.toValue = [NSNumber numberWithFloat:1.05];
    pulse.autoreverses = YES;
    pulse.repeatCount = HUGE_VALF;
    [view.layer addAnimation:pulse forKey:@"pulse"];
}

// ============ ACTIONS DES BOUTONS ============

void ShowESP_PPX() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        // Toast notification stylée
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
        
        // Disparaît après 1.5 secondes
        [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toast.alpha = 0;
        } completion:^(BOOL finished) {
            [toast removeFromSuperview];
        }];
    });
}

void ShowESP_BOX() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        // Toast notification stylée
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

// ============ MENU PRINCIPAL ============

static void CreateStylishMenu() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow) return;
        
        CGFloat menuWidth = 200;
        CGFloat menuHeight = 280;
        CGFloat menuX = 20;
        CGFloat menuY = 80;
        
        // Fenêtre principale
        menuWindow = [[UIWindow alloc] initWithFrame:CGRectMake(menuX, menuY, menuWidth, menuHeight)];
        menuWindow.backgroundColor = [UIColor clearColor];
        menuWindow.windowLevel = UIWindowLevelAlert + 2;
        menuWindow.hidden = NO;
        
        // Effet de flou en arrière-plan (Glassmorphism)
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.frame = menuWindow.bounds;
        blurView.layer.cornerRadius = 20;
        blurView.clipsToBounds = YES;
        blurView.layer.borderWidth = 1;
        blurView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
        [menuWindow addSubview:blurView];
        
        // Conteneur principal
        menuView = [[UIView alloc] initWithFrame:menuWindow.bounds];
        menuView.backgroundColor = [UIColor clearColor];
        
        // Bandeau néon supérieur
        UIView *neonBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, 3)];
        neonBar.backgroundColor = NeonGreen();
        neonBar.layer.shadowColor = NeonGreen().CGColor;
        neonBar.layer.shadowRadius = 5;
        neonBar.layer.shadowOpacity = 1;
        [menuView addSubview:neonBar];
        
        // Titre avec icône
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, menuWidth, 30)];
        titleLabel.text = @"⚡ NEXUS MOD ⚡";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.shadowColor = NeonGreen();
        titleLabel.shadowOffset = CGSizeMake(0, 0);
        [menuView addSubview:titleLabel];
        
        // Ligne de séparation
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, 48, menuWidth - 20, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        [menuView addSubview:separator];
        
        // === BOUTON ESP PPX ===
        UIButton *btnPPX = [UIButton buttonWithType:UIButtonTypeSystem];
        btnPPX.frame = CGRectMake(15, 65, menuWidth - 30, 45);
        btnPPX.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btnPPX.layer.cornerRadius = 12;
        btnPPX.layer.borderWidth = 0.5;
        btnPPX.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
        
        // Effet de lueur au survol (simulé)
        [btnPPX addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btnPPX addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        // Icône et texte
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
        
        // === BOUTON ESP BOX ===
        UIButton *btnBOX = [UIButton buttonWithType:UIButtonTypeSystem];
        btnBOX.frame = CGRectMake(15, 120, menuWidth - 30, 45);
        btnBOX.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
        btnBOX.layer.cornerRadius = 12;
        btnBOX.layer.borderWidth = 0.5;
        btnBOX.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
        
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
        
        // === BOUTON CREDITS ===
        UIButton *btnCredits = [UIButton buttonWithType:UIButtonTypeSystem];
        btnCredits.frame = CGRectMake(15, 175, menuWidth - 30, 35);
        btnCredits.backgroundColor = [UIColor clearColor];
        [btnCredits setTitle:@"👤 NEXUS TEAM" forState:UIControlStateNormal];
        [btnCredits setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
        btnCredits.titleLabel.font = [UIFont systemFontOfSize:10];
        [menuView addSubview:btnCredits];
        
        // Handle pour déplacer le menu
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
        
        // Rendre le menu déplaçable
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(dragStylishMenu:)];
        [menuWindow addGestureRecognizer:pan];
    });
}

// Effets tactiles pour les boutons
void buttonTouchDown(UIButton *sender) {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
        sender.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    }];
}

void buttonTouchUp(UIButton *sender) {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformIdentity;
        sender.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    }];
}

// Déplacement du menu
void dragStylishMenu(UIPanGestureRecognizer *gesture) {
    CGPoint translation = [gesture translationInView:menuWindow];
    CGRect newFrame = menuWindow.frame;
    newFrame.origin.x += translation.x;
    newFrame.origin.y += translation.y;
    
    // Limites pour ne pas sortir de l'écran
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
    
    // Animation de rebond à la fin du geste
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            // Petit effet de rebond
        }];
    }
}

// ============ HOOK ============
%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Afficher le menu stylé après 1 seconde
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateStylishMenu();
    });
    
    return result;
}

%end