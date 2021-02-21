//
//  PicfoldingView.m
//  图片折叠
//
//  Created by iiik- on 2021/2/21.
//

#import "PicfoldingView.h"

@interface PicfoldingView()

@property (nonatomic, strong)UIImageView *topImageView;

@property (nonatomic, strong)UIImageView *bottomImageView;

@property (nonatomic, strong)UIView *panView;

@property (nonatomic, strong)CAGradientLayer *gradientL;

@end

@implementation PicfoldingView

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]init];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc]init];
    }
    return _bottomImageView;
}

- (UIView *)panView {
    if (!_panView) {
        _panView = [[UIView alloc]init];
    }
    return _panView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    self.bottomImageView.image = [UIImage imageNamed:@"WechatIMG627"];
    self.bottomImageView.frame = CGRectMake(0, 0, 200, 200);
    [self addSubview:self.bottomImageView];
    
    self.topImageView.image = [UIImage imageNamed:@"WechatIMG627"];
    self.topImageView.frame = CGRectMake(0, 0, 200, 200);
    [self addSubview:self.topImageView];
    
    //上面的imageView只显示上半部分
    self.topImageView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.topImageView.layer.anchorPoint = CGPointMake(0.5, 1);
    //下面的imageView只显示下半部分
    self.bottomImageView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    self.bottomImageView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    //给self上添加一个空白的view 便于添加手势
    self.panView.bounds = CGRectMake(0, 0, 200, 400);
    self.panView.backgroundColor = [UIColor clearColor];
    self.panView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:self.panView];
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.panView addGestureRecognizer:pan];
    
    //添加渐变层
    CAGradientLayer *gradientL = [CAGradientLayer layer];
    gradientL.frame = self.bottomImageView.bounds;
    gradientL.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    //设置透明度
    gradientL.opacity = 0;
    self.gradientL = gradientL;
    [self.bottomImageView.layer addSublayer:gradientL];
}

- (void)pan:(UIPanGestureRecognizer *)panGes {
    //获取偏移量
    CGPoint point = [panGes translationInView:panGes.view];
    CGFloat angle = point.y * M_PI / 400;
    
    //做出近大远小的效果
    CATransform3D transForm = CATransform3DIdentity;
    transForm.m34 = -1/400.0;
    
    self.topImageView.layer.transform = CATransform3DRotate(transForm, -angle, 1, 0, 0);
    
    //改变渐变量
    self.gradientL.opacity = point.y / 400;
    
    //上部动画回弹
    if (panGes.state == UIGestureRecognizerStateEnded) {
        self.gradientL.opacity = 0;
        //usingSpringWithDamping是弹性系数，越小弹力越大
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options: UIViewAnimationOptionCurveLinear  animations:^{
            self.topImageView.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

//self.panView超过了父控件的范围，重写方法让手势能够在self.panView上都有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.panView convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.panView.bounds, newPoint)) {
            view = self.panView;
        }
    }
    return view;
}
@end
