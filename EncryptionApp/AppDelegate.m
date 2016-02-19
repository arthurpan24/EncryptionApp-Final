//
//  AppDelegate.m
//  EncryptionApp
//
//  Created by Arthur Pan on 2/16/16.
//  Copyright © 2016 Arthur Pan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "EncodingViewController.h"
#import "DecodingViewController.h"
#import "SieveOfEratosthenes.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SieveOfEratosthenes *pointer = [[SieveOfEratosthenes alloc] initWithSize:1000]; //up to user to set how many primes you want
    NSBundle *appBundle = [NSBundle mainBundle];
    
    DecodingViewController *dvc = [[DecodingViewController alloc] initWithNibName:@"DecodingViewController" bundle:appBundle];
    EncodingViewController *evc = [[EncodingViewController alloc] initWithNibName:@"EncodingViewController" bundle:appBundle];
    
    [evc initArrayOfPrimes:[pointer returnShortArrayOfPrimes] withSize:[pointer returnSize]]; //generate primes before opening evc
    [evc generateKeys]; //generate keys before any user input is done
    
    [dvc initializeN:[evc getN] andE:[evc getE] andD:[evc getD]]; //initialize dvc with the keys provided by evc
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[evc, dvc];
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
