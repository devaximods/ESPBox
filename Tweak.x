#import <UIKit/UIKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Afficher l'alerte après 1 seconde
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"✅ TEST" 
                                                                       message:@"DYLIB ACTIF" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        // Trouver la fenêtre active
        UIViewController *rootVC = nil;
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.rootViewController) {
                rootVC = window.rootViewController;
                break;
            }
        }
        
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
    
    return result;
}

%end