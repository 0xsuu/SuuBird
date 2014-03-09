//
//  IntroScene.h
//  SuuBird
//
//  Created by Suu on 3/7/14.
//  Copyright suu 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface IntroScene : CCScene <CCPhysicsCollisionDelegate>

+ (IntroScene *)scene;
- (id)init;

@end