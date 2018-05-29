//
//  JYRadarChart.m
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "JYRadarChart.h"
#import "JYLegendView.h"
#import <QuartzCore/QuartzCore.h>

#define PADDING 13
#define LEGEND_PADDING 3
#define ATTRIBUTE_TEXT_SIZE 10
#define COLOR_HUE_STEP 5
#define MAX_NUM_OF_COLOR 17

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height <= 320.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#define Good ((int) 100)
#define Average ((int) 67)
#define Bad ((int) 33)
#define Neutral ((int) 0)

@interface JYRadarChart ()

@property (nonatomic, assign) NSUInteger numOfV;
@property (nonatomic, strong) JYLegendView *legendView;
@property (nonatomic, strong) UIFont *scaleFont;

@end

@implementation JYRadarChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues {
    self.backgroundColor = [UIColor whiteColor];
    _centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _r = MIN(self.frame.size.width / 2 - PADDING, self.frame.size.height / 2 - PADDING);
    
    
    _drawPoints = NO;
    _drawStrokePoints = YES;
    _pointsDiameter = 8;
    _pointsStrokeSize = 2;
    
    _showLegend = NO;
    _showAxes = YES;
    _fillArea = YES;
    _minValue = Neutral;
    _maxValue = Good;
//    _legendView = [[JYLegendView alloc] init];
//    _legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
//    _legendView.backgroundColor = [UIColor ora];
    _scaleFont = [UIFont systemFontOfSize:ATTRIBUTE_TEXT_SIZE];
    
    _clockwise = YES;

    
}

- (void)setShowLegend:(BOOL)showLegend {
    _showLegend = showLegend;
    if (_showLegend) {
        [self addSubview:self.legendView];
    }
    else {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[JYLegendView class]]) {
                [subView removeFromSuperview];
            }
        }
    }
}

- (void)setTitles:(NSArray *)titles {
    self.legendView.titles = titles;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [self.legendView sizeToFit];
    [self.legendView setNeedsDisplay];
}

- (void)setDataSeries:(NSMutableArray *)dataSeries {
    _dataSeries = [dataSeries copy];
    NSArray *arr = _dataSeries[0];
    _numOfV = [arr count];
    NSLog(@"the arr %lu",(unsigned long)_numOfV);
}

- (void)layoutSubviews {
    [self.legendView sizeToFit];
    CGRect r = self.legendView.frame;
    r.origin.x = self.frame.size.width - self.legendView.frame.size.width - LEGEND_PADDING;
    r.origin.y = LEGEND_PADDING;
    self.legendView.frame = r;
    [self bringSubviewToFront:self.legendView];
}
-(NSString *)imageNAme:(NSString *)imgStatus{
    
    if ([imgStatus isEqualToString:@"N"]) {
        return @"ic_dash_bkg_inactive";
    } else if([imgStatus isEqualToString:@"G"]){
        return @"ic_dash_bkg_good";
    }else if ([imgStatus isEqualToString:@"B"]){
        return @"ic_dash_bkg_bad";
    }else{
        return @"ic_dash_bkg_average";
    }
    
}
- (void)drawRect:(CGRect)rect {
    
    CGFloat radPerV = M_PI * 2 / _numOfV;
    
    if (_clockwise) {
        radPerV =  - (M_PI * 2 / _numOfV);
    }
    else
    {
        radPerV = (M_PI * 2 / _numOfV);
    }
    NSLog(@"the radPerV is %f",radPerV);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw attribute text
    CGFloat height;
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;

    if (iOSDeviceScreenSize.height == 568) {
        height =11.0;
    } else {
        height = [self.scaleFont lineHeight];
    }
//    CGFloat height = [self.scaleFont lineHeight];
    CGFloat padding = 2.0;
    NSLog(@"the radPerV is %f",height);
//    _dataArray =@[@"Sleep",@"STRENGTH",@"SCREEN TIME",@"METABOLLISAM",@"CARDIO",@"WALK"];
    
    for (int i = 0; i < _numOfV; i++) {
        
        NSDictionary *dict = _dataArray[i];
        NSLog(@"THE DICT IS %@",dict);
        NSInteger width = 0;
        CGPoint legendCenter;
        CGPoint pointOnEdge;
        CGSize attributeTextSize = JY_TEXT_SIZE(@"AH", self.scaleFont);
        CGFloat xOffset,yOffset;
        
        UIImageView *img =[[UIImageView alloc] init];
        UIImageView *backgroundImg =[[UIImageView alloc] init];
        UILabel *fromLabel = [[UILabel alloc]init];
        UILabel *subLabel =[[UILabel alloc] init];
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
//        NSLog(@"text %@",fromLabel.text = [dict valueForKey:@"MD2"]);
        
        switch (i) {
            case 0:
                width = attributeTextSize.width;
                pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
                xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
                yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
                legendCenter = CGPointMake(pointOnEdge.x + xOffset -6, pointOnEdge.y + yOffset -20);
                
                
                if(iOSDeviceScreenSize.height >= 736){
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 -45,60,60);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 -45,60,60);
                    
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-17 ,legendCenter.y - height / 2.0-25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-30,legendCenter.y - height / 2.0 -25,150,15);
                    
                }else if(iOSDeviceScreenSize.height == 568) {
                    
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 -40,45,45);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 -40,45,45);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-27 ,legendCenter.y - height / 2.0-25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-40,legendCenter.y - height / 2.0 -20,150,15);
                }else{
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 -40,50,50);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 -40,50,50);
                    
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-27 ,legendCenter.y - height / 2.0-25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-40,legendCenter.y - height / 2.0 -20,150,15);
                }
                break;
            case 1:
                width = attributeTextSize.width;
                pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
                xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
                yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
                legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset - 5);
                
                if(iOSDeviceScreenSize.height >= 736){
                    
                    img.frame = CGRectMake(legendCenter.x - width / 2.0+5,legendCenter.y - height / 2.0 -45,60,60);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0+5,legendCenter.y - height / 2.0 -45,60,60);
                    
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0+20 ,legendCenter.y - height / 2.0-25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0+8,legendCenter.y - height / 2.0 -25,150,15);
                    
                    
                }else if(iOSDeviceScreenSize.height == 568) {
                    img.frame = CGRectMake(legendCenter.x - width / 2.0+3,legendCenter.y - height / 2.0 -40,45,45);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0+3,legendCenter.y - height / 2.0 -40,45,45);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0+9 ,legendCenter.y - height / 2.0-25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-2,legendCenter.y - height / 2.0 -25,150,15);
                }else{
                    img.frame = CGRectMake(legendCenter.x - width / 2.0+5,legendCenter.y - height / 2.0 -40,50,50);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0+5,legendCenter.y - height / 2.0 -40,50,50);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0+12 ,legendCenter.y - height / 2.0-25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0,legendCenter.y - height / 2.0 -25,150,15);
                }
                
                break;
            case 2:
                width = attributeTextSize.width;
                pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
                xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
                yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
                legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset + 5);
                
                if(iOSDeviceScreenSize.height >= 736){
                    img.frame = CGRectMake(legendCenter.x - width / 2.0+5 ,legendCenter.y - height / 2.0 ,60,60);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0+5 ,legendCenter.y - height / 2.0,60,60);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0+20,legendCenter.y - height / 2.0+20,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0+8,legendCenter.y - height / 2.0 +20,150,15);
                    
                }else if(iOSDeviceScreenSize.height == 568) {
                    img.frame = CGRectMake(legendCenter.x - width / 2.0+3 ,legendCenter.y - height / 2.0 +8,45,45);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0+3 ,legendCenter.y - height / 2.0 +8,45,45);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0+9,legendCenter.y - height / 2.0+25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-2,legendCenter.y - height / 2.0 +20,150,15);
                }else{
                    img.frame = CGRectMake(legendCenter.x - width / 2.0+5 ,legendCenter.y - height / 2.0 +5,50,50);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0+5 ,legendCenter.y - height / 2.0 +5,50,50);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0+12,legendCenter.y - height / 2.0+25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0,legendCenter.y - height / 2.0 +20,150,15);
                }
                
                
                break;
            case 3:
                width = attributeTextSize.width;
                pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
                xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
                yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
                legendCenter = CGPointMake(pointOnEdge.x + xOffset -6, pointOnEdge.y + yOffset +20);
                
                if(iOSDeviceScreenSize.height == 736){
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 ,60,60);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0,60,60);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-17 ,legendCenter.y - height / 2.0 +20,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-30,legendCenter.y - height / 2.0 +18,150,15);
                    
                    
                }else if(iOSDeviceScreenSize.height == 568) {
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 + 5,45,45);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 + 5,45,45);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-27 ,legendCenter.y - height / 2.0 +20,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-38,legendCenter.y - height / 2.0 +16,150,15);
                    
                }else{
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 + 5,50,50);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 35,legendCenter.y - height / 2.0 + 5,50,50);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-27 ,legendCenter.y - height / 2.0 +20,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-38,legendCenter.y - height / 2.0 +16,150,15);
                    
                }
                
                break;
            case 4:
                width = attributeTextSize.width;
                
                pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
                xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
                yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
                legendCenter = CGPointMake(pointOnEdge.x + xOffset -6, pointOnEdge.y + yOffset +20);
                
                if(iOSDeviceScreenSize.height >= 736){
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 70,legendCenter.y - height / 2.0-20 ,60,60);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 70,legendCenter.y - height / 2.0 -20,60,60);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-52 ,legendCenter.y - height / 2.0,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-65,legendCenter.y - height / 2.0,150,15);
                }else if(iOSDeviceScreenSize.height == 568) {
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 55,legendCenter.y - height / 2.0-15 ,45,45);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 55,legendCenter.y - height / 2.0 -15,45,45);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-52 ,legendCenter.y - height / 2.0,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-65,legendCenter.y - height / 2.0+5,150,15);
                }else{
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 60,legendCenter.y - height / 2.0-15 ,50,50);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 60,legendCenter.y - height / 2.0 -15,50,50);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-52 ,legendCenter.y - height / 2.0,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-65,legendCenter.y - height / 2.0+5,150,15);
                }
                break;
            case 5:
                width = attributeTextSize.width;
                pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
                xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
                yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
                legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset - 5);
                
                if(iOSDeviceScreenSize.height >= 736){
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 75,legendCenter.y - height / 2.0 -45,60,60);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 75,legendCenter.y - height / 2.0 -45,60,60);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-57,legendCenter.y - height / 2.0 - 25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-70,legendCenter.y - height / 2.0 -25,150,15);
                    
                }else if(iOSDeviceScreenSize.height == 568) {
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 60,legendCenter.y - height / 2.0 -40,45,45);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 60,legendCenter.y - height / 2.0 -40,45,44);
                    
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-57,legendCenter.y - height / 2.0 - 25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-70,legendCenter.y - height / 2.0 -25,150,15);
                    
                }else{
                    img.frame = CGRectMake(legendCenter.x - width / 2.0 - 65,legendCenter.y - height / 2.0 -40,50,50);
                    backgroundImg.frame = CGRectMake(legendCenter.x - width / 2.0 - 65,legendCenter.y - height / 2.0 -40,50,50);
                    fromLabel.frame = CGRectMake(legendCenter.x - width / 2.0-57,legendCenter.y - height / 2.0 - 25,100,15);
                    subLabel.frame = CGRectMake(legendCenter.x - width / 2.0-70,legendCenter.y - height / 2.0 -25,150,15);
                }
                break;
            default:
                break;
        }
       
        img.image = [UIImage imageNamed:[self imageNAme:[dict valueForKey:@"MD0"]]];
        backgroundImg.image = [UIImage imageNamed:[dict valueForKey:@"MD1"]];
        backgroundImg.transform = CGAffineTransformMakeRotation(M_PI_2*3);
//        [button setImage:[UIImage imageNamed:[dict valueForKey:@"MD1"]] forState:UIControlStateNormal];
        fromLabel.text = [dict valueForKey:@"MD2"];
        subLabel.text =[dict valueForKey:@"MD3"];
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSingleTap:)];
        tapGesture1.numberOfTapsRequired = 1;
        backgroundImg.tag = i;
        [img addGestureRecognizer:tapGesture1];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSingleTap:)];
        tapGesture.numberOfTapsRequired = 1;
        img.tag = i;
        [img addGestureRecognizer:tapGesture];
        
        [self addSubview:img];
        [self addSubview:backgroundImg];
        
        
//        CALayer *layer = button.layer;
//        layer.backgroundColor = [[UIColor clearColor] CGColor];
//        
//        button.transform = CGAffineTransformMakeRotation(M_PI_2*3);
//        button.layer.cornerRadius = button.frame.size.width/2;
//        button.clipsToBounds = YES;
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        button.tag = i;
//         [button setBackgroundColor:[UIColor redColor]];
//        [button addTarget:self action:@selector(attributeName:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
        
        [fromLabel setFont:[UIFont systemFontOfSize:11]];
        fromLabel.transform = CGAffineTransformMakeRotation(M_PI_2*3);
        fromLabel.textColor = [UIColor darkGrayColor];
        fromLabel.textAlignment = NSTextAlignmentCenter;
        fromLabel.numberOfLines = 1;
        [self addSubview:fromLabel];
        
        [subLabel setFont:[UIFont systemFontOfSize:9]];
        subLabel.transform = CGAffineTransformMakeRotation(M_PI_2*3);
        subLabel.textColor = [UIColor lightGrayColor];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.numberOfLines = 2;
        [self addSubview:subLabel];
        
    }
    
    //draw background fill color
    
    [[UIColor clearColor] setFill];
    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r);
    for (int i = 1; i <= _numOfV; ++i) {
        CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
                                _centerPoint.y - _r * cos(i * radPerV));
    }
    CGContextFillPath(context);
    CGContextSetLineWidth(context, 2.0);
    
   
    //static CGFloat dashedPattern[] = {3,3};
    //TODO: make this color a variable
    CGContextSaveGState(context);
    _steps = 3;
    for (int step = 1; step <= _steps; step++) {
        
        if (step == 3) {
            [[UIColor colorWithRed:0.59 green:0.79 blue:0.31 alpha:1.0] setStroke];
        } else if(step ==2) {
            [[UIColor colorWithRed:1.00 green:0.77 blue:0.00 alpha:1.0] setStroke];
        }else if(step ==1){
            [[UIColor colorWithRed:0.92 green:0.33 blue:0.16 alpha:1.0] setStroke];
        }else{
            [[UIColor clearColor] setStroke];
        }
        
        //draw steps line
        for (int i = 0; i <= _numOfV; ++i) {
            
            if (i == 0) {
                CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r * step / _steps);
            }
            else {
                CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV) * step / _steps,
                                        _centerPoint.y - _r * cos(i * radPerV) * step / _steps);
            }
        }
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    
    //draw lines from center
    if(_showAxes){
        [[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0] setStroke];
        for (int i = 0; i < _numOfV; i++) {
            CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
            CGContextAddLineToPoint(context,_centerPoint.x - _r * sin(i * radPerV),_centerPoint.y - _r * cos(i * radPerV));
            CGContextStrokePath(context);
        }
    }
    //end of base except axis label
    CGContextSetLineWidth(context, 2.0);
    
   #pragma mark - draw_Lines

    if (_numOfV > 0) {
        
        for (int serie = 0; serie < [_dataSeries count]; serie++) {
            
            [[UIColor colorWithRed:0.25 green:0.71 blue:0.91 alpha:0.8] setFill];
            
            for (int i = 0; i < _numOfV; ++i) {
                
                CGFloat value = [_dataSeries[serie][i] floatValue];
                if (i == 0) {
                    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
                    
                }
                else {
                    CGContextAddLineToPoint(context, _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV), _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV));
                }
                
            }
            CGFloat value = [_dataSeries[serie][0] floatValue];
            CGContextAddLineToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
            
            
            CGContextSetRGBStrokeColor(context, 0.25, 0.71, 0.91, 1.0);
            CGContextStrokePath(context);
//            CGContextFillPath(context);
            CGContextSetLineWidth(context, 1.0);
            
            
        }
        
        for (int serie = 0; serie < [_dataSeries count]; serie++) {
            
            [[UIColor colorWithRed:0.25 green:0.71 blue:0.91 alpha:0.8] setFill];
            
            for (int i = 0; i < _numOfV; ++i) {
                
                CGFloat value = [_dataSeries[serie][i] floatValue];
                if (i == 0) {
                    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
                    
                }
                else {
                    CGContextAddLineToPoint(context, _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV), _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV));
                }
                
            }
            CGFloat value = [_dataSeries[serie][0] floatValue];
            CGContextAddLineToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
            
            CGContextFillPath(context);
            
            
        }
 
        for (int serie = 0; serie < [_dataSeries count]; serie++) {
            
//            [[UIColor colorWithRed:0.40 green:0.76 blue:0.91 alpha:0.6] setFill];
            [[UIColor redColor] setFill];
            for (int i = 0; i < _numOfV; ++i) {
                
                CGFloat value = [_dataSeries[serie][i] floatValue];
                if (i == 0) {
                    CGContextFillEllipseInRect(context, CGRectMake(_centerPoint.x -4, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r -2, 8.0, 8.0));
                }
                else {

                    CGContextFillEllipseInRect(context, CGRectMake(_centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV)-4,_centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV)-2, 8.0, 8.0));
                }
                
            }
            

        }
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    UIView *view1 = recognizer.view; //cast pointer to the derived class if needed
    NSLog(@"%ld", (long)view1.tag);
    CGFloat value =view1.tag;
    [self.delegate buttonWasPressed:[_dataArray objectAtIndex:view1.tag]];
}
-(void)attributeName:(id)sender{
    
    UIButton *button=(UIButton *)sender;
    [self.delegate buttonWasPressed:[_dataArray objectAtIndex:button.tag]];

}
//-(void) dealloc{
//    [super dealloc];
//}
@end
