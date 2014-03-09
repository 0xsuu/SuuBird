//
//  IntroScene.m
//  SuuBird
//
//  Created by Suu on 3/7/14.
//  Copyright suu 2014. All rights reserved.
//

#import "DebugStat.h"

#import "IntroScene.h"
#import "GameScene.h"
#import "AboutScene.h"

#import "PhysicsConstants.h"

@implementation IntroScene
{
    CCPhysicsNode *_physicsWorld;
}

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    //Create a colored background
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:103.0f/255.0f green:204.0f/255.0f blue:250.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    
    //Set the world touchable
    self.userInteractionEnabled = YES;
    
    //Create the physics world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0, -980.665f);
    _physicsWorld.debugDraw = isDebugging;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    //Add the outline
    CGRect worldRect = CGRectMake(0, 0, [CCDirector sharedDirector].viewSize.width, [CCDirector sharedDirector].viewSize.height);
    CCNode *outline = [CCNode node];
    outline.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:worldRect cornerRadius:0];
    outline.physicsBody.friction = 1.0f;
    outline.physicsBody.elasticity = 0.5f;
    outline.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:outline];
    
    //Add the title sprite
    CCSprite *titleSprite = [CCSprite spriteWithImageNamed:@"suubird.png"];
    titleSprite.position = ccp(self.contentSize.width/2 - 50, self.contentSize.height - 20);
    titleSprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, titleSprite.contentSize} cornerRadius:0.0f];
    titleSprite.physicsBody.friction = 0.1f;
    [_physicsWorld addChild:titleSprite];
    
    //Add the ground sprite
    CCSprite *groundSprite = [CCSprite spriteWithImageNamed:@"ground.png"];
    groundSprite.anchorPoint = ccp(0, 0);
    groundSprite.position = ccp(0, 0);
    groundSprite.physicsBody = [CCPhysicsBody bodyWithPolygonFromPoints:(CGPoint *)GroundShape count:GroundShapeNumber cornerRadius:0.0f];
    groundSprite.physicsBody.friction = 0.9f;
    groundSprite.physicsBody.elasticity = 0.4f;
    groundSprite.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:groundSprite];

    //Start scene button
    CCButton *startButton = [CCButton buttonWithTitle:@"TAP TO START" fontName:@"STHeitiK-Light" fontSize:28.0f];
    startButton.position = ccp(self.contentSize.width/2 + 20, self.contentSize.height - 50);
    [startButton setTarget:self selector:@selector(gameStart:)];
    startButton.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, startButton.contentSize} cornerRadius:0.0f];
    [_physicsWorld addChild:startButton];
    
    //Info scene button
    CCButton *infoButton = [CCButton buttonWithTitle:@"i" fontName:@"STHeitiK-Light" fontSize:28.0f];
    infoButton.position = ccp(50, self.contentSize.height - 20);
    [infoButton setTarget:self selector:@selector(goToInfo:)];
    infoButton.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:infoButton.contentSize.width/2+15 andCenter:infoButton.anchorPointInPoints];
    infoButton.physicsBody.elasticity = 1.0f;
    [_physicsWorld addChild:infoButton];
	
	return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Tap to start
    [self gameStart:nil];
}

- (void)gameStart:(id)sender
{
    //Start game scene with transition
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

- (void)goToInfo:(id)sender
{
    //Go to About
    [[CCDirector sharedDirector] replaceScene:[AboutScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

@end
