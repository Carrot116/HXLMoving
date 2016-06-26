//
//  ViewController.m
//  HXLMoving
//
//  Created by Carrot on 16/4/19.
//  Copyright © 2016年 Carrot. All rights reserved.
//

#import "ViewController.h"


#import "BaiduMapAPI.h"
#import "HXLLDManager.h"
#import "CustomOverlay.h"
#import "CustomOverlayView.h"
#import "HXLPolyline.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()<BMKMapViewDelegate>
@property (weak, nonatomic) BMKMapView* mapView;

@property (strong, nonatomic) HXLLDManager* lldManager;
@property (strong, nonatomic) HXLPolyline* polyLine;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupBMKMapView];
    
    int width = 60, height = 30, hGap = 10;
    int x = 20;
    int y = 30;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    x = x + width + hGap;
    btn.frame = CGRectMake(x, y, width, height);
    [btn setTitle:@"启动" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(onStart) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    x = x + width + hGap;
    btn.frame = CGRectMake(x, y, width, height);
    [btn setTitle:@"暂停" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(onPause) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    x = x + width + hGap;
    btn.frame = CGRectMake(x, y, width, height);
    [btn setTitle:@"结束" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(onStop) forControlEvents:UIControlEventTouchUpInside];
}

- (HXLLDManager*)lldManager{
    if (!_lldManager) {
        _lldManager = [HXLLDManager new];
    }
    return _lldManager;
}

- (void)onStart{
    self.lldManager.moveType = HXLMovingTypeWalk;
    [self.lldManager startMove];
}

- (void)onPause{
    [self.lldManager pauseMove];
}

- (void)onStop{
    self.lldManager.moveType = HXLMovingTypeNone;
    [self.lldManager endMove];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    [self.lldManager startLocation];
    [self.mapView setShowsUserLocation:NO];            // 先关闭显示定位图层
    [self.mapView setUserTrackingMode:BMKUserTrackingModeFollow];    // 定位模式
    [self.mapView setShowsUserLocation:YES];            // 再开始显示定位图层
    [self drawMoveTrace];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)setupBMKMapView{
    BMKMapView* mapView = [[BMKMapView alloc]init];
    self.mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
//    [mapView setBaiduHeatMapEnabled:YES];       // 显示热力图
    [mapView setShowMapPoi:YES];                // 显示标注
    mapView.zoomLevel = 10;
    
    [self.mapView setShowsUserLocation:YES];            // 再开始显示定位图层
    @weakify(self);
    [RACObserve(self.lldManager, bmkUserLocation) subscribeNext:^(id x) {
        @strongify(self);
        [self.mapView updateLocationData:x];
    }];
    [RACObserve(self.lldManager, location) subscribeNext:^(id x) {
        @strongify(self);
        self.mapView.centerCoordinate = ((CLLocation*)x).coordinate;
        [self drawMoveTrace];
    }];
    
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMoveTrace{
    NSArray* array = [self.lldManager.currentMovement.dataArr copy];
//    NSArray* array = [self.lldManager.currentMovement testData];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXLDPoint* location = (HXLDPoint*)obj;
        HXLLOG(@"%f,%f",location.location.coordinate.latitude, location.location.coordinate.longitude);
    }];
    [self.mapView removeOverlay:self.polyLine];
    self.polyLine = [HXLPolyline polyLineWithPointArray:array];
    [self.mapView addOverlay:self.polyLine];
    HXLLOG(@"%lu", (unsigned long)self.polyLine.pointCount);
    
    HXLLOG(@"%f, %f", self.mapView.region.center.latitude, self.mapView.region.center.longitude);
    HXLLOG(@"%f, %f", self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta);
    HXLLOG(@"%f, %f : %f, %f",self.mapView.region.center.latitude - self.mapView.region.span.latitudeDelta,
           self.mapView.region.center.latitude + self.mapView.region.span.latitudeDelta,
           self.mapView.region.center.longitude - self.mapView.region.span.longitudeDelta,
           self.mapView.region.center.longitude + self.mapView.region.span.longitudeDelta);
    HXLLOG(@"TEST");
}

- (BMKOverlayView*)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        cutomView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        cutomView.lineWidth = 5.0;
        return cutomView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews{
    HXLLOG(@"didAddOverlayViews");
}


@end
