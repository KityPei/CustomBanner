//
//  CustomBannerView.h
//  CustomBanner
//
//  Created by Kity_Pei on 16/6/3.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageControlLocation) {
    LocationAtLeft = 0,
    LocationAtCenter,
    LocationAtRight
};


@interface CustomBannerView : UIView

@property (nonatomic,assign)NSTimeInterval stayInteval;
@property (nonatomic,assign)NSTimeInterval scrollInterval;
@property (nonatomic,assign)BOOL autoScroll;//是否可以滚动
@property (nonatomic,weak)id delegate;

/**
 *  初始化一个banner
 *
 *  @param frame     位置
 *  @param ImageList 传入的图片数组
 *  @param location  PageControl的位置：是一个枚举类型PageControlLocation
 *  @param ImageName 传入placeholder图片
 *
 *  @return banner
 */
- (instancetype)initWithFrame:(CGRect)frame andImageList:(NSArray *)ImageList withPageControlLocation:(PageControlLocation)location;

/**
 *  开始滚动
 */
- (void)startAutoScoll;

/**
 *  停止定时器
 */
- (void)stopTimer;

@end

@protocol CustomBannerViewDelegate <NSObject>

@optional

- (void)didItemClickedInBannerView:(CustomBannerView *)bannerView atIndex:(NSInteger)index;

@end
