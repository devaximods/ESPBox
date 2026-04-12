#import <UIKit/UIKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Écrire dans la console (visible dans Xcode ou Console.app)
    NSLog(@"========================================");
    NSLog(@"✅ STANDOFF 2 - DYLIB INJECTÉ AVEC SUCCÈS !");
    NSLog(@"✅ Menu de test chargé");
    NSLog(@"========================================");
    
    return result;
}

%end