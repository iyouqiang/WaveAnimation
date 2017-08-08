//
//  PKRWaveAnimation.h
//  EPark-Base
//
//  Created by Yochi·Kung on 2017/7/28.
//  Copyright © 2017年 ecaray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKRWaveAnimation : UIView

/** 
 水波动画理论基础
 使用正余弦产生水波动画
 y=Asin(ωx+φ)+k
 y=Acos(ωx+φ)+k
 A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
 (ωx+φ)——相位，反映变量y所处的状态。
 φ——初相(initial phase)，x=0时的相位；反映在坐标系上则为图像的左右移动。
 k——偏距，反映在坐标系上则为图像的上移或下移。offsetY
 ω——角速度， 控制正弦周期(单位角度内震动的次数)。 palstance
 
 正弦图像在x轴平移π/2得到余弦图像
 */

/**
 具体实现分析
 1、水波动画时刻刷新 使用CADisplayLink
 2、周期变化，使用正弦函数
 3、产生气泡，使用粒子发射器 CAEmitterLayer
 4、动画只有开始，所以动画开始内部调用
 */

/**
 * 左上角为参考坐标系
 * waveNumber     波浪层数
 * colors         每条波浪颜色，不传默认为白色，颜色值不够 会分配最后的颜色值
 * opacity        透明度
 * amplitude      振幅 控制上下行程
 * palstance      角速度 控制正弦周期
 * wavespeed      水波速度 控制初像 即x轴坐标平移速度
 * offsetY        偏距 波浪的的位置，起点在左上角
 */
- (void)loadWaveView:(NSInteger)waveNumber
          waveColors:(NSArray *)colors
             opacity:(CGFloat)opacity
           amplitude:(CGFloat)amplitude
           palstance:(CGFloat)palstance
           wavespeed:(CGFloat)wavespeed
             offsetY:(CGFloat)offsetY
     isLaunchBubbles:(BOOL)isLaunchBubbles;

/** 默认调用，动画被迫暂停后调用 */
- (void)startWaveAnimation;

/** 设置水波高度百分比 */
- (void)setWaveHeightPercent:(CGFloat)percent;

@end
