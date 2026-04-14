#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// === VARIABLES DES CHEATS ===
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL joyPlayerEnabled = NO;

static NSMutableArray *allContainers = nil;
static UIButton *secretButton = nil;
static BOOL switchesHidden = NO;

// === CLASSE CONTAINER DRAGGABLE ===
@interface DraggableContainer : UIView
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) UILabel *label;
@end

@implementation DraggableContainer

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        self.label.text = title;
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont boldSystemFontOfSize:11];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
        self.switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(frame.size.width/2 - 25, 22, 50, 35)];
        self.switchControl.on = NO;
        self.switchControl.onTintColor = [UIColor purpleColor];
        self.switchControl.tintColor = [UIColor redColor];
        [self.switchControl addTarget:nil action:action forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.switchControl];
        
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

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    self.switchControl.hidden = hidden;
    self.label.hidden = hidden;
}

@end

// === BOUTON SECRET DRAGGABLE ===
@interface SecretDraggableButton : UIButton
@end

@implementation SecretDraggableButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.layer.cornerRadius = frame.size.width / 2;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self setTitle:@"🔓" forState:UIControlStateNormal];
        
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

// === ACTIONS DES SWITCHES (fonctions globales) ===
void switchESPBox(UISwitch *sender) {
    espBoxEnabled = sender.isOn;
    NSLog(@"ESP BOX: %@", espBoxEnabled ? @"ON ✅" : @"OFF ❌");
}
void switchESPLine(UISwitch *sender) {
    espLineEnabled = sender.isOn;
    NSLog(@"ESP LINE: %@", espLineEnabled ? @"ON ✅" : @"OFF ❌");
}
void switchESPDistance(UISwitch *sender) {
    espDistanceEnabled = sender.isOn;
    NSLog(@"ESP DISTANCE: %@", espDistanceEnabled ? @"ON ✅" : @"OFF ❌");
}
void switchESPHealth(UISwitch *sender) {
    espHealthEnabled = sender.isOn;
    NSLog(@"ESP HEALTH: %@", espHealthEnabled ? @"ON ✅" : @"OFF ❌");
}
void switchJoyPlayer(UISwitch *sender) {
    joyPlayerEnabled = sender.isOn;
    NSLog(@"JOYPLAYER: %@", joyPlayerEnabled ? @"ON ✅" : @"OFF ❌");
}

// === SECRET MOD (fonction globale) ===
void toggleSecretMode() {
    switchesHidden = !switchesHidden;
    for (DraggableContainer *container in allContainers) {
        container.hidden = switchesHidden;
    }
    if (switchesHidden) {
        [secretButton setTitle:@"🔐" forState:UIControlStateNormal];
    } else {
        [secretButton setTitle:@"🔓" forState:UIControlStateNormal];
    }
    NSLog(@"SECRET MOD: %@", switchesHidden ? @"CACHÉ 🔐" : @"VISIBLE 🔓");
}

// === CRÉATION DE L'UI ===
static void CreateUI() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        allContainers = [NSMutableArray new];
        
        CGFloat containerW = 90;
        CGFloat containerH = 60;
        CGFloat startX = 20;
        CGFloat startY = 60;
        CGFloat spacing = 15;
        
        // Petit texte XSNPMODZZZ en haut à gauche
        UILabel *xsnLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 15)];
        xsnLabel.text = @"XSNPMODZZZ";
        xsnLabel.textColor = [UIColor colorWithRed:0.6 green:0.2 blue:1.0 alpha:0.7];
        xsnLabel.font = [UIFont systemFontOfSize:9];
        [root.view addSubview:xsnLabel];
        
        // Bouton SECRET MOD draggable
        secretButton = [[SecretDraggableButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 40, 40, 40)];
        [secretButton addTarget:nil action:@selector(toggleSecretMode) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:secretButton];
        
        // Ligne 1
        DraggableContainer *c1 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX, startY, containerW, containerH) title:@"ESP BOX" action:@selector(switchESPBox:)];
        [root.view addSubview:c1];
        [allContainers addObject:c1];
        
        DraggableContainer *c2 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX + containerW + spacing, startY, containerW, containerH) title:@"ESP LINE" action:@selector(switchESPLine:)];
        [root.view addSubview:c2];
        [allContainers addObject:c2];
        
        // Ligne 2
        CGFloat startY2 = startY + containerH + spacing;
        
        DraggableContainer *c3 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX, startY2, containerW, containerH) title:@"ESP DIST" action:@selector(switchESPDistance:)];
        [root.view addSubview:c3];
        [allContainers addObject:c3];
        
        DraggableContainer *c4 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX + containerW + spacing, startY2, containerW, containerH) title:@"ESP HEALTH" action:@selector(switchESPHealth:)];
        [root.view addSubview:c4];
        [allContainers addObject:c4];
        
        // Ligne 3
        CGFloat startY3 = startY2 + containerH + spacing;
        
        DraggableContainer *c5 = [[DraggableContainer alloc] initWithFrame:CGRectMake(startX, startY3, containerW, containerH) title:@"JOYPLAYER" action:@selector(switchJoyPlayer:)];
        [root.view addSubview:c5];
        [allContainers addObject:c5];
        
        NSLog(@"✅ UI créée : 5 switches + bouton secret");
    });
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateUI();
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;
}
%end