//
//  CLPoint.h
//  MySnake
//
//  Created by Charles Leo  on 14-4-11.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPoint : NSObject
@property (assign,nonatomic) NSInteger x;
@property (assign,nonatomic) NSInteger y;
-(id)initWithX:(NSInteger)x andY:(NSInteger)y;
-(BOOL)isEqual:(CLPoint *)other;
@end
