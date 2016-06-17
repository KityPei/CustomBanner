//
//  CustomBannerView.m
//  CustomBanner
//
//  Created by Kity_Pei on 16/6/3.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//
#import "CustomBannerView.h"
#import "UIImageView+WebCache.h"
// PageControl的高度
static CGFloat const kBannerPageControlHeight = 20.0f;
// PageControl的宽度
static CGFloat const kBannerPageControlWidth = 100.0f;
//在一页呆的时长
static NSTimeInterval const kDefaultStayInterval = 2.0;
//滚动的时长
static NSTimeInterval const kDefaultScrollInterval = 0.7;

static CGFloat const kMargin = 10.0f;

@interface CustomBannerView ()<UIScrollViewDelegate>
{
    NSInteger totalOfIndex;//总个数
    NSInteger currentIndex;//当前个数
    BOOL scrollTowardsToRight;//是否自左而右
}
@property (nonatomic,strong)UIScrollView *bannerScroll;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation CustomBannerView

- (instancetype)initWithFrame:(CGRect)frame andImageList:(NSArray *)ImageList withPageControlLocation:(PageControlLocation)location
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        scrollTowardsToRight = YES;
        
        totalOfIndex = ImageList.count;//计算一共有多少页
        currentIndex = 0;//pagecontrol选取当前页
        _bannerScroll = [[UIScrollView alloc] initWithFrame:frame];
        _bannerScroll.delegate = self;
        _bannerScroll.pagingEnabled = YES;
        _bannerScroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:_bannerScroll];
        
        _bannerScroll.contentSize = CGSizeMake(frame.size.width*totalOfIndex, frame.size.height);
        
        if (location) {
            if (ImageList.count > 0) {
                if (location == LocationAtLeft) {
                    self.pageControl.frame = CGRectMake(kMargin, frame.size.height-kBannerPageControlHeight-kMargin, kBannerPageControlWidth, kBannerPageControlHeight);
                }
                else if (location == LocationAtRight)
                {
                    self.pageControl.frame = CGRectMake(DEVICE_WIDTH-10-kBannerPageControlWidth, frame.size.height-kBannerPageControlHeight-kMargin, kBannerPageControlWidth, kBannerPageControlHeight);
                }
                else
                {
                    self.pageControl.frame = CGRectMake((DEVICE_WIDTH-kBannerPageControlWidth)/2, frame.size.height-kBannerPageControlHeight-kMargin, kBannerPageControlWidth, kBannerPageControlHeight);
                }
                [self setImageViewBy:ImageList];
            }
            else if(!ImageList||ImageList.count == 0)
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                imageView.image = [UIImage imageNamed:DEFAULT_IMAGE];
                [_bannerScroll addSubview:imageView];
            }
        }
        
    }
    return self;
}

// 懒加载 设置UIPageControl
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = totalOfIndex;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

//设置图片
- (void)setImageViewBy:(NSArray *)ImageList
{
    for (int i = 0; i < ImageList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * i, 0, DEVICE_WIDTH, _bannerScroll.frame.size.height)];
        NSString *imageName = [ImageList objectAtIndex:i];
        if ([imageName rangeOfString:@"http://"].location != NSNotFound) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:imageName];
        }
        [_bannerScroll addSubview:imageView];
    }
}

//pageControl点击事件
- (void)pageControlClicked:(UIPageControl *)pageControl
{
    //实现点击翻页
}

//启动定时器
- (void)triggerTimer
{
    if (self.timer) {
        [self.timer invalidate];
    }
    NSTimeInterval interval = kDefaultStayInterval;
    if (self.stayInteval > 0) {
        interval = self.stayInteval;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(autoScroll:) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark --scrollerviewdelegate--
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //滚动开始拖动，把定时器取消
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentIndex = (NSInteger)(scrollView.contentOffset.x/DEVICE_WIDTH);
    _pageControl.currentPage = currentIndex;
    if (self.autoScroll) {
        [self triggerTimer];
    }
}

/**
 *  定时器绑定的方法
 *
 *  @param timer 定时器
 */
- (void)autoScroll:(NSTimer *)timer
{
    if (totalOfIndex==1) {
        return;
    }
    else
    {
        if (currentIndex == totalOfIndex-1 || currentIndex == 0) {
            scrollTowardsToRight = !scrollTowardsToRight;
        }
        
        [self setMyAnimate];
    }
}

/**
 *  定时器启动后scroll和pagecontrol的效果
 */
- (void)setMyAnimate
{
    NSTimeInterval interval = kDefaultScrollInterval;
    if (self.scrollInterval > 0) {
        interval = self.scrollInterval;
    }
    if (scrollTowardsToRight) {
        [UIView animateWithDuration:interval animations:^{
            [_bannerScroll setContentOffset:CGPointMake(DEVICE_WIDTH*(currentIndex+1), 0)];
            _pageControl.currentPage = currentIndex+1;
        } completion:^(BOOL finished) {
            [self triggerTimer];
            currentIndex = _pageControl.currentPage;
        }];
    }
    else
    {
        [UIView animateWithDuration:interval animations:^{
            [_bannerScroll setContentOffset:CGPointMake(DEVICE_WIDTH*(currentIndex-1), 0)];
            _pageControl.currentPage = currentIndex-1;
        } completion:^(BOOL finished) {
            [self triggerTimer];
            currentIndex = _pageControl.currentPage;
        }];
    }
}

/**
 *  开启定时器
 */
- (void)startAutoScoll
{
    self.autoScroll = YES;
    if (!self.autoScroll && totalOfIndex > 1) {
        currentIndex = 1;
        [self triggerTimer];
    }
}

/**
 *  关闭定时器
 */
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


@end
