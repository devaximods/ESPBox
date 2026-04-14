// Tweak.xm - MENU FLOTTANT GRIS TRANSPARENT SIMPLE - SEULEMENT ESP

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables ESP seulement
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL espSkeletonEnabled = NO;
BOOL espJoystickEnabled = NO;

@interface FloatingButton : UIButton
@end

@implementation FloatingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.8];
        self.layer.cornerRadius = 25;
        [self setTitle:@"X" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        
        [self addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

- (void)openMenu {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(30, 120, w - 60, 380)];
    panel.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.16 alpha:0.93];
    panel.layer.cornerRadius = 22;
    panel.layer.borderWidth = 2;
    panel.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.75 alpha:1.0].CGColor;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, panel.frame.size.width, 45)];
    title.text = @"XSNPMODZ";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:26];
    title.textAlignment = NSTextAlignmentCenter;
    [panel addSubview:title];
    
    [self addSwitch:@"ESP BOX" to:panel y:70 var:&espBoxEnabled];
    [self addSwitch:@"ESP LINE" to:panel y:110 var:&espLineEnabled];
    [self addSwitch:@"ESP DISTANCE" to:panel y:150 var:&espDistanceEnabled];
    [self addSwitch:@"ESP HEALTH" to:panel y:190 var:&espHealthEnabled];
    [self addSwitch:@"ESP SKELETON" to:panel y:230 var:&espSkeletonEnabled];
    [self addSwitch:@"JOYSTICK PLAYER" to:panel y:270 var:&espJoystickEnabled];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(30, 320, panel.frame.size.width - 60, 50);
    [closeBtn setTitle:@"CLOSE MENU" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
    closeBtn.layer.cornerRadius = 14;
    [closeBtn addTarget:panel action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:closeBtn];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:panel action:@selector(handlePan:)];
    [panel addGestureRecognizer:pan];
    
    UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    [root.view addSubview:panel];
}

- (void)addSwitch:(NSString *)label to:(UIView *)panel y:(CGFloat)y var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, y, 200, 40)];
    lbl.text = label;
    lbl.textColor = [UIColor whiteColor];
    [panel addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(panel.frame.size.width - 95, y + 6, 70, 35)];
    sw.on = *var;
    [panel addSubview:sw];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:gesture.view.superview];
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:gesture.view.superview];
}
@end

FloatingButton *floatingBtn = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!floatingBtn) {
            floatingBtn = [[FloatingButton alloc] initWithFrame:CGRectMake(30, 150, 50, 50)];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            if (root && root.view) {
                [root.view addSubview:floatingBtn];
                NSLog(@"[XSNPMODZ] 🔥 Bouton flottant + panneau gris stylé injecté");
            }
        }
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;  // PPX enlevé pour éviter les erreurs
}
%end