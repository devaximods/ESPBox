%hook AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Créer un fichier sur l'iPhone pour confirmer l'injection
    NSString *path = @"/tmp/standoff2_injected.txt";
    [@"INJECTED" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return result;
}

%end