//
//  CLSnakeView.m
//  MySnake
//
//  Created by Charles Leo  on 14-4-11.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import "CLSnakeView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CLPoint.h"
@implementation CLSnakeView
//记录蛇的点,最后一个点代表蛇头

@synthesize orient,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //食物图片
        cherryImage = [UIImage imageNamed:@"cherry.png"];
        //游戏背景图,平铺
        bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color01.jpg"]];
        //获取两个音效文件的URL
        NSURL * guUrl = [[NSBundle mainBundle]URLForResource:@"gu" withExtension:@"mp3"];
        NSURL * crashUrl = [[NSBundle mainBundle]URLForResource:@"crash" withExtension:@"wav"];
        //加载两个音效文件
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)guUrl,&gu);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)crashUrl,&crash);
        overAlert = [[UIAlertView alloc]initWithTitle:@"游戏结束" message:@"您输了,是否重新再来?" delegate:self cancelButtonTitle:@"不玩了" otherButtonTitles:@"再来一局", nil];
        [self startGame];
    }
    return self;
}
-(void)startGame
{
    //CLPoint 第一个参数 控制位于水平第几格,第二个参数控制 位于垂直第几格
    snakeData = [NSMutableArray arrayWithObjects:[[CLPoint alloc]initWithX:1 andY:0], [[CLPoint alloc]initWithX:2 andY:0],[[CLPoint alloc]initWithX:3 andY:0],[[CLPoint alloc]initWithX:4 andY:0],[[CLPoint alloc]initWithX:5 andY:0],
                 nil];
    ;
    //定义蛇的初始移动方向
    orient = kRight;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(move) userInfo:nil repeats:YES];
}
-(void)move
{
    //除了蛇头受方向控制之外,其他点都是占它的前一个点
    //获取最后一个点,作为蛇头
    CLPoint * first = [snakeData objectAtIndex:snakeData.count - 1];
    CLPoint * head = [[CLPoint alloc]initWithX:first.x andY:first.y];
    switch (orient)
    {
        case kDown://向下
            //新蛇头的位置
            head.y = head.y + 1;
            break;
        case kLeft://向左
            //新蛇头的位置
            head.x = head.x - 1;
            break;
        case kRight://向右
            head.x = head.x + 1;
            break;
        case kUp://向上
            head.y = head.y - 1;
        default:
            break;
    }
    //如果移动候蛇头超出界面或者与蛇身碰撞,游戏结束
    if (head.x < 0 || head.x > WIDTH - 1 || head.y < 0 || head.y > HEIGHT - 1 || [snakeData containsObject:head])
    {
        //播放碰撞的音效
        AudioServicesPlaySystemSound(crash);
        [overAlert show];
        [timer invalidate];
        [self.delegate snakeViewGameOver:self];
    }
    //如果蛇头与食物点重合
    if ([head isEqual:foodPos])
    {
        //播放吃食物的音效
        AudioServicesPlaySystemSound(gu);
        //将食物点添加成新的蛇头
        [snakeData addObject:foodPos];
        //清空食物
        foodPos = nil;
        [self.delegate snakeView:self andScore:100];
    }
    else
    {
        //从第一个点开始,控制蛇身向前
        for (int i = 0; i < snakeData.count - 1; i++)
        {
            //将第i个点的坐标设置为第i+1个点的坐标
            CLPoint * curPt = [snakeData objectAtIndex:i];
            CLPoint * nextPt = [snakeData objectAtIndex:i+1];
            curPt.x = nextPt.x;
            curPt.y = nextPt.y;
        }
        //重新设置蛇头坐标
        [snakeData setObject:head atIndexedSubscript:(snakeData.count - 1)];
    }
    if (foodPos == nil)
    {
        while (true)
        {
            CLPoint * newFoodPos = [[CLPoint alloc]initWithX:arc4random()%WIDTH andY:arc4random()%HEIGHT];
            //如果新产生的食物点,没有位于蛇身体上
            if (![snakeData containsObject:newFoodPos]) {
                foodPos = newFoodPos;
                break;//成功生成了食物的位置,结束循环
            }
        }
    }
    [self setNeedsDisplay];
}
//定义绘制蛇头的方法
- (void) drawHeadInRect:(CGRect) rect context:(CGContextRef) ctx
{
    CGContextBeginPath(ctx);
    //根据蛇头的方向,决定开口的角度
    CGFloat startAngle;
    switch (orient) {
        case kUp:
            startAngle = M_PI * 7 / 4;
            break;
        case kDown:
           startAngle = M_PI * 3 / 4;
            break;
        case kLeft:
            startAngle = M_PI * 5 / 4;
            break;
        case kRight:
            startAngle = M_PI * 1 / 4;
            break;
        default:
            break;
    }
    //添加一段弧作为路径
    CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect),CELL_SIZE / 2 , startAngle, M_PI * 1.5 + startAngle, 0);
    //将绘制点移动到中心
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
    //关闭路径
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //获取绘图API
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, CGRectMake(0, 0, WIDTH * CELL_SIZE, HEIGHT * CELL_SIZE));
    CGContextSetFillColorWithColor(ctx, [bgColor CGColor]);
    //绘制背景
    CGContextFillRect(ctx, CGRectMake(0, 0, WIDTH * CELL_SIZE, HEIGHT * CELL_SIZE));
    //绘制文字
    [@"贪吃蛇" drawAtPoint:CGPointMake(10, HEIGHT * CELL_SIZE - 20) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Heiti SC" size:15],NSFontAttributeName,[UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSForegroundColorAttributeName,nil]];
    [@"Developed By Charles Leo" drawAtPoint:CGPointMake(160, HEIGHT * CELL_SIZE - 15) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Heiti SC" size:10],NSFontAttributeName,[UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSForegroundColorAttributeName,nil]];
    //设置绘制蛇的填充颜色
    CGContextSetRGBFillColor(ctx,1,1,0,1);
    //遍历蛇的数据,绘制蛇的数据
    for (int i=0; i< snakeData.count ; i++)
    {
        //为每个蛇的点,在屏幕上绘制一个圆点
        CLPoint * cp =[snakeData objectAtIndex:i];
        //定义将要绘制蛇身点的矩形
        CGRect rect = CGRectMake(cp.x * CELL_SIZE, cp.y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
        //绘制蛇尾巴,让蛇的尾巴小一些
        if (i < 4) {
            CGFloat inset = (4 - i);
            CGContextFillEllipseInRect(ctx, CGRectInset(rect, inset, inset));
        }
        //如果是最后一个元素,代表蛇头,绘制蛇头
        else if (i == snakeData.count - 1)
        {
            [self drawHeadInRect:rect context:ctx];
            CGContextSetRGBFillColor(ctx,1,0,0,1);
        }
        else
        {
            CGContextFillEllipseInRect(ctx, rect);
        }
    }
    //绘制食物图片
    [cherryImage drawAtPoint:CGPointMake(foodPos.x * CELL_SIZE, foodPos.y * CELL_SIZE)];
}
#pragma mark - UIAlertViewDelegate的代理方法
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果用户点击了第二个按钮,重新开始游戏
    if (buttonIndex == 1)
    {
        [self startGame];
    }
}
@end
