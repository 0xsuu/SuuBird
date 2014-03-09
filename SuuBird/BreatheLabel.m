//
//  BreatheLabel.m
//  SuuBird
//
//  Created by Suu on 3/8/14.
//  Copyright (c) 2014 suu. All rights reserved.
//

#import "BreatheLabel.h"
#import "CCColor.h"
#import <UIKit/UIKit.h>

@implementation BreatheLabel

- (void)onEnter
{
    [super onEnter];
    
    [self schedule:@selector(breathe1) interval:1.0f repeat:10 delay:0.0f];
    [self schedule:@selector(breathe2) interval:1.0f repeat:10 delay:0.5f];
}

- (void)breathe1
{
    CCActionCallFunc *ease = [CCActionCallFunc actionWithTarget:self selector:@selector(easeIn)];
    [self runAction:ease];
}

- (void)breathe2
{
    CCActionCallFunc *ease = [CCActionCallFunc actionWithTarget:self selector:@selector(easeOut)];
    [self runAction:ease];
}

- (void)easeIn
{
    self.fontColor = [CCColor colorWithRed:self.fontColor.red green:self.fontColor.green blue:self.fontColor.blue alpha:0.1f];
}

- (void)easeOut
{
    self.fontColor = [CCColor colorWithRed:self.fontColor.red green:self.fontColor.green blue:self.fontColor.blue alpha:1.0f];
}

@end
