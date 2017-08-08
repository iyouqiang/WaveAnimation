//
//  PKRWaveAnimation.m
//  EPark-Base
//
//  Created by Yochi·Kung on 2017/7/28.
//  Copyright © 2017年 ecaray. All rights reserved.
//

#import "PKRWaveAnimation.h"

@interface PKRWaveAnimation ()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) NSMutableArray *waveLayers;
@property (nonatomic, strong) NSArray *wavecolors;
@property (nonatomic, assign) CGFloat opacity;
@property (nonatomic, assign) BOOL isLaunchBubbles;
@property (nonatomic, assign) CGFloat wavespeed;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) BOOL increase;
@property (nonatomic, assign) CGFloat variable;

/** 正弦函数参数 */
@property (nonatomic, assign) CGFloat amplitude;
@property (nonatomic, assign) CGFloat palstance;
@property (nonatomic, assign) CGFloat initialPhase;
@property (nonatomic, assign) CGFloat offsetY;

/** 粒子发射器 */
@property (nonatomic, strong) CAEmitterLayer *emitter;

@end

@implementation PKRWaveAnimation

- (void)loadWaveView:(NSInteger)waveNumber
          waveColors:(NSArray *)colors
             opacity:(CGFloat)opacity
           amplitude:(CGFloat)amplitude
           palstance:(CGFloat)palstance
           wavespeed:(CGFloat)wavespeed
             offsetY:(CGFloat)offsetY
     isLaunchBubbles:(BOOL)isLaunchBubbles
{
    /** 参数保存 */
    _wavecolors = colors;
    _opacity = opacity;
    _amplitude = amplitude;
    _palstance = palstance;
    _wavespeed = wavespeed;
    _offsetY = offsetY;
    _isLaunchBubbles = isLaunchBubbles;
    
    self.backgroundColor = [UIColor clearColor];
    
    /** 水波线条载体 CAShapeLayer */
    for (int i = 0 ; i < waveNumber; i ++ ) {

        CAShapeLayer *waveLayer = [CAShapeLayer layer];
        [self.layer addSublayer:waveLayer];
        /** 自定义值 */
        waveLayer.fillColor = [self colorIndex:i].CGColor;
        waveLayer.opacity = opacity - i/5.0;
        [self.waveLayers addObject:waveLayer];
    }

    /** 开始水波动画 */
    [self startWaveAnimation];
    
    /** 粒子发射器 */
    if (isLaunchBubbles) {
        
        [self.layer addSublayer:self.emitter];
    }
}

#pragma mark - lazy
- (NSMutableArray *)waveLayers
{
    if (!_waveLayers) {

        _waveLayers = [NSMutableArray array];
    }

    return _waveLayers;
}

/** 获取水波颜色 */
- (UIColor *)colorIndex:(NSInteger)index
{
    if (_wavecolors.count == 0) {
        
        return [UIColor whiteColor];
    }
    
    if ((index >= _wavecolors.count)) {

        return [_wavecolors lastObject];
    }
    
    return _wavecolors[index];
}

#pragma mark - private method
- (void)startWaveAnimation
{
    /** 刷屏动画 */
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWavestate:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)getCurrentWavestate:(CADisplayLink *)displayLink
{
    /**
     使用正弦产生水波动画
     y=Asin(ωx+φ)+k
     A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
     (ωx+φ)——相位，反映变量y所处的状态。
     φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
     k——偏距，反映在坐标系上则为图像的上移或下移。
     ω——角速度， 控制正弦周期(单位角度内震动的次数)。
     */
    
    //
    if (_increase) {
        _variable += 0.01;//0.01;
    }else{
        _variable -= 0.01;//0.01;
    }
    
    if (_variable<=1) {
        _increase = YES;
    }
    
    if (_variable>=1.5) {
        _increase = NO;
    }
    
    CGFloat A = _variable * (_amplitude/1.5);
    
    /** 改变初像，会改变 x 轴坐标会改变 */
    _initialPhase += _wavespeed;
    
    /** 贝塞尔曲线画正弦曲线 */
    for (int i = 0; i < self.waveLayers.count; i ++) {
        
        CAShapeLayer *layer = self.waveLayers[i];
        
        if (i == 0) {
            
            CGFloat y = _offsetY;
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, _offsetY)];
            for (float x = 0.0f; x < CGRectGetWidth(self.frame); x ++) {
                
                y = A * sin(_palstance * x + _initialPhase) + _offsetY;
                [path addLineToPoint:CGPointMake(x, y)];
            }
            [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
            layer.path = path.CGPath;
            
        }else {
            
            CGFloat y = _offsetY;
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, _offsetY)];
            for (float x = 0.0f; x < CGRectGetWidth(self.frame); x ++) {
                
                y = A * cos(_palstance * x + ((i - 1)*0.5 + 1)*_initialPhase) + _offsetY;
                [path addLineToPoint:CGPointMake(x, y)];
            }
            [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
            layer.path = path.CGPath;
        }
    }
}

- (void)setWaveHeightPercent:(CGFloat)percent
{
    _offsetY = CGRectGetHeight(self.frame) * (1 - percent);
}

#pragma mark - 粒子发射器
- (CAEmitterLayer *)emitter {
    
    if (_emitter == nil) {
        
        CGRect rect  = CGRectMake(self.bounds.size.width/2.0 - 10, self.bounds.size.height/2.0, 20, 20.0);
        
        /** 创建粒子引擎 */
        _emitter = [CAEmitterLayer layer];
        _emitter.frame = rect;
        
        /**
         
         point shape 中间点发射，像烟花
         line shape frame 顶部（边）发射
         rectangle shape 角落发射
         ...
         
         */
        _emitter.emitterShape = kCAEmitterLayerPoint;
        
        _emitter.emitterPosition = CGPointMake(rect.size.width/2, rect.size.height/2);
        _emitter.emitterSize = rect.size;
        
        /** 粒子样式 */
        CAEmitterCell *emitterCell = [[CAEmitterCell alloc] init];
        emitterCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"snow"].CGImage);
        
        //	emitterCell.emissionLongitude = CGFloat(-M_PI)
        //	emitterCell.lifetimeRange = 1.0
        
        // 每秒钟150个
        emitterCell.birthRate = 5;
        // 出现时间
        emitterCell.lifetime = 3;
        
        // y轴方向加速度 -为上升
        emitterCell.yAcceleration = -70.0;
        // x轴方向加速度 -为左
        emitterCell.xAcceleration = 0.0;
        // 初始速度
        emitterCell.velocity = 120.0;
        // 发射角度
        emitterCell.emissionLongitude = -M_PI * 0.5;
        // 速度范围 初速度+-200
        emitterCell.velocityRange = 200.0;
        // 发射角度范围 （同上）
        emitterCell.emissionRange = M_PI_4 * 0.5;
   
        // 设置cell大小缩放为0.8
        emitterCell.scale = 0.5;
        // 缩放范围为0.8  （0.8+-0.8）
        emitterCell.scaleRange = 0.5;
        // 每秒钟 变小 15%
        emitterCell.scaleSpeed = 0.8;
        
        emitterCell.alphaRange = 0.75;
        emitterCell.alphaSpeed = -0.55;
        emitterCell.lifetimeRange = 1.0;
        
        _emitter.emitterCells = @[emitterCell];
        
    }
    return _emitter;
}


- (void)dealloc
{
    [_waveDisplaylink invalidate];
}

@end
