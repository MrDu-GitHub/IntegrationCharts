//
//  ViewController.m
//  ChareTestDemo
//
//  Created by Gus on 2019/8/12.
//  Copyright © 2019年 Dear_WenXiu. All rights reserved.
//

#import "ViewController.h"
//#import "ChareTestDemo-Bridging-Header.h"
#import "Charts-Swift.h"

@interface ViewController ()

@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) LineChartData *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.chartView];
    
    // 是否开启描述label
    _chartView.chartDescription.enabled = YES;
    
    
    [self initchartViewWithLeftaxisMaxValue:100 MinValue:100];
    
   
}

- (void)initchartViewWithLeftaxisMaxValue:(double)maxValue MinValue:(double)minValue{
 //气泡
//    BalloonMarker *marker = [[BalloonMarker alloc]initWithColor:[UIColororangeColor]font: [UIFontsystemFontOfSize:10]textColor:UIColor.whiteColorinsets:UIEdgeInsetsMake(9.0,8.0,20.0,8.0)];
// marker.bubbleImg =  [UIImageimageNamed:@"chartqipaoBubble"];
// marker.chartView = _chartView;
// marker.minimumSize = CGSizeMake(50.f,25.f);
// _chartView.marker = marker;
    
    // 设置左Y轴
    ChartYAxis *leftAxis = _chartView.leftAxis;[leftAxis removeAllLimitLines];
    leftAxis.axisLineWidth = 1;
    leftAxis.labelCount=7;  //y轴展示多少个
    leftAxis.labelTextColor = [UIColor lightGrayColor];
    leftAxis.axisLineColor = [UIColor lightGrayColor]; //左Y轴线条颜色
    leftAxis.gridColor = [UIColor lightGrayColor];
    leftAxis.zeroLineColor = [UIColor lightGrayColor]; //左Y轴底线条颜色
    leftAxis.drawZeroLineEnabled = YES;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;

    // 设置X轴
    ChartXAxis*xAxis =_chartView.xAxis;
    xAxis.axisLineColor = [UIColor lightGrayColor];
    xAxis.labelFont = [UIFont systemFontOfSize:12];
    xAxis.labelTextColor = [UIColor lightGrayColor];
    xAxis.granularity = 1.0;
    xAxis.drawAxisLineEnabled = YES; //是否画x轴线
    xAxis.drawGridLinesEnabled = YES; //是否画网格
    xAxis.labelCount = 9;
    
    [self setDataCount:20 range:20];
}

//为折线图设置数据
- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSArray *array = @[@47.1, @54.6, @60.3, @64.0, @67.9, @71.5, @74.4, @76.9, @79.5];
    for (int i = 0; i < array.count; i++)
    {
        
        double val = [array[i] doubleValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"icon"]]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        [set1 replaceEntries: values];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:values label:@"DataSet 1"];
        
        set1.drawIconsEnabled = NO;
        
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        [set1 setColor:UIColor.blackColor];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
}

- (void)boyBabyDataArray {
    NSMutableArray *boyBabyDataArray = [NSMutableArray arrayWithCapacity:7];
    [boyBabyDataArray addObject:@[@47.1, @54.6, @60.3, @64.0, @67.9, @71.5, @74.4, @76.9, @79.5]];
    [boyBabyDataArray addObject:@[@48.1, @55.9, @61.7, @65.4, @69.4, @73.1, @76.1, @78.7, @81.4]];
    [boyBabyDataArray addObject:@[@49.2, @57.2, @63.0, @66.8, @70.9, @74.7, @77.8, @80.6, @83.4]];
    
    [boyBabyDataArray addObject:@[@50.4, @58.7, @64.6, @68.4, @72.6, @76.5, @79.8, @82.7, @85.6]];
//                    50.4     58.7     64.6     68.4     72.6     76.5     79.8     82.7     85.6
    
    [boyBabyDataArray addObject:@[@47.1, @54.6, @60.3, @64.0, @67.9, @71.5, @74.4, @76.9, @79.5]];
    [boyBabyDataArray addObject:@[@47.1, @54.6, @60.3, @64.0, @67.9, @71.5, @74.4, @76.9, @79.5]];
    [boyBabyDataArray addObject:@[@47.1, @54.6, @60.3, @64.0, @67.9, @71.5, @74.4, @76.9, @79.5]];
    [boyBabyDataArray addObject:@[@47.1, @54.6, @60.3, @64.0, @67.9, @71.5, @74.4, @76.9, @79.5]];

}

//[boyBabyDataArray addObject:@[@2.62, @4.53, @5.99, @6.80, @7.56, @8.16, @8.68, @9.19, @9.71]];


@end
