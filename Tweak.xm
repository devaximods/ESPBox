// Tweak.xm - VERSION SIMPLE ET PROPRE - 3 CLICS + MENU GRIS

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

BOOL menuOpen = NO;
int tapCount = 0;

BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL espSkeletonEnabled = NO;
BOOL espJoystickEnabled = NO;

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIView *rootView = [[[UIApplication sharedApplication] windows] firstObject].rootViewController.view;
            NSArray *messages = @[@"G@@@@@@T HACKEDDDDDDDDDDD", @"XSNPMODZ OWNED", @"YOU ARE FUCKED"];
            for (int i = 0; i < 3; i++) {
                UILabel *hack = [[UILabel alloc] initWithFrame:CGRectMake(20, 80 + i*110, rootView.frame.size.width - 40, 70)];
                hack.text = messages[i];
                hack.textColor = [UIColor redColor];
                hack.font = [UIFont boldSystemFontOfSize:26 + i*2];
                hack.textAlignment = NSTextAlignmentCenter;
                hack.alpha = 0.9;
                [rootView addSubview:hack];
            }
        });
    });
}
%end

%hook UIWindow

- (void)sendEvent:(UIEvent *)event {
    %orig;
    if (event.allTouches.count > 0) {
        UITouch *touch = [event.allTouches anyObject];
        if (touch.phase == UITouchPhaseEnded) {
            tapCount++;
            if (tapCount >= 3) {
                tapCount = 0;
                // OUVERTURE DU MENU
                if (menuOpen) return;
                menuOpen = YES;
                
                CGFloat w = [[UIScreen mainScreen] bounds].size.width;
                UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(30, 100, w - 60, 460)];
                panel.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.16 alpha:0.93];
                panel.layer.cornerRadius = 24;
                panel.layer.borderWidth = 2.5;
                panel.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.75 alpha:1.0].CGColor;
                
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, panel.frame.size.width, 45)];
                title.text = @"XSNPMODZ";
                title.textColor = [UIColor whiteColor];
                title.font = [UIFont boldSystemFontOfSize:28];
                title.textAlignment = NSTextAlignmentCenter;
                [panel addSubview:title];
                
                // Switches ESP seulement
                [self addSwitchToPanel:panel label:@"ESP BOX" y:80 var:&espBoxEnabled];
                [self addSwitchToPanel:panel label:@"ESP LINE" y:130 var:&espLineEnabled];
                [self addSwitchToPanel:panel label:@"ESP DISTANCE" y:180 var:&espDistanceEnabled];
                [self addSwitchToPanel:panel label:@"ESP HEALTH" y:230 var:&espHealthEnabled];
                [self addSwitchToPanel:panel label:@"ESP SKELETON" y:280 var:&espSkeletonEnabled];
                [self addSwitchToPanel:panel label:@"JOYSTICK PLAYER" y:330 var:&espJoystickEnabled];
                
                UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                closeBtn.frame = CGRectMake(25, 370, panel.frame.size.width - 50, 55);
                [closeBtn setTitle:@"CLOSE MENU" forState:UIControlStateNormal];
                closeBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
                closeBtn.layer.cornerRadius = 16;
                [closeBtn addTarget:panel action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
                [panel addSubview:closeBtn];
                
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:panel action:@selector(handlePan:)];
                [panel addGestureRecognizer:pan];
                
                UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
                [root.view addSubview:panel];
            }
        }
    }
}

- (void)addSwitchToPanel:(UIView *)panel label:(NSString *)label y:(CGFloat)y var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 210, 40)];
    lbl.text = label;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:16.5];
    [panel addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(panel.frame.size.width - 95, y + 6, 70, 35)];
    sw.on = *var;
    [panel addSubview:sw];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint trans = [gesture translationInView:gesture.view.superview];
    gesture.view.center = CGPointMake(gesture.view.center.x + trans.x, gesture.view.center.y + trans.y);
    [gesture setTranslation:CGPointZero inView:gesture.view.superview];
}

%end

%ctor {
    NSLog(@"[XSNPMODZ] 🔥 Menu gris transparent + 3 clics + message HACKED injecté");
}