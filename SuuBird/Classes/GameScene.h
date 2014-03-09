//
//  GameScene.h
//  SuuBird
//
//  Created by Suu on 3/7/14.
//  Copyright (c) 2014 suu. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d-ui.h"

@interface GameScene : CCScene <CCPhysicsCollisionDelegate>

+ (GameScene *)scene;
- (id)init;

@end
