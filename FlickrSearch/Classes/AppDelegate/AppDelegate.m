//
//  AppDelegate.m
//  FlickrSearch
//
//  Created by Ovidiu Rățoi on 10/06/15.
//
//

#import "AppDelegate.h"

#import "ImageSearchController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *documentsFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSLog(@"'%@' did finish launching at path:\n\n%@\n\n\n", appName, documentsFolderPath);

    ImageSearchController *ctrl = [[ImageSearchController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [navCtrl setNavigationBarHidden:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
