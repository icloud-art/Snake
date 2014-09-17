//
//  CLPoint.m
//  MySnake
//
//  Created by Charles Leo  on 14-4-11.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import "CLPoint.h"

@implementation CLPoint
-(id)initWithX:(NSInteger)x andY:(NSInteger)y
{
    if (self = [super init])
    {
        _x = x;
        _y = y;
    }
    return self;
}
-(BOOL)isEqual:(CLPoint *)other
{
    if (self == other)
    {
        return YES;
    }
    if (CLPoint.class == [other class])
    {
        return self.x == other.x&&self.y == other.y;
    }
    return NO;
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"{%ld,%ld}",self.x,self.y];
}
@end
