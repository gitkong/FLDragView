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

#import "UIView+drag.h"
#import <objc/runtime.h>
@interface UIView ()
@property (nonatomic,weak)UIPanGestureRecognizer *panG;

@property (nonatomic,assign)CGFloat fl_x;

@property (nonatomic,assign)CGFloat fl_y;

@property (nonatomic,assign)CGFloat fl_centerX;

@property (nonatomic,assign)CGFloat fl_centerY;

@property (nonatomic,assign)CGFloat fl_width;

@property (nonatomic,assign)CGFloat fl_height;

@end

@implementation UIView (drag)

static char *static_fl_canSlider = "static_fl_canSlider";
static char *static_fl_bounces = "static_fl_bounces";
static char *static_fl_adsorb = "static_fl_adsorb";
static char *static_fl_panG = "static_fl_panG";
/**
 *  @author gitKong
 *
 *  控件当前的下标
 */
static NSUInteger _currentIndex;
/**
 *  @author gitKong
 *
 *  防止先设置bounces 再设置 fl_canSlide 而重置fl_bounces的值
 */
BOOL _bounces = YES;
BOOL _absorb = YES;

- (void)setFl_canSlide:(BOOL)fl_canSlide{
    objc_setAssociatedObject(self, &static_fl_canSlider, @(fl_canSlide), OBJC_ASSOCIATION_ASSIGN);
    if (fl_canSlide) {
        [self fl_addPanGesture];
        self.fl_bounces = _bounces;
        self.fl_isAdsorb = _absorb;
        _currentIndex = [self.superview.subviews indexOfObject:self];
    }
    else{
        [self fl_removePanGesture];
    }
}

- (BOOL)fl_canSlide{
    NSNumber *flagNum = objc_getAssociatedObject(self, &static_fl_canSlider);
    return flagNum.boolValue;
}

- (void)setPanG:(UIPanGestureRecognizer *)panG{
    objc_setAssociatedObject(self, &static_fl_panG, panG, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)panG{
    return objc_getAssociatedObject(self, &static_fl_panG);
}

- (void)setFl_bounces:(BOOL)fl_bounces{
    objc_setAssociatedObject(self, &static_fl_bounces, @(fl_bounces), OBJC_ASSOCIATION_ASSIGN);
    _bounces = fl_bounces;
}

- (BOOL)fl_bounces{
    NSNumber *flagNum = objc_getAssociatedObject(self, &static_fl_bounces);
    return flagNum.boolValue;
}

- (void)setFl_isAdsorb:(BOOL)fl_isAdsorb{
    objc_setAssociatedObject(self, &static_fl_adsorb, @(fl_isAdsorb), OBJC_ASSOCIATION_ASSIGN);
    _absorb = fl_isAdsorb;
}

- (BOOL)fl_isAdsorb{
    NSNumber *flagNum = objc_getAssociatedObject(self, &static_fl_adsorb);
    return flagNum.boolValue;
}

#pragma mark -- private method

- (void)fl_addPanGesture{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOperation:)];
    self.panG = panG;
    [self addGestureRecognizer:panG];
}

- (void)fl_removePanGesture{
    [self removeGestureRecognizer:self.panG];
    self.panG = nil;
}

- (void)panOperation:(UIPanGestureRecognizer *)gesR{
    
    CGPoint translatedPoint = [gesR translationInView:self];
    CGFloat x = gesR.view.fl_centerX + translatedPoint.x;
    CGFloat y = gesR.view.fl_centerY + translatedPoint.y;
    
    switch (gesR.state) {
        case UIGestureRecognizerStateBegan:{
            // 遮盖处理
            [[self superview] bringSubviewToFront:self];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (!self.fl_bounces) {
                if (x < self.fl_width / 2) {
                    x = self.fl_width / 2;
                }
                else if (x > self.superview.fl_width - self.fl_width / 2) {
                    x = self.superview.fl_width - self.fl_width / 2;
                }
                if (y < self.fl_height / 2) {
                    y = self.fl_width / 2;
                }
                else if(y > self.superview.fl_height - self.fl_height / 2){
                    y = self.superview.fl_height - self.fl_height / 2;
                }
            }
            gesR.view.center = CGPointMake(x, y);
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
            if (y < self.fl_height / 2) {
                y = self.fl_width / 2;
            }
            else if(y > self.superview.fl_height - self.fl_height / 2){
                y = self.superview.fl_height - self.fl_height / 2;
            }
            
            if (!self.fl_isAdsorb) {
                if (gesR.view.fl_x < self.superview.fl_x) {
                    x = self.superview.fl_x + gesR.view.fl_width / 2;
                }
                else if (gesR.view.fl_x + gesR.view.fl_width > self.superview.fl_width){
                    x = self.superview.fl_width - gesR.view.fl_width / 2;
                }
                [UIView animateWithDuration:0.25 animations:^{
                    gesR.view.center = CGPointMake(x, y);
                }];
            }
            else{
                // 此时需要加上父类的x值，比较的应该是绝对位置，而不是相对位置
                if (gesR.view.fl_centerX + self.superview.fl_x > self.superview.fl_centerX) {
                    [UIView animateWithDuration:0.25 animations:^{
                        gesR.view.center = CGPointMake(self.superview.fl_width - self.fl_width / 2, y);
                    }];
                    
                }
                else{
                    [UIView animateWithDuration:0.25 animations:^{
                        gesR.view.center = CGPointMake(self.fl_width / 2, y);
                    }];
                    
                }
            }
            // 遮盖处理，如果不遮盖，重置原来位置
            if (![self fl_isCover]) {
                [self.superview insertSubview:self atIndex:_currentIndex];
            }
            else{
                [self.superview bringSubviewToFront:self];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            break;
        }
        case UIGestureRecognizerStateFailed:{
            NSAssert(YES, @"手势失败");
            break;
        }
        default:
            break;
    }
    // 重置
    [gesR setTranslation:CGPointMake(0, 0) inView:self];
}

- (BOOL)fl_isCover{
    BOOL flag = NO;
    for (UIView *view in self.superview.subviews) {
        if (view == self) continue;
        if ([self fl_intersectsWithView:view]) {
            flag = YES;
        }
    }
    return flag;
}

- (BOOL)fl_intersectsWithView:(UIView *)view{
    //都先转换为相对于窗口的坐标，然后进行判断是否重合
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}


- (CGFloat)fl_x{
    return self.frame.origin.x;
}

- (CGFloat)fl_y{
    return self.frame.origin.y;
}

- (CGFloat)fl_centerX{
    return self.center.x;
}

- (CGFloat)fl_centerY{
    return self.center.y;
}

- (CGFloat)fl_width{
    return self.frame.size.width;
}

- (CGFloat)fl_height{
    return self.frame.size.height;
}

- (void)setFl_x:(CGFloat)fl_x{
    self.frame = (CGRect){
        .origin = {.x = fl_x, .y = self.fl_y},
        .size   = {.width = self.fl_width, .height = self.fl_height}
    };
}

- (void)setFl_y:(CGFloat)fl_y{
    self.frame = (CGRect){
        .origin = {.x = self.fl_x, .y = fl_y},
        .size   = {.width = self.fl_width, .height = self.fl_height}
    };
}

- (void)setFl_centerX:(CGFloat)fl_centerX{
    CGPoint center = self.center;
    center.x = fl_centerX;
    self.center = center;
}

- (void)setFl_centerY:(CGFloat)fl_centerY{
    CGPoint center = self.center;
    center.y = fl_centerY;
    self.center = center;
}


- (void)setFl_width:(CGFloat)fl_width{
    self.frame = (CGRect){
        .origin = {.x = self.fl_x, .y = self.fl_y},
        .size   = {.width = fl_width, .height = self.fl_height}
    };
}

- (void)setFl_height:(CGFloat)fl_height{
    self.frame = (CGRect){
        .origin = {.x = self.fl_x, .y = self.fl_y},
        .size   = {.width = self.fl_width, .height = self.fl_height}
    };
}


@end
