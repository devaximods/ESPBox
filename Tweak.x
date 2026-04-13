#import <UIKit/UIKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"✅" 
                                                                       message:@"DYLIB ACTIF" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        // Méthode safe pour afficher l'alerte
        UIViewController *root = application.windows.firstObject.rootViewController;
        [root presentViewController:alert animated:YES completion:nil];
    });
    return %orig;
}

%end