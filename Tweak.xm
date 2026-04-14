#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// === VARIABLES DES CHEATS ===
BOOL espBoxEnabled = NO;
BOOL espLineEnabled = NO;
BOOL espDistanceEnabled = NO;
BOOL espHealthEnabled = NO;
BOOL joyPlayerEnabled = NO;
BOOL switchesHidden = NO;

static NSMutableArray *allSwitches = nil;
static NSMutableArray *allLabels = nil;
static UILabel *secretLabel = nil;

// === FONCTION POUR CRÉER UN SWITCH AVEC LABEL ===
static void AddSwitch(UIView *parent, NSString *title, CGFloat x, CGFloat y, BOOL *var, SEL action) {
    // Label au-dessus du switch
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    [parent addSubview:label];
    [allLabels addObject:label];
    
    // Switch ON/OFF
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(x + 10, y + 22, 100, 35)];
    sw.on = *var;
    sw.onTintColor = [UIColor purpleColor];  // ON = violet
    sw.tintColor = [UIColor redColor];       // OFF = rouge
    sw.tag = (NSInteger)var;
    [sw addTarget:nil action:action forControlEvents:UIControlEventValueChanged];
    [parent addSubview:sw];
    [allSwitches addObject:sw];
}

// === ACTIONS DES SWITCHES ===
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

// === SECRET MOD (clic sur le petit texte) ===
void toggleSecretMode() {
    switchesHidden = !switchesHidden;
    for (UISwitch *sw in allSwitches) {
        sw.hidden = switchesHidden;
    }
    for (UILabel *lbl in allLabels) {
        lbl.hidden = switchesHidden;
    }
    if (switchesHidden) {
        secretLabel.text = @"🔒";
    } else {
        secretLabel.text = @"XSNPMODZZZ";
    }
    NSLog(@"SECRET MOD: %@", switchesHidden ? @"CACHÉ" : @"VISIBLE");
}

// === TEXTE SECRET MOD (tout petit) ===
static void CreateSecretText(UIView *parent) {
    secretLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    secretLabel.text = @"XSNPMODZZZ";
    secretLabel.textColor = [UIColor colorWithRed:0.7 green:0.3 blue:1.0 alpha:1.0];
    secretLabel.font = [UIFont systemFontOfSize:10];  // TOUT PETIT
    secretLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:nil action:@selector(toggleSecretMode)];
    [secretLabel addGestureRecognizer:tap];
    
    [parent addSubview:secretLabel];
}

// === CRÉATION DE TOUS LES SWITCHES ===
static void CreateSwitches() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
        if (!root || !root.view) return;
        
        allSwitches = [NSMutableArray new];
        allLabels = [NSMutableArray new];
        
        // Petit texte secret en haut à gauche
        CreateSecretText(root.view);
        
        // Switches organisés en grille
        CGFloat startX = 20;
        CGFloat startY = 60;
        CGFloat switchWidth = 90;
        CGFloat spacing = 10;
        
        // Ligne 1
        AddSwitch(root.view, @"ESP BOX", startX, startY, &espBoxEnabled, @selector(switchESPBox:));
        AddSwitch(root.view, @"ESP LINE", startX + switchWidth + spacing, startY, &espLineEnabled, @selector(switchESPLine:));
        
        // Ligne 2
        CGFloat startY2 = startY + 75;
        AddSwitch(root.view, @"ESP DIST", startX, startY2, &espDistanceEnabled, @selector(switchESPDistance:));
        AddSwitch(root.view, @"ESP HEALTH", startX + switchWidth + spacing, startY2, &espHealthEnabled, @selector(switchESPHealth:));
        
        // Ligne 3
        CGFloat startY3 = startY2 + 75;
        AddSwitch(root.view, @"JOYPLAYER", startX, startY3, &joyPlayerEnabled, @selector(switchJoyPlayer:));
        
        NSLog(@"✅ 5 switches ESP créés + secret mod");
    });
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CreateSwitches();
    });
}

%hook SKPaymentQueue
- (void)addPayment:(SKPayment *)payment {
    %orig;
}
%end