/*
 * author 孔凡列
 *
 * gitHub https://github.com/gitkong
 * cocoaChina http://code.cocoachina.com/user/
 * 简书 http://www.jianshu.com/users/fe5700cfb223/latest_articles
 * QQ 279761135
 * 微信公众号 原创技术分享
 * 喜欢就给个like 和 star 喔~
 */

#import <UIKit/UIKit.h>

@interface UIView (drag)
/**
 *  @author gitKong
 *
 *  是否允许拖拽，默认关闭（可以在XIB或SB中设置）
 */
@property (nonatomic,assign)IBInspectable BOOL fl_canSlide;
/**
 *  @author gitKong
 *
 *  是否需要边界弹簧效果，默认开启（可以在XIB或SB中设置）
 */
@property (nonatomic,assign)IBInspectable BOOL fl_bounces;
/**
 *  @author gitKong
 *
 *  是否需要吸附边界效果，默认开启（可以在XIB或SB中设置）
 */
@property (nonatomic,assign)IBInspectable BOOL fl_isAdsorb;

@end
