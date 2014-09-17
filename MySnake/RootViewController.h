//
//  RootViewController.h
//  MySnake
//
//  Created by Charles Leo  on 14-4-14.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSnakeView.h"
@interface RootViewController : UIViewController <CLSnakeViewDelegate>
{
    CLSnakeView * snakeView;
    NSInteger totalScore;
    UILabel * getScoreLabel;
    UILabel * bestScoreLabel;
}
@end
