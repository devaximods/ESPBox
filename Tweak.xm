// Tweak.xm - XSNPMODZMENU TEXTE VIOLET FLOTTANT + BOUTONS QUI SORTENT

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// Variables ESP
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL espSkeletonEnabled = NO;
BOOL espJoystickEnabled = NO;

@interface FloatingText : UILabel
@end

@implementation FloatingText
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = @"XSNPMODZMENU";
        self.textColor = [UIColor colorWithRed:0.6 green:0.0 blue:1.0 alpha:1.0]; // violet
        self.font = [UIFont boldSystemFontOfSize:22];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleButtons)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

- (void)toggleButtons {
    static UIView *buttonPanel = nil;
    if (buttonPanel && buttonPanel.superview) {
        [buttonPanel removeFromSuperview];
        buttonPanel = nil;
    } else {
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        buttonPanel = [[UIView alloc] initWithFrame:CGRectMake(40, 180, w - 80, 380)];
        buttonPanel.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.15 alpha:0.92];
        buttonPanel.layer.cornerRadius = 20;
        buttonPanel.layer.borderWidth = 2;
        buttonPanel.layer.borderColor = [UIColor colorWithRed:0.7 green:0.3 blue:1.0 alpha:1.0].CGColor;
        
        [self addSwitch:@"ESP BOX" to:buttonPanel y:30 var:&espBoxEnabled];
        [self addSwitch:@"ESP LINE" to:buttonPanel y:80 var:&espLineEnabled];
        [self addSwitch:@"ESP DISTANCE" to:buttonPanel y:130 var:&espDistanceEnabled];
        [self addSwitch:@"ESP HEALTH" to:buttonPanel y:180 var:&espHealthEnabled];
        [self addSwitch:@"ESP SKELETON" to:buttonPanel y:230 var:&espSkeletonEnabled];
        [self addSwitch:@"JOYSTICK PLAYER" to:buttonPanel y:280 var:&espJoystickEnabled];
        
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        [root.view addSubview:buttonPanel];
    }
}

- (void)addSwitch:(NSString *)label to:(UIView *)panel y:(CGFloat)y var:(BOOL *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 200, 40)];
    lbl.text = label;
    lbl.textColor = [UIColor whiteColor];
    [panel addSubview:lbl];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(panel.frame.size.width - 100, y + 6, 70, 35)];
    sw.on = *var;
    [panel addSubview:sw];
}
@end

FloatingText *floatingText = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (!floatingText) {
            floatingText = [[FloatingText alloc] initWithFrame:CGRectMake(80, 80, 220, 40)];
            UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
            if (root && root.view) {
                [root.view addSubview:floatingText];
                NSLog(@"[XSNPMODZ] 🔥 Texte violet flottant + boutons qui sortent injecté");
            }
        }
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;
}
%end