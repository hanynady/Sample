//
//  ChartView.h
//  ExchangeApp
//
//  Created by Hany Nady on 7/24/16.
//  Copyright © 2016 Hany Nady. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeApp-Swift.h"

@interface ChartView : UIView

@property (nonatomic, strong)       NSArray         *xAxisValues;
@property (nonatomic, strong)       NSArray         *yAxisValues;

- (instancetype)initWithChartXValues:(NSArray *) chartXValues andChartYValues:(NSArray *)chartYValues;

@end
