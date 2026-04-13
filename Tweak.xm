// Tweak.xm - XSNPMODZ MENU iOS STYLE GRIS TRANSPARENT + 3 CLICS + MESSAGE HACKED

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables
BOOL menuOpen = NO;
int tapCount = 0;

// Message HACKED qui apparaît partout au lancement
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UILabel *hackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 80)];
            hackLabel.text = @"G@@@@@@T HACKEDDDDDDDDDDD";
            hackLabel.textColor = [UIColor redColor];
            hackLabel.font = [UIFont boldSystemFontOfSize:28];
            hackLabel.textAlignment = NSTextAlignmentCenter;
            hackLabel.alpha = 0.9;
            hackLabel.tag = 666;
            [[[UIApplication sharedApplication] windows] firstObject].rootViewController.view addSubview:hackLabel];
            
            // Duplique le message un peu partout pour l’effet "partout"
            for (int i = 1; i < 4; i++) {
                UILabel *copy = [hackLabel copy];
                copy.frame = CGRectMake(20, 200 + i*120, [[UIScreen mainScreen] bounds].size.width - 40, 60);
                copy.font = [UIFont boldSystemFontOfSize:22];
                [[[UIApplication sharedApplication] windows] firstObject].rootViewController.view addSubview:copy];
            }
        });
    });
}
%end

// Détection 3 taps n’importe où sur l’écran
%hook UIWindow
- (void)sendEvent:(UIEvent *)event {
    %orig;
    
    if (event.allTouches.count > 0) {
        UITouch *touch = event.allTouches.anyObject;
        if (touch.phase == UITouchPhaseEnded) {
            tapCount++;
            if (tapCount >= 3) {
                tapCount = 0;
                [self showXSNPMODZMenu];
            }
        }
    }
}

- (void)showXSNPMODZMenu {
    if (menuOpen) return;
    menuOpen = YES;
    
    UIView *menuPanel = [[UIView alloc] initWithFrame:CGRectMake(40, 120, [[UIScreen mainScreen] bounds].size.width - 80, 420)];
    menuPanel.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:0.92];
    menuPanel.layer.cornerRadius = 22;
    menuPanel.layer.borderWidth = 2;
    menuPanel.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.65 alpha:1.0].CGColor;
    menuPanel.layer.shadowColor = [UIColor grayColor].CGColor;
    menuPanel.layer.shadowRadius = 15;
    menuPanel.layer.shadowOpacity = 0.6;
    
    // Titre
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, menuPanel.frame.size.width, 50)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:26];
    title.textAlignment = NSTextAlignmentCenter;
    [menuPanel addSubview:title];
    
    // Switches stylés
    [self addSwitchTo:menuPanel label:@"Aimbot (Tête auto)" y:80 var:&aimbotEnabled];
    [self addSwitchTo:menuPanel label:@"ESP BOX" y:130 var:&espBoxEnabled];
    [self addSwitchTo:menuPanel label:@"ESP LINE" y:180 var:&espLineEnabled];
    [self addSwitchTo:menuPanel label:@"ESP DISTANCE" y:230 var:&espDistanceEnabled];
    [self addSwitchTo:menuPanel label:@"PPX Achats Gratuits" y:280 var:&ppxEnabled];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(30, 340, menuPanel.frame.size.width - 60, 55);
    [closeBtn setTitle:@"CLOSE MENU" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
    closeBtn.layer.cornerRadius = 14;
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [closeBtn addTarget:menuPanel action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [menuPanel addSubview:closeBtn];
    
    UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    [root.view addSubview:menuPanel];
    
    // Permet de bouger le panneau
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:menuPanel action:@selector(handlePan:)];
    [menuPanel addGestureRecognizer:pan];
}

- (void)addSwitchTo:(UIView *)panel label:(NSString *)label y:(CGFloat)y var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 200, 40)];
    lbl.text = label;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:17];
    [panel addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(panel.frame.size.width - 90, y + 6, 70, 35)];
    sw.on = *var;
    [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [panel addSubview:sw];
}

- (void)switchChanged:(UISwitch *)sw {
    // variables mises à jour
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:gesture.view.superview];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:gesture.view.superview];
}
%end

%ctor {
    NSLog(@"[XSNPMODZ] 🔥 Menu gris transparent iOS + 3 clics + message HACKED injecté");
}