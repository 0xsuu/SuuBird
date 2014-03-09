//
//  AppDelegate.m
//  SuuBird
//
//  Created by Suu on 3/7/14.
//  Copyright suu 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "DebugStat.h"

#import "AppDelegate.h"
#import "IntroScene.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupCocos2dWithOptions:@{CCSetupShowDebugStats: @(isDebugging),CCSetupScreenOrientation: CCScreenOrientationPortrait}];
	
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"Level"] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Level"];
    }
	return YES;
}

-(CCScene *)startScene
{
	return [IntroScene scene];
}

@end
