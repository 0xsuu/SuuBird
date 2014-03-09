//
//  GameScene.m
//  SuuBird
//
//  Created by Suu on 3/7/14.
//  Copyright (c) 2014 suu. All rights reserved.
//

#import "DebugStat.h"

#import "GameScene.h"
#import "GameOverScene.h"
#import "SuuBird.h"

#import "PhysicsConstants.h"

#define maxY 300.0f
#define minY 40.0f

@implementation GameScene
{
    CCPhysicsNode *_physicsWorld;
    SuuBird *theBird;
    
    CCSprite *theTopPillar;
    CCSprite *theBottomPillar;
    CCSprite *theTopPillarNext;
    CCSprite *theBottomPillarNext;
    
    CCSprite *grass;
    CCSprite *grassNext;
    
    int rangeY;
    float randomY;
    float randomYNext;
    float intervalDistance;
    
    int score;
    int level;
    
    BOOL addScore;
    
    CCLabelTTF *scoreLabel;
    CCLabelTTF *levelLabel;
}

+ (GameScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    
    // Create a colored background
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:103.0f/255.0f green:204.0f/255.0f blue:250.0f/255.0f alpha:1.0f]];
    [self addChild:background];
    
    //Play Background music
    [[OALSimpleAudio sharedInstance] playBg:@"bg.wav" loop:YES];
    
    //Create the physics world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0, -980.665f);
    _physicsWorld.debugDraw = isDebugging;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    //Create the restrict area of the whole screen
    CGRect worldRect = CGRectMake(0, 0, [CCDirector sharedDirector].viewSize.width, [CCDirector sharedDirector].viewSize.height);
    CCNode *outline = [CCNode node];
    outline.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:worldRect cornerRadius:0];
    outline.physicsBody.friction = 1.0f;
    outline.physicsBody.elasticity = 0.5f;
    outline.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:outline];
    
    //Create THE BIRD
    theBird = [SuuBird spriteWithImageNamed:@"thebird.png"];
    theBird.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    theBird.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, theBird.contentSize.width - 5, theBird.contentSize.height - 5) cornerRadius:0.0f];
    theBird.userInteractionEnabled = YES;
    theBird.physicsBody.allowsRotation = NO;
    theBird.physicsBody.collisionGroup = @"birdGroup";
    theBird.physicsBody.collisionType = @"birdCollision";
    theBird.physicsBody.collisionCategories = @[@"bird"];
    [_physicsWorld addChild:theBird z:1];
    
    [theBird.physicsBody applyForce:ccp(0, 0)];
    
    //Set the random figures
    rangeY = maxY- minY;
    randomY = (arc4random() % rangeY) + minY;
    randomYNext = (arc4random() % rangeY) + minY;
    
    //Set the distance between two pillars
    intervalDistance = 110.0f;
    
    //Create the first top pillar
    theTopPillar = [CCSprite spriteWithImageNamed:@"pillar.png"];
    theTopPillar.anchorPoint = ccp(0, 0);
    theTopPillar.position = ccp(self.contentSize.width, self.contentSize.height - randomY);
    theTopPillar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, theTopPillar.contentSize} cornerRadius:0.0f];
    theTopPillar.physicsBody.type = CCPhysicsBodyTypeStatic;
    theTopPillar.physicsBody.collisionGroup = @"pillarGroup";
    theTopPillar.physicsBody.collisionType = @"pillarCollision";
    theTopPillar.physicsBody.collisionMask = @[@"bird"];
    [_physicsWorld addChild:theTopPillar];
    
    //Create the first bottom pillar
    theBottomPillar = [CCSprite spriteWithImageNamed:@"pillar.png"];
    theBottomPillar.anchorPoint = ccp(0, 0);
    theBottomPillar.position = ccp(self.contentSize.width, self.contentSize.height - randomY - intervalDistance - theBottomPillar.contentSize.height);
    theBottomPillar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, theBottomPillar.contentSize} cornerRadius:0.0f];
    theBottomPillar.physicsBody.type = CCPhysicsBodyTypeStatic;
    theBottomPillar.physicsBody.collisionGroup = @"pillarGroup";
    theBottomPillar.physicsBody.collisionType = @"pillarCollision";
    theBottomPillar.physicsBody.collisionMask = @[@"bird"];
    [_physicsWorld addChild:theBottomPillar];
    
    //Create the second top pillar
    theTopPillarNext = [CCSprite spriteWithImageNamed:@"pillar.png"];
    theTopPillarNext.anchorPoint = ccp(0, 0);
    theTopPillarNext.position = ccp(self.contentSize.width * 1.5f + theTopPillarNext.contentSize.width / 2, self.contentSize.height - randomYNext);
    theTopPillarNext.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, theTopPillarNext.contentSize} cornerRadius:0.0f];
    theTopPillarNext.physicsBody.type = CCPhysicsBodyTypeStatic;
    theTopPillarNext.physicsBody.collisionGroup = @"pillarGroup";
    theTopPillarNext.physicsBody.collisionType = @"pillarCollision";
    theTopPillarNext.physicsBody.collisionMask = @[@"bird"];
    [_physicsWorld addChild:theTopPillarNext];
    
    //Create the second bottom pillar
    theBottomPillarNext = [CCSprite spriteWithImageNamed:@"pillar.png"];
    theBottomPillarNext.anchorPoint = ccp(0, 0);
    theBottomPillarNext.position = ccp(self.contentSize.width * 1.5f + theBottomPillarNext.contentSize.width / 2, self.contentSize.height - randomYNext - intervalDistance - theBottomPillarNext.contentSize.height);
    theBottomPillarNext.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, theBottomPillarNext.contentSize} cornerRadius:0.0f];
    theBottomPillarNext.physicsBody.type = CCPhysicsBodyTypeStatic;
    theBottomPillarNext.physicsBody.collisionGroup = @"pillarGroup";
    theBottomPillarNext.physicsBody.collisionType = @"pillarCollision";
    theBottomPillarNext.physicsBody.collisionMask = @[@"bird"];
    [_physicsWorld addChild:theBottomPillarNext];
    
    //Create the first grass ground
    grass = [CCSprite spriteWithImageNamed:@"grass.png"];
    grass.anchorPoint = ccp(0, 0);
    grass.position = ccp(0, 0);
    grass.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, grass.contentSize} cornerRadius:0.0f];
    grass.physicsBody.friction = 1.0f;
    grass.physicsBody.elasticity = 0.5f;
    grass.physicsBody.type = CCPhysicsBodyTypeStatic;
    grass.physicsBody.collisionGroup = @"grassGroup";
    grass.physicsBody.collisionType = @"grassCollision";
    [_physicsWorld addChild:grass];
    
    //Create the second grass ground
    grassNext = [CCSprite spriteWithImageNamed:@"grass.png"];
    grassNext.anchorPoint = ccp(0, 0);
    grassNext.position = ccp(self.contentSize.width, 0);
    grassNext.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, grassNext.contentSize} cornerRadius:0.0f];
    grassNext.physicsBody.friction = 1.0f;
    grassNext.physicsBody.elasticity = 0.5f;
    grassNext.physicsBody.type = CCPhysicsBodyTypeStatic;
    grassNext.physicsBody.collisionGroup = @"grassGroup";
    grassNext.physicsBody.collisionType = @"grassCollision";
    [_physicsWorld addChild:grassNext];
    
    //Clear the current score
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentScore"];
    
    //Get the current level
    level = [[NSUserDefaults standardUserDefaults] integerForKey:@"Level"];
    if (level == 0) level = 1;
    
    //Create the score label
    scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"STHeitiK-Light" fontSize:12.0f];
    scoreLabel.anchorPoint = ccp(0, 0);
    scoreLabel.position = ccp(5, self.contentSize.height - scoreLabel.contentSize.height);
    [self addChild:scoreLabel];
    
    levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d",level] fontName:@"STHeitiK-Light" fontSize:12.0f];
    levelLabel.anchorPoint = ccp(0, 0);
    levelLabel.position = ccp(scoreLabel.contentSize.width + 20, self.contentSize.height - levelLabel.contentSize.height);
    [self addChild:levelLabel];
    
    addScore = YES;
    
    //Let the stuff move
    [self schedule:@selector(moveScene:) interval:.0025f];
    
    return self;
}

- (void)moveScene:(CCTime)delta
{
    //Move pilars
    CCActionMoveTo *moveTopPillar = [CCActionMoveTo actionWithDuration:0.0025f position:ccp(theTopPillar.position.x - 0.2, theTopPillar.position.y)];
    [theTopPillar runAction:moveTopPillar];
    
    CCActionMoveTo *moveBottomPillar = [CCActionMoveTo actionWithDuration:0.0025f position:ccp(theBottomPillar.position.x - 0.2, theBottomPillar.position.y)];
    [theBottomPillar runAction:moveBottomPillar];
    
    CCActionMoveTo *moveTopPillarNext = [CCActionMoveTo actionWithDuration:0.0025f position:ccp(theTopPillarNext.position.x - 0.2, theTopPillarNext.position.y)];
    [theTopPillarNext runAction:moveTopPillarNext];
    
    CCActionMoveTo *moveBottomPillarNext = [CCActionMoveTo actionWithDuration:0.0025f position:ccp(theBottomPillarNext.position.x - 0.2, theBottomPillarNext.position.y)];
    [theBottomPillarNext runAction:moveBottomPillarNext];
    
    //Check and relocate the pillars position
    if (theTopPillar.position.x < -theTopPillar.contentSize.width)
    {
        randomY = (arc4random() % rangeY) + minY;
        
        theTopPillar.position = ccp(self.contentSize.width, self.contentSize.height - randomY);
        theBottomPillar.position = ccp(self.contentSize.width, self.contentSize.height - randomY - intervalDistance - theBottomPillar.contentSize.height);
        
        addScore = YES;
    }
    
    if (theTopPillarNext.position.x < -theTopPillarNext.contentSize.width / 2 - theTopPillarNext.contentSize.width / 2)
    {
        randomYNext = (arc4random() % rangeY) + minY;

        theTopPillarNext.position = ccp(self.contentSize.width, self.contentSize.height - randomYNext);
        theBottomPillarNext.position = ccp(self.contentSize.width, self.contentSize.height - randomYNext - intervalDistance - theBottomPillarNext.contentSize.height);
        
        addScore = YES;
    }
    
    if (theTopPillar.position.x < theBird.position.x || theTopPillarNext.position.x < theBird.position.x)
    {
        if (addScore == YES)
        {
            score += level;
            scoreLabel.string = [NSString stringWithFormat:@"Score: %d",score];
            addScore = NO;
        }
    }
    
    //Move the grass grounds
    CCActionMoveTo *moveGrassA = [CCActionMoveTo actionWithDuration:0.0025f position:ccp(grass.position.x - 0.2, grass.position.y)];
    [grass runAction:moveGrassA];
    
    CCActionMoveTo *moveGrassB = [CCActionMoveTo actionWithDuration:0.0025f position:ccp(grassNext.position.x - 0.2, grassNext.position.y)];
    [grassNext runAction:moveGrassB];
    
    if (grass.position.x <= 0)
    {
        grassNext.position = ccp(grass.position.x + self.contentSize.width, grass.position.y);
    }
    
    if (grassNext.position.x <= 0)
    {
        grass.position = ccp(grassNext.position.x + self.contentSize.width, grassNext.position.y);
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Let the bird fly
    theBird.physicsBody.velocity = CGPointMake(0, 300);
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair birdCollision:(CCNode *)bird grassCollision:(CCNode *)grassGround
{
    //Bad collision
    [self gameOver];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair birdCollision:(CCNode *)bird pillarCollision:(CCNode *)pillar
{
    //Bad collision
    [self gameOver];
    return YES;
}

- (void)gameOver
{
    //Game over
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"currentScore"];
    
    [[CCDirector sharedDirector] replaceScene:[GameOverScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

@end
