//
//  GameOverScene.m
//  SuuBird
//
//  Created by Suu on 3/8/14.
//  Copyright (c) 2014 suu. All rights reserved.
//

#import "DebugStat.h"

#import "GameOverScene.h"
#import "BreatheLabel.h"
#import "GameScene.h"

#define setINTEGER [NSUserDefaults standardUserDefaults] setInteger
#define getINTEGER [NSUserDefaults standardUserDefaults] integerForKey

@implementation GameOverScene
{
    CCProgressNode *level;
    
    CCLabelTTF *levelLabel;
}

+ (GameOverScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //Set the scene touchable
    self.userInteractionEnabled = YES;
    
    //Create a colored background
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:.0f green:.0f blue:.0f alpha:1.0f]];
    [self addChild:background];
    
    //Create the physics world
    CCPhysicsNode *_physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0, -800);
    _physicsWorld.debugDraw = isDebugging;
    [self addChild:_physicsWorld];
    
    //Create the game over label sprite
    CCSprite *gameOver = [CCSprite spriteWithImageNamed:@"gameover.png"];
    gameOver.position = ccp(self.contentSize.width/2, self.contentSize.height - 100);
    gameOver.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, gameOver.contentSize} cornerRadius:0.0f];
    gameOver.physicsBody.mass = 10.0f;
    [_physicsWorld addChild:gameOver];
    
    //Create the bound that prevents game over label sprite to fall
    CCNode *midBound = [CCNode node];
    midBound.anchorPoint = ccp(0, 0);
    midBound.position = ccp(0, self.contentSize.height/2 + 100);
    midBound.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, self.contentSize.width, 30) cornerRadius:0.0f];
    midBound.physicsBody.type = CCPhysicsBodyTypeStatic;
    midBound.physicsBody.elasticity = 3.6f;
    [_physicsWorld addChild:midBound];
    
    //Get the highest score
    if ([getINTEGER:@"currentScore"] > [getINTEGER:@"HighestScore"])
    {
        [setINTEGER:[getINTEGER:@"currentScore"] forKey:@"HighestScore"];
    }
    
    //Create the score label
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[getINTEGER:@"currentScore"]] fontName:@"STHeitiK-Light" fontSize:50.0f];
    scoreLabel.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 50);
    [self addChild:scoreLabel];
    
    //Create the progress's edge
    CCSprite *progressEdge = [CCSprite spriteWithImageNamed:@"progressedge.png"];
    progressEdge.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    [self addChild:progressEdge];
    
    //Create the progress node
    CCSprite *progressSprite = [CCSprite spriteWithImageNamed:@"progress.png"];
    level = [CCProgressNode progressWithSprite:progressSprite];
    level.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    level.type = CCProgressNodeTypeBar;
    level.midpoint = ccp(0, 0.5);
    level.percentage = [getINTEGER:@"Experience"];
    level.barChangeRate = ccp(1, 0);
    [self addChild:level];
    
    //Let the progress run
    [self schedule:@selector(updateProgresser:) interval:0.01f];

    //Create the level label
    levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d",
                                              [getINTEGER:@"Level"]]
                             fontName:@"STHeitiK-Light"
                             fontSize:14.0f];
    levelLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2 - 30);
    [self addChild:levelLabel];
    
    //Create the high score label
    CCLabelTTF *highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Highest Score: %d",[getINTEGER:@"HighestScore"]] fontName:@"STHeitiK-Light" fontSize:14.0f];
    highScore.position = ccp(self.contentSize.width/2, self.contentSize.height/2 - 100);
    [self addChild:highScore];
    
    //Create the tap-to-restart label
    BreatheLabel *tapToRestart = [BreatheLabel labelWithString:@"TAP TO RESTART" fontName:@"STHeitiK-Light" fontSize:14.0f];
    tapToRestart.position = ccp(self.contentSize.width/2, 40);
    [self addChild:tapToRestart];
    
    return self;
}

- (void)updateProgresser:(CCTime)delta
{
    //Move the progress and do some archive stuff
    int levelCount = [getINTEGER:@"Level"];
    int everExp = [getINTEGER:@"Experience"];
    if (level.percentage < ((float)([getINTEGER:@"Experience"]+[getINTEGER:@"currentScore"]))/(float)(levelCount * levelCount) * 10.0f)
    {
        level.percentage ++;
        if (level.percentage == 100.0f)
        {
            level.percentage = 0.0f;
            [setINTEGER:levelCount + 1 forKey:@"Level"];
            [setINTEGER:[getINTEGER:@"currentScore"] - levelCount*levelCount*10 + everExp forKey:@"Experience"];
            everExp = 0;
            [setINTEGER:[getINTEGER:@"currentScore"] - levelCount*levelCount*10 forKey:@"currentScore"];
            if ([getINTEGER:@"currentScore"] < 0) [setINTEGER:0 forKey:@"currentScore"];
            levelLabel.string = [NSString stringWithFormat:@"Level %d", levelCount + 1];
        }
    }
    else
    {
        [setINTEGER:[getINTEGER:@"currentScore"] + [getINTEGER:@"Experience"] forKey:@"Experience"];
        [self unschedule:@selector(updateProgresser:)];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Back to game
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:0.5f]];
}

@end
