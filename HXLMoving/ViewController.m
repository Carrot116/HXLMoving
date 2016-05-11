//
//  ViewController.m
//  HXLMoving
//
//  Created by Carrot on 16/4/19.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "ViewController.h"


#import "BaiduMapAPI.h"
#import "HXLBaiduMapLocationServices.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//#import <BaiduMapAPI_Map/BMKMapView.h>

@interface ViewController ()<BMKMapViewDelegate>
@property (weak, nonatomic) BMKMapView* mapView;
@property (strong, nonatomic) HXLBaiduMapLocationServices* locationService;

@property (strong, nonatomic) UIButton* btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupBMKMapView];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(40, 30, 100, 30);
    [self.btn setTitle:@"暂停" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(onStop) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onStop{
    static BOOL bStop = NO;
    bStop ? [self.locationService startLocation] : [self.locationService stopLocation];
    
    if (!bStop) {
        NSLog(@"%@", self.locationService.locationArr);
    }
    bStop = !bStop;
}

- (HXLBaiduMapLocationServices*)locationService{
    if (!_locationService) {
        _locationService = [HXLBaiduMapLocationServices new];
    }
    return _locationService;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    [self.locationService startLocation];
    [self.mapView setShowsUserLocation:NO];            // 先关闭显示定位图层
    [self.mapView setUserTrackingMode:BMKUserTrackingModeFollow];    // 定位模式
    [self.mapView setShowsUserLocation:YES];            // 再开始显示定位图层
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    [self.locationService stopLocation];
}

- (void)setupBMKMapView{
    BMKMapView* mapView = [[BMKMapView alloc]init];
    [self.view addSubview:mapView];
    self.mapView = mapView;
//    [mapView setBaiduHeatMapEnabled:YES];       // 显示热力图
    [mapView setShowMapPoi:YES];                // 显示标注
    mapView.zoomLevel = 17;
    [self.mapView setShowsUserLocation:YES];            // 再开始显示定位图层
    
//    // 结构体 observe?
//    [RACObserve(self.locationService, currentCoordinate) subscribeNext:^(id x) {
//        CLLocationCoordinate2D newCoordinate;
//        [x getValue:&newCoordinate];
//        mapView.centerCoordinate = newCoordinate;
//        mapView.userTrackingMode = BMKUserTrackingModeNone;
//    }];
    
    [RACObserve(self.locationService, currentLocation) subscribeNext:^(id x) {
        BMKUserLocation* location = (BMKUserLocation*)x;
        [mapView updateLocationData:location];
        mapView.centerCoordinate = location.location.coordinate;
    }];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
