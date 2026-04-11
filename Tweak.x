#import <UIKit/UIKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Créer une fenêtre temporaire pour l'alerte
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *tempWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        tempWindow.windowLevel = UIWindowLevelAlert + 1;
        tempWindow.backgroundColor = [UIColor clearColor];
        tempWindow.hidden = NO;
        
        UIViewController *tempVC = [[UIViewController alloc] init];
        tempWindow.rootViewController = tempVC;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"✅ TEST" 
                                                                       message:@"DYLIB ACTIF" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            tempWindow.hidden = YES;
            tempWindow = nil;
        }]];
        
        [tempVC presentViewController:alert animated:YES completion:nil];
    });
    
    return result;
}

%end