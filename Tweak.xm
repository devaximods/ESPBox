#import <UIKit/UIKit.h>

// ============ VARIABLES ============
static NSMutableArray *allButtons = nil;
static UIButton *secretButton = nil;
static BOOL buttonsHidden = NO;

// ============ RESET GUEST ============
static void ResetGuest() {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"✅ RESET GUEST" 
                                                                       message:@"Compte invité réinitialisé. Redémarre l'application." 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            exit(0);
        }]];
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        [root presentViewController:alert animated:YES completion:nil];
    });
}

// ============ ACTIONS (juste des logs) ============
void toggleESPBox() { NSLog(@"📦 ESP BOX toggled"); }
void toggleESPLine() { NSLog(@"📏 ESP LINE toggled"); }
void toggleESPDistance() { NSLog(@"📏 ESP DISTANCE toggled"); }
void toggleESPHealth() { NSLog(@"❤️ ESP HEALTH toggled"); }
void toggleAimbot() { NSLog(@"🎯 AIMBOT toggled"); }
void toggleSpinbot() { NSLog(@"🔄 SPINBOT toggled"); }

// === BOUTON DRAGGABLE ===
@interface DraggableButton : UIButton
@end

@implementation DraggableButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color action:(SEL)action {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.85];
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addTarget:nil action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

@end

// === BOUTON SECRET ===
@interface SecretButton : UIButton
@end

@implementation SecretButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.layer.cornerRadius = frame.size.width / 2;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self setTitle:@"🔓" forState:UIControlStateNormal];
        [self addTarget:self action:@selector(toggleSecret) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

- (void)toggleSecret {
    buttonsHidden = !buttonsHidden;
    for (UIView *btn in allButtons) btn.hidden = buttonsHidden;
    [self setTitle:buttonsHidden ? @"🔐" : @"🔓" forState:UIControlStateNormal];
}

@end

// === CRÉATION DE L'UI ===
static void CreateUI() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        allButtons = [NSMutableArray new];
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        CGFloat btnW = 100, btnH = 40;
        
        // Texte XSNPMODZZZ
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 15)];
        xsnLabel.text = @"XSNPMODZZZ";
        xsnLabel.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.7];
        xsnLabel.font = [UIFont systemFontOfSize:9];
        [root.view addSubview:xsnLabel];
        
        // Bouton secret
        secretButton = [[SecretButton alloc] initWithFrame:CGRectMake(screenW - 50, 45, 40, 40)];
        [root.view addSubview:secretButton];
        
        // 7 boutons
        NSArray *titles = @[@"ESP BOX", @"ESP LINE", @"ESP DIST", @"ESP HEALTH", @"AIMBOT", @"SPINBOT", @"RESET GUEST"];
        NSArray *actions = @[@selector(toggleESPBox), @selector(toggleESPLine), @selector(toggleESPDistance), @selector(toggleESPHealth), @selector(toggleAimbot), @selector(toggleSpinbot), @selector(ResetGuest)];
        NSArray *positions = @[
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 100, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(20, 180, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 20, 180, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, 270, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(20, screenH - 150, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW - btnW - 20, screenH - 150, btnW, btnH)],
            [NSValue valueWithCGRect:CGRectMake(screenW/2 - btnW/2, screenH - 90, btnW, btnH)]
        ];
        
        for (int i = 0; i < 7; i++) {
            DraggableButton *btn = [[DraggableButton alloc] initWithFrame:[positions[i] CGRectValue] title:titles[i] color:[UIColor whiteColor] action:actions[i]];
            [root.view addSubview:btn];
            [allButtons addObject:btn];
        }
        
        NSLog(@"✅ UI créée - 7 boutons (sans hooks mémoire)");
    });
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateUI();
    });
}