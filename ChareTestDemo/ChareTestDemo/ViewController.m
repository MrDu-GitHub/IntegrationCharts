//
//  ViewController.m
//  ChareTestDemo
//
//  Created by Gus on 2019/8/12.
//  Copyright © 2019年 Dear_WenXiu. All rights reserved.
//

#import "ViewController.h"
#import "Charts-Swift.h"
#import "ChareTestDemo-Swift.h"

// MARK: -  颜色
#define kRGBColor(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define kRandomColor  KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)

#define GSColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define NavigationBarColor kRGBColor(28, 139, 149) // 导航栏背景色

@interface ViewController () <ChartViewDelegate, IChartAxisValueFormatter>

@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) LineChartData *data;

@property (nonatomic, strong) NSArray *babyMonthArray; // 婴儿月份
@property (nonatomic, strong) NSArray *childYearArray; // 儿童月份

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _chartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
    [self.view addSubview:self.chartView];
    _chartView.delegate = self;
    // 是否开启描述label
    _chartView.chartDescription.enabled = NO;
    _chartView.rightAxis.enabled = NO; // 不绘制右边y轴
    _chartView.legend.enabled = NO; // 底部描述
    
    [self initchartViewWithLeftaxisMaxValue:100 MinValue:100];
    
    [self boyBabyDataArray];
    
   
}

- (void)initchartViewWithLeftaxisMaxValue:(double)maxValue MinValue:(double)minValue{
    // 气泡
    BalloonMarker *marker = [[BalloonMarker alloc]
                             initWithColor: NavigationBarColor
                             font: [UIFont systemFontOfSize:14.0]
                             textColor: UIColor.whiteColor
                             insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.chartView = _chartView;
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _chartView.marker = marker;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LengthCurveData"ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    marker.dataArray = dictionary[@"BoyBabyHeight"];
    
    // 设置左Y轴
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = 120.0; //y轴最大值
    leftAxis.axisMinimum = 40.0;
    leftAxis.axisLineWidth = 1;
    leftAxis.labelCount = 8;  //y轴展示多少个
    leftAxis.labelTextColor = GSColorWithHex(0x333333);
    leftAxis.axisLineColor = GSColorWithHex(0xe6e6e6); //左Y轴线条颜色
    leftAxis.gridColor = GSColorWithHex(0x333333); // 网格线条颜色
//    leftAxis.zeroLineColor = [UIColor lightGrayColor]; //左Y轴底线条颜色
    leftAxis.drawZeroLineEnabled = YES;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.granularityEnabled = YES; //去重

    // 设置X轴
    ChartXAxis*xAxis =_chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.axisLineColor = [UIColor lightGrayColor];
    xAxis.axisLineDashPhase = 2;
    xAxis.labelTextColor = GSColorWithHex(0x333333);
    xAxis.labelFont = [UIFont systemFontOfSize:12];
    xAxis.labelTextColor = [UIColor lightGrayColor];
    xAxis.valueFormatter = self; // 显示自定义X数据
    xAxis.granularityEnabled = YES; //去重

    xAxis.drawAxisLineEnabled = YES; //是否画x轴线
    xAxis.drawGridLinesEnabled = YES; //是否画网格
    xAxis.axisMaximum = 23.0;
//    xAxis.labelCount = 9;
    
//    [self setDataCount:20 range:20];
}

/// 添加基础数据
- (void)setData:(NSArray *)dataArray {
    
    // 线条y值包装数据
    NSMutableArray *yValsArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    
    for (int i = 0; i<dataArray.count; i++) {
        NSArray *yArray = dataArray[i];
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        
        for (int y = 0; y<yArray.count; y++) {
            double val = [yArray[y] doubleValue];
            [yVals addObject:[[ChartDataEntry alloc] initWithX:[self.babyMonthArray[y] doubleValue] y:val]];
        }
        
        [yValsArray addObject:yVals];
    }
    
    if (_chartView.data.dataSetCount > 0) {
        for (int i= 0; i<dataArray.count; i++) {
            LineChartDataSet *lineChat = (LineChartDataSet *)_chartView.data.dataSets[0];
            [lineChat replaceEntries:yValsArray[i]];
        }
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }else {
        // LineChartDataSetArray
        NSMutableArray *lineChartArray = [NSMutableArray arrayWithCapacity:dataArray.count];
        
        for (int i= 0; i<dataArray.count; i++) {
            LineChartDataSet *lineChat = [[LineChartDataSet alloc] initWithEntries:yValsArray[i]];
            lineChat.axisDependency = AxisDependencyLeft;
            lineChat.mode = LineChartModeCubicBezier;
            [lineChat setColor:GSColorWithHex(0xf9ce85)];
            [lineChat setCircleColor:UIColor.whiteColor];
            lineChat.lineWidth = 0.7;
            lineChat.circleRadius = 4.0;
            lineChat.lineDashLengths = @[@4.f, @2.f];
            lineChat.drawCirclesEnabled = NO;
            lineChat.drawValuesEnabled = NO;
            lineChat.highlightEnabled = NO;
            
            if (i == 0 || i == 3 || i==6) {
                lineChat.lineWidth = 2.0;
                lineChat.lineDashLengths = @[@0.01f, @0.01f];
                [lineChat setColor:GSColorWithHex(0xfcd693)];
            }
            
            [lineChartArray addObject:lineChat];
        }
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:lineChartArray];
        _chartView.data = data;
    }
    
    [self setPatientData];
}

/// 添加患者数据
- (void)setPatientData {
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < 1; i++)
//    {
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:6 y:66]];
//    }
    
   
    
    LineChartDataSet *set1 = nil;
    
  
        set1 = [[LineChartDataSet alloc] initWithEntries:yVals1];
        set1.axisDependency = AxisDependencyLeft;
        [set1 setColor:NavigationBarColor];
        set1.lineWidth = 1.5;
    
    //点击选中拐点的交互样式
    set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
    set1.highlightColor = NavigationBarColor;//点击选中拐点的十字线的颜色
    set1.highlightLineDashLengths = @[@4, @4];//十字线的虚线样式
    set1.highlightLineWidth = 2.0;// 十字线宽度
    
    //折线拐点样式
    set1.drawCirclesEnabled = YES;//是否绘制拐点
    set1.circleRadius = 4.0f;//拐点半径
    set1.circleColors = @[NavigationBarColor, [UIColor greenColor]];//拐点颜色
    
    //拐点中间的空心样式
    set1.drawCircleHoleEnabled = YES;//是否绘制中间的空心
    set1.circleHoleRadius = 2.5f;//空心的半径
    set1.circleHoleColor = [UIColor whiteColor];//空心的颜色
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
    [_chartView.data addDataSet:set1];
    
    [_chartView.data notifyDataChanged];
    [_chartView notifyDataSetChanged];
}

#pragma chartViewDelegate
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    NSLog(@"lalalal");
    
}

#pragma mark - IAxisValueFormatter
- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    if (value < 12) {
        if (value == 0) {
            return @"0岁";
        }
        
        return [NSString stringWithFormat:@"%zd个月", (NSInteger)value%12];
    }else {
        if ((NSInteger)value%12) {
            return [NSString stringWithFormat:@"%zd岁%zd个月", (NSInteger)value/12, (NSInteger)value%12];
        }else {
            return [NSString stringWithFormat:@"%zd岁", (NSInteger)value/12];
        }
    }
    return [NSString stringWithFormat:@""];
}


#pragma mark - lazy loading
- (void)boyBabyDataArray {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LengthCurveData"ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    [self setData:dictionary[@"BoyBabyHeight"]];
    NSLog(@"%@", dictionary);
}

#pragma mark - lazy loading
- (NSArray *)babyMonthArray {
    if (!_babyMonthArray) {
        _babyMonthArray = @[@0, @2, @4, @6, @9, @12, @15, @18, @21];
    }
    
    return _babyMonthArray;
}

- (NSArray *)childYearArray {
    if (!_childYearArray) {
        _childYearArray = @[@2, @2.5, @3, @3.5, @4, @4.5, @5, @5.5, @6, @6.5, @7, @7.5, @8, @8.5, @9, @9.5, @10, @10.5, @11, @11.5, @12, @12.5, @13, @13.5, @14, @14.5, @15, @15.5, @16, @16.5, @17, @18];
    }
    
    return _childYearArray;
}

@end
