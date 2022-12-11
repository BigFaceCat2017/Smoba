//  Created by 十三哥 on 2022/11/14.
//
#import "JHDragView.h"
#import "PubgLoad.h"
#import "TFJGVGLGKFTVCSV.h"
@implementation JHDragView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
        self.alpha = 50.0f;
        if (frame.size.width<100) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                self.frame=CGRectMake(100, 100, 50, 50);//图标位置大小
                self.layer.cornerRadius = 25;//圆角
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tbimg]];
                UIImage *decodedImage = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.layer.contents = (id)decodedImage.CGImage;
                });
            });
        }
        
    }
    TFJGVGLGKFTVCSV*gzb=[[TFJGVGLGKFTVCSV alloc] init];
    gzb.frame=self.bounds;
    [gzb addSubview:self];
    return self;
}

#pragma mark - override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    self.center = point;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self shouldResetFrame];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self shouldResetFrame];
}

#pragma mark - private

- (void)shouldResetFrame
{
    CGFloat midX = CGRectGetWidth(self.superview.frame)*0.5;
    CGFloat midY = CGRectGetHeight(self.superview.frame)*0.5;
    CGFloat maxX = midX*2;
    CGFloat maxY = midY*2;
    CGRect frame = self.frame;

    if (CGRectGetMinX(frame) < 0 ||
        CGRectGetMidX(frame) <= midX) {
        frame.origin.x = 0;
    }else if (CGRectGetMidX(frame) > midX ||
              CGRectGetMaxX(frame) > maxX) {
        frame.origin.x = maxX - CGRectGetWidth(frame);
    }

    if (CGRectGetMinY(frame) < 0) {
        frame.origin.y = 0;
    }else if (CGRectGetMaxY(frame) > maxY) {
        frame.origin.y = maxY - CGRectGetHeight(frame);
    }

    [UIView animateWithDuration:0.25 animations:^{
        //CGFloat width = MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        //self.frame = CGRectMake(width-70, 100, 65, 65);
        //self.frame = frame;
    }];
}


@end
