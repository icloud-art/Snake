//
//  CLSnakeView.h
//  MySnake
//
//  Created by Charles Leo  on 14-4-11.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CLPoint.h"
//记录地图上的宽和高有多少个格子
#define WIDTH 15
#define HEIGHT 22
//定义每个格子的大小
#define CELL_SIZE 20
typedef enum
{
    kDown = 0,
    kLeft,
    kRight,
    kUp
} Orient;
@class CLSnakeView;
@protocol CLSnakeViewDelegate <NSObject>

- (void)snakeView:(CLSnakeView *)snakeVeiw andScore:(NSInteger) score;
-(void)snakeViewGameOver:(CLSnakeView *)snakeVeiw;
@end
@interface CLSnakeView : UIView <UIAlertViewDelegate>
{
    //记录蛇的点,最后一个点代表蛇头
    NSMutableArray * snakeData;
    CLPoint * foodPos;
    NSTimer * timer;
    UIColor * bgColor;
    UIImage * cherryImage;
    UIAlertView * overAlert;
    //游戏音效变量
    SystemSoundID gu;
    SystemSoundID crash;
}
//定义蛇的移动方向
@property (assign,nonatomic) Orient orient;
@property (assign,nonatomic) id <CLSnakeViewDelegate> delegate;
@end
