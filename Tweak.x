#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return %orig;
}

%end