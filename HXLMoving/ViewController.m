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
#import "HXLAnnotation.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()<BMKMapViewDelegate>
@property (weak, nonatomic) BMKMapView* mapView;

@property (strong, nonatomic) HXLLDManager* lldManager;
@property (strong, nonatomic) HXLPolyline* polyLine;

@property (strong, nonatomic) BMKPointAnnotation* startAnnotain;
@property (strong, nonatomic) BMKPointAnnotation* stopAnnotain;

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
    [self.mapView removeAnnotation:self.startAnnotain];
    self.startAnnotain = [BMKPointAnnotation new];
    [self.startAnnotain setCoordinate:self.lldManager.location.coordinate];
    self.startAnnotain.title = @"起";
    [self.mapView addAnnotation:self.startAnnotain];
}

- (void)onPause{
    [self.lldManager pauseMove];
}

- (void)onStop{
    self.lldManager.moveType = HXLMovingTypeNone;
    [self.lldManager endMove];
    [self.mapView removeAnnotation:self.stopAnnotain];
    self.stopAnnotain = [BMKPointAnnotation new];
    [self.stopAnnotain setCoordinate:self.lldManager.location.coordinate];
    self.stopAnnotain.title = @"终";
    [self.mapView addAnnotation:self.stopAnnotain];
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
    mapView.zoomLevel = 17;
    
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
    [self.mapView removeOverlay:self.polyLine];
    self.polyLine = [HXLPolyline polyLineWithPointArray:array];
    [self.mapView addOverlay:self.polyLine];
}

- (BMKOverlayView*)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
//        cutomView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        cutomView.lineWidth = 3.0;
        return cutomView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews{
    HXLLOG(@"didAddOverlayViews");
}

- (BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{    NSString *AnnotationViewID = @"startAnnotation";   
    if (annotation == self.startAnnotain) {
        AnnotationViewID = @"startAnnotation";   
    } else if (annotation == self.stopAnnotain){
        AnnotationViewID = @"stopAnnotation";      
    } 
    
    BMKPinAnnotationView* view;
    if (AnnotationViewID){
        view = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (view == nil) {
            view = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            view.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            view.animatesDrop = YES;
            // 设置可拖拽
            view.draggable = YES;
        } 
    }
    return view;
}


@end
