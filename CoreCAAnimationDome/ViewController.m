//
//  ViewController.m
//  CoreCAAnimationDome
//
//  Created by 颜学宙 on 2021/2/25.
//

#import "ViewController.h"
#define angle2Rad(angle) ((angle)/180.0f * M_PI)
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageVIew;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,weak)CAGradientLayer *gradientLayer;
@property (weak, nonatomic) IBOutlet UIView *ycopyView;

@property (weak, nonatomic) IBOutlet UIView *bottomConatainerViw;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topImageView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    
    self.topImageView.layer.anchorPoint=CGPointMake(0.5, 1);
    
    self.topImageView.layer.position=CGPointMake(self.containerView.frame.size.width*0.5, self.topImageView.frame.size.height);
    
    self.bottomImageVIew.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    self.bottomImageVIew.layer.anchorPoint=CGPointMake(0.5, 0);
    self.bottomImageVIew.layer.position=CGPointMake(self.containerView.frame.size.width*0.5, self.topImageView.frame.size.height);
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame=self.bottomImageVIew.layer.bounds;
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    gradientLayer.opacity = 0;
    self.gradientLayer=gradientLayer;
    [self.bottomImageVIew.layer addSublayer:gradientLayer];
    [self addVolumeToBeatLayer];
    [self reflection];
}
//倒影
-(void)reflection{
  CAReplicatorLayer *repl = (CAReplicatorLayer *)self.ycopyView.layer;
    repl.instanceCount =2;
    repl.anchorPoint = CGPointMake(0.5, 1);
    repl.instanceTransform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    repl.instanceRedOffset -= 0.2;
    repl.instanceBlueOffset -=0.2;
    repl.instanceGreenOffset -=0.2;
    repl.instanceAlphaOffset -=0.2;
}
-(void)addVolumeToBeatLayer{
    
    //复制层
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    repL.frame = self.bottomConatainerViw.bounds;
    //复制的分数 （包括自己）
    repL.instanceCount = 5;
    //对复制出来的子层做形变操作（每一个都是相对应上一个子层做的形变）
    repL.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    //设置复制出来的子层动画延时执行时长
    repL.instanceDelay = 0.5;
    [self.bottomConatainerViw.layer addSublayer:repL];
    
    CALayer *layer=[CALayer layer];
    
    layer.bounds = CGRectMake(0, 0, 40, 60);
    layer.anchorPoint = CGPointMake(0, 1);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.position = CGPointMake(0, self.bottomConatainerViw.frame.size.height);
    [repL addSublayer:layer];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.toValue = @2;
    
//    animation.fromValue =@0.1;
    animation.keyPath = @"transform.scale.y";
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    [layer addAnimation:animation forKey:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"%@",NSStringFromCGRect(self.topImageView.frame));
}
- (IBAction)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint transp=[pan translationInView:pan.view];
    CGFloat angle = transp.y/200.0f;
    
    //近大远小
    CATransform3D transform = CATransform3DIdentity;
    // 眼睛离屏幕的距离 分母越小近处效果越大
    transform.m34 = -1/300.0f;
    self.topImageView.layer.transform=CATransform3DRotate(transform, -M_PI * angle, 1, 0, 0);
    self.gradientLayer.opacity = transp.y / 200.0f;
    if (pan.state==UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear
 animations:^{
            self.topImageView.layer.transform = CATransform3DIdentity;
            self.gradientLayer.opacity=0;
                } completion:^(BOOL finished) {
                    
                }];
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
-(void)groupAnimation{
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath=@"position.y";
    anim.toValue=@400;
//    anim.removedOnCompletion=NO;
//    anim.fillMode=kCAFillModeForwards;
    
    [self.imageView.layer addAnimation:anim forKey:nil];
    
    CABasicAnimation *anim2 = [CABasicAnimation animation];
    anim2.keyPath=@"transform.scale";
    anim2.toValue=@0.5;
//    anim2.removedOnCompletion=NO;
//    anim2.fillMode=kCAFillModeForwards;
    
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations=@[anim,anim2];
    group.removedOnCompletion=NO;
    group.fillMode=kCAFillModeForwards;
    [self.imageView.layer addAnimation:group forKey:nil];
}

static int name=0;
-(void)changeImageAnimation{
    name++;
    if (name>3) {
        name=1;
    }
    [self.imageViewTwo.layer removeAllAnimations];
    NSString *imageName= [NSString stringWithFormat:@"%d",name];
    UIImage *image=[UIImage imageNamed:imageName];
    self.imageViewTwo.image=image;
    
    CATransition *animation = [CATransition animation];
    animation.type=@"pageCurl";
    animation.duration=1;
    //设置动画起始位置
    animation.startProgress = 0.5;
    //设置动画结束位置
    animation.endProgress=0.9;
    [self.imageViewTwo.layer addAnimation:animation forKey:nil];
}
-(void)moveAnimation{
    //    [self.imageView.layer removeAllAnimations];
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animation];
    
    animation.keyPath=@"position";//@"transform.rotation";
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(300, 500)];
    animation.path = path.CGPath;
    animation.removedOnCompletion=NO;
    animation.fillMode = kCAFillModeForwards;
    [self.imageView.layer addAnimation:animation forKey:nil];
}
//抖动动画
-(void)jitterAnimation{
    
//    [self.imageView.layer removeAllAnimations];
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animation];
    animation.keyPath=@"transform.rotation";//@"transform.rotation";
    CGFloat t = angle2Rad(-5);
    CGFloat t1 = angle2Rad(5);
    animation.values=@[@(t),@(t1),@(t)];
    animation.duration=0.5;
    animation.repeatCount = MAXFLOAT;
    //自动反转(怎么去怎么回)
//    animation.autoreverses=YES;
    [self.imageView.layer addAnimation:animation forKey:nil];
}
-(void)beginHeartbeatAnimation{
    [self.imageView.layer removeAllAnimations];
    CABasicAnimation *animation=[CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.toValue=@0.2;
    //设置动画执行次数
    animation.repeatCount = MAXFLOAT;
    //设置一次动画执行时间
    animation.duration = 0.5;
    //自动反转(怎么去怎么回)
    animation.autoreverses=YES;
    
    [self.imageView.layer addAnimation:animation forKey:nil];
}
-(void)baseAnimation{
    
    [self.animationView.layer removeAllAnimations];
//    创建Animation对象
    CABasicAnimation *basicA = [CABasicAnimation animation];
    //设置属性值
    basicA.keyPath=@"position.x";
    basicA.toValue = @(300);
    //设置动画完成时，是否删除动画（不设置默认是删除，会回到初始位置）
    basicA.removedOnCompletion=NO;
    basicA.fillMode = kCAFillModeForwards;
    [self.animationView.layer addAnimation:basicA forKey:nil];
    
    
    
}
@end
