#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// === VARIABLES DES CHEATS ===
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL joyPlayerEnabled = NO;
BOOL buttonsHidden = NO;

static NSMutableArray *allButtons = nil;

// === CLASSE BOUTON DRAGGABLE ===
@interface DraggableButton : UIButton
@property (nonatomic, copy) NSString *cheatName;
@property (nonatomic, strong) UIColor *originalColor;
@end

@implementation DraggableButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.cheatName = title;
        self.originalColor = color;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.95];
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = color.CGColor;
        
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

- (void)setActive:(BOOL)active {
    if (active) {
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.9];
        self.layer.borderColor = [UIColor greenColor].CGColor;
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.95];
        self.layer.borderColor = self.originalColor.CGColor;
    }
}

@end

// === ACTIONS DES BOUTONS ===
void toggleESPBox(UIButton *sender) {
    espBoxEnabled = !espBoxEnabled;
    [(DraggableButton *)sender setActive:espBoxEnabled];
    NSLog(@"ESP BOX: %@", espBoxEnabled ? @"ON ✅" : @"OFF ❌");
}
void toggleESPLine(UIButton *sender) {
    espLineEnabled = !espLineEnabled;
    [(DraggableButton *)sender setActive:espLineEnabled];
    NSLog(@"ESP LINE: %@", espLineEnabled ? @"ON ✅" : @"OFF ❌");
}
void toggleESPDistance(UIButton *sender) {
    espDistanceEnabled = !espDistanceEnabled;
    [(DraggableButton *)sender setActive:espDistanceEnabled];
    NSLog(@"ESP DISTANCE: %@", espDistanceEnabled ? @"ON ✅" : @"OFF ❌");
}
void toggleESPHealth(UIButton *sender) {
    espHealthEnabled = !espHealthEnabled;
    [(DraggableButton *)sender setActive:espHealthEnabled];
    NSLog(@"ESP HEALTH: %@", espHealthEnabled ? @"ON ✅" : @"OFF ❌");
}
void toggleJoyPlayer(UIButton *sender) {
    joyPlayerEnabled = !joyPlayerEnabled;
    [(DraggableButton *)sender setActive:joyPlayerEnabled];
    NSLog(@"JOYPLAYER: %@", joyPlayerEnabled ? @"ON ✅" : @"OFF ❌");
}

void toggleSecretMode(UIButton *sender) {
    buttonsHidden = !buttonsHidden;
    for (UIView *btn in allButtons) {
        if (btn != sender) {
            btn.hidden = buttonsHidden;
        }
    }
    if (buttonsHidden) {
        [sender setTitle:@"🔓 SECRET MOD" forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:0.9];
    } else {
        [sender setTitle:@"🔒 SECRET MOD" forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.95];
    }
    NSLog(@"SECRET MOD: %@", buttonsHidden ? @"CACHÉ 🔒" : @"VISIBLE 🔓");
}

// === TEXTE FIXE EN HAUT ===
static void CreateFixedText() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        UILabel *fixedText = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 30)];
        fixedText.text = @"⚡ XSNPMODZ@@@ ⚡";
        fixedText.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:1.0 alpha:1.0];
        fixedText.font = [UIFont boldSystemFontOfSize:18];
        fixedText.textAlignment = NSTextAlignmentCenter;
        fixedText.backgroundColor = [UIColor clearColor];
        fixedText.userInteractionEnabled = NO;
        [root.view addSubview:fixedText];
    });
}

// === CRÉATION DES BOUTONS ===
static void CreateButtons() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        allButtons = [NSMutableArray new];
        
        CGFloat startY = 90;
        CGFloat btnWidth = 120;
        CGFloat btnHeight = 44;
        CGFloat margin = 10;
        
        // Bouton SECRET MOD (en haut à droite, spécial)
        DraggableButton *btnSecret = [[DraggableButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 40, 120, 40) title:@"🔒 SECRET MOD" color:[UIColor purpleColor]];
        [btnSecret addTarget:nil action:@selector(toggleSecretMode:) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnSecret];
        [allButtons addObject:btnSecret];
        
        // Ligne 1
        DraggableButton *btnESPBox = [[DraggableButton alloc] initWithFrame:CGRectMake(15, startY, btnWidth, btnHeight) title:@"ESP BOX" color:[UIColor cyanColor]];
        [btnESPBox addTarget:nil action:@selector(toggleESPBox:) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPBox];
        [allButtons addObject:btnESPBox];
        
        DraggableButton *btnESPLine = [[DraggableButton alloc] initWithFrame:CGRectMake(15 + btnWidth + margin, startY, btnWidth, btnHeight) title:@"ESP LINE" color:[UIColor cyanColor]];
        [btnESPLine addTarget:nil action:@selector(toggleESPLine:) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPLine];
        [allButtons addObject:btnESPLine];
        
        // Ligne 2
        CGFloat startY2 = startY + btnHeight + margin;
        
        DraggableButton *btnESPDistance = [[DraggableButton alloc] initWithFrame:CGRectMake(15, startY2, btnWidth, btnHeight) title:@"ESP DIST" color:[UIColor cyanColor]];
        [btnESPDistance addTarget:nil action:@selector(toggleESPDistance:) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPDistance];
        [allButtons addObject:btnESPDistance];
        
        DraggableButton *btnESPHealth = [[DraggableButton alloc] initWithFrame:CGRectMake(15 + btnWidth + margin, startY2, btnWidth, btnHeight) title:@"ESP HEALTH" color:[UIColor cyanColor]];
        [btnESPHealth addTarget:nil action:@selector(toggleESPHealth:) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnESPHealth];
        [allButtons addObject:btnESPHealth];
        
        // Ligne 3
        CGFloat startY3 = startY2 + btnHeight + margin;
        
        DraggableButton *btnJoyPlayer = [[DraggableButton alloc] initWithFrame:CGRectMake(15, startY3, btnWidth, btnHeight) title:@"JOYPLAYER" color:[UIColor magentaColor]];
        [btnJoyPlayer addTarget:nil action:@selector(toggleJoyPlayer:) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:btnJoyPlayer];
        [allButtons addObject:btnJoyPlayer];
        
        NSLog(@"✅ 6 boutons créés (5 ESP + SECRET MOD) + texte fixe");
    });
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateFixedText();
        CreateButtons();
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;
}
%end