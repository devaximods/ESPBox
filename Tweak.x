%hook AppDelegate

- (BOOL)application:(id)application didFinishLaunchingWithOptions:(id)launchOptions {
    return %orig;
}

%end