//
//  AboutScene.m
//  SuuBird
//
//  Created by Suu on 3/7/14.
//  Copyright 2014 suu. All rights reserved.
//

#import "AboutScene.h"
#import "IntroScene.h"

@implementation AboutScene

+ (AboutScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    //Create a background
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:1.0f]];
    [self addChild:background];
    
    //Create a label
    CCLabelTTF *about = [CCLabelTTF labelWithString:@"About" fontName:@"STHeitiK-Light" fontSize:20.0f];
    about.positionType = CCPositionTypeNormalized;
    about.color = [CCColor whiteColor];
    about.position = ccp(0.5f, 0.9f);
    [self addChild:about];
    
    //Create a label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"A game made by Suu\n\nAnd\nspecial thanks\nFool Bird\nfor the name" fontName:@"STHeitiK-Light" fontSize:16.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.5f);
    [self addChild:label];
    
    //Create a label
    CCLabelTTF *version = [CCLabelTTF labelWithString:@"version: 0.1beta" fontName:@"STHeitiK-Light" fontSize:12.0f];
    version.positionType = CCPositionTypeNormalized;
    version.color = [CCColor whiteColor];
    version.position = ccp(0.5f, 0.1f);
    [self addChild:version];
    
    //Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" fontName:@"STHeitiK-Light" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.95f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(backToIntro:)];
    [self addChild:backButton];
    
    return self;
}

- (void)backToIntro:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}

@end
