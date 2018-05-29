//
//  JYRadarChart.h
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ButtonProtocolName

- (void)buttonWasPressed:(NSDictionary *)dict;

@end

@interface JYRadarChart : UIView

@property (nonatomic, assign) NSUInteger steps;
@property (nonatomic, assign) CGFloat r;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) BOOL fillArea;
@property (nonatomic, assign) BOOL showLegend;
@property (nonatomic, assign) BOOL showAxes;
@property (nonatomic, strong) UIColor *backgroundLineColorRadial;
@property (nonatomic, strong) NSArray *dataSeries;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, strong) UIColor *backgroundFillColor;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL  clockwise; //direction of data
@property (nonatomic, assign) id <ButtonProtocolName> delegate;


//Latest
@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) CGFloat pointsDiameter;
@property (nonatomic, assign) BOOL drawStrokePoints;
@property (nonatomic, assign) CGFloat pointsStrokeSize;

/*
@property (nonatomic, assign) CGFloat colorOpacity;
@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) CGFloat pointsDiameter;
@property (nonatomic, assign) CGFloat pointsStrokeSize;
@property (nonatomic, assign) CGFloat pointsColorOpacity;
@property (nonatomic, assign) BOOL drawStrokePoints;
@property (nonatomic, assign) BOOL showStepText;
@property (nonatomic, strong) NSMutableArray *pointsColors;
@property (nonatomic, strong) NSArray *attributes;

- (void)setPointsColors:(NSMutableArray *)pointsColors;
- (void)setTitles:(NSArray *)titles;
- (void)setColors:(NSArray *)colors;

//    _steps = 2;
//    _drawPoints = NO;
//    _pointsDiameter = 8;
//    _pointsStrokeSize = 2;
//    _pointsColorOpacity = 1;
//    _drawStrokePoints = YES;
//    _showStepText = NO;
//    _pointsColors = nil;
*/
@end
