#import <UIKit/UIKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Afficher une alerte simple
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"✅ TEST" 
                                                     message:@"DYLIB ACTIF" 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil];
    [alert show];
    
    return result;
}

%end