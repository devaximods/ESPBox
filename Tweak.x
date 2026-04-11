#import <UIKit/UIKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Attendre 1 seconde que l'application soit prête
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // Créer l'alerte
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"✅ TEST" 
                                                                       message:@"DYLIB ACTIF" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        // Méthode simple pour afficher l'alerte
        [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    
    return result;
}

%end