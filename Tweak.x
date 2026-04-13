#import <UIKit/UIKit.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Test" 
                                                                   message:@"EHHHHHH MERCIIIIIIII HINDOUUUUUU" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    return %orig;
}

%end