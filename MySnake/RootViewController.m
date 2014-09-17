//
//  RootViewController.m
//  MySnake
//
//  Created by Charles Leo  on 14-4-14.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color07.jpg"]];
	[self initView];
}
#pragma mark - CLSnakeViewDelegate 的代理方法
-(void)snakeView:(CLSnakeView *)snakeVeiw andScore:(NSInteger)score
{
    totalScore += score;
    NSLog(@"score = %ld",totalScore);
    getScoreLabel.text = [NSString stringWithFormat:@"现在得分:%ld分",totalScore];
    //如果现在的得分超过了历史最高得分,则更新最高得分记录,并记录下来
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSInteger best = [[userDef objectForKey:@"best"] integerValue];
    if (totalScore >= best)
    {
        bestScoreLabel.text = [NSString stringWithFormat:@"最高得分:%ld分",totalScore];
        [userDef setObject:[NSString stringWithFormat:@"%ld",totalScore] forKey:@"best"];
    }
}
//游戏结束
-(void)snakeViewGameOver:(CLSnakeView *)snakeVeiw
{
    totalScore = 0;
    NSLog(@"score = %ld",totalScore);
    getScoreLabel.text = [NSString stringWithFormat:@"现在得分:%ld分",totalScore];
}
-(void)initView
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, 300, 60)];
    titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color01.jpg"]];
    titleView.layer.borderWidth = 3;
    titleView.layer.borderColor = [UIColor whiteColor].CGColor;
    titleView.layer.cornerRadius = 6;
    titleView.layer.masksToBounds = YES;
    [self.view addSubview:titleView];
    getScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300/2, 60)];
    getScoreLabel.backgroundColor = [UIColor clearColor];
    getScoreLabel.textColor = [UIColor whiteColor];
    getScoreLabel.text = @"现在得分:0分";
    getScoreLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:getScoreLabel];
    
    //从本地获取历史最高得分
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSString * bestScore = [userDef objectForKey:@"best"];
    bestScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 300/2, 60)];
    bestScoreLabel.backgroundColor = [UIColor clearColor];
    bestScoreLabel.textColor = [UIColor whiteColor];
     bestScoreLabel.textAlignment = NSTextAlignmentCenter;
    if (bestScore == Nil)
    {
         bestScoreLabel.text = [NSString stringWithFormat:@"最高得分:%d分",0];
    }
    else
    {
         bestScoreLabel.text = [NSString stringWithFormat:@"最高得分:%@分",bestScore];
    }
    [titleView addSubview:bestScoreLabel];
    //创建CLSnakeView 控件
    snakeView = [[CLSnakeView alloc]initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - HEIGHT * CELL_SIZE - 20, WIDTH * CELL_SIZE, HEIGHT * CELL_SIZE)];
    snakeView.delegate = self;
    //为sankeView控件设置边框和圆角
    snakeView.layer.borderWidth = 3;
    snakeView.layer.borderColor = [UIColor whiteColor].CGColor;
    snakeView.layer.cornerRadius = 6;
    snakeView.layer.masksToBounds = YES;
    //设置self.view 控件支持用户交互
    self.view.userInteractionEnabled = YES;
    //设置self.view 控件支持多点触碰
    self.view.multipleTouchEnabled = YES;
    for (int i = 0; i < 4; i++)
    {
        //创建手势处理器,指定使用改控制器的handleSwipe:方法处理轻扫手势
        UISwipeGestureRecognizer * gesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
        //设置该点击手势处理器只处理i个手指的轻扫手势
        gesture.numberOfTouchesRequired = 1;
        //指定该手势处理器只处理1 << i 方向的轻扫手势
        gesture.direction = 1 << i;
        //为self.view 添加轻扫手势
        [self.view addGestureRecognizer:gesture];
    }
    [self.view addSubview:snakeView];
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesutre
{
    //获取轻扫手势的方向
    NSUInteger direction = gesutre.direction;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            //只要不是向右,即可改变方向
            if (snakeView.orient != kRight) {
                snakeView.orient = kLeft;
            }
            break;
        case UISwipeGestureRecognizerDirectionUp:
            //只要不是向下,即可改变方向
            if (snakeView.orient  != kDown) {
                snakeView.orient = kUp;
            }
            break;
        case UISwipeGestureRecognizerDirectionDown:
            //只要不是向上,即可改变方向
            if (snakeView.orient != kUp) {
                  snakeView.orient = kDown;
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            //只要不是向左,即可改变方向
            if (snakeView.orient != kLeft)
            {
                 snakeView.orient = kRight;
            }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
