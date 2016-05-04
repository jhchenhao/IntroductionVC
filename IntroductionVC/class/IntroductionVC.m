//
//  IntroductionVC.m
//  IntroductionVC
//
//  Created by jhtxch on 16/4/30.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "IntroductionVC.h"

#ifndef screen_hlt
#define screen_hlt [UIScreen mainScreen].bounds.size.height
#define screen_wid [UIScreen mainScreen].bounds.size.width
#endif

@interface UIView (Frame)

- (void)set_centerX:(CGFloat)x;
- (void)set_bottom:(CGFloat)bottom;

@end

@implementation UIView (Frame)

- (void)set_centerX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame = CGRectMake(x - frame.size.width / 2, frame.origin.y, frame.size.width, frame.size.height);
    self.frame = frame;
}

- (void)set_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame = CGRectMake(frame.origin.x, bottom - frame.size.height, frame.size.width, frame.size.height);
    self.frame = frame;
}

@end


@interface IntroductionVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageC;
@property (nonatomic, copy) NSArray *(^layoutBlock)(IntroductionVC *vc, NSInteger PagNum);

@end

@implementation IntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubViews];
    [self layoutSubViews];
}

- (void)configSubViews
{
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageC];
    
    //scroll
    _scrollView.frame = self.view.bounds;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(_pageNum * screen_wid, screen_hlt);
    //pageC
    _pageC.frame = CGRectMake(0, 0,screen_wid, 30);
    [_pageC set_centerX:self.view.center.x];
    [_pageC set_bottom:screen_hlt];
    _pageC.numberOfPages = _pageNum;
    _pageC.currentPage = 0;
    _pageC.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageC.currentPageIndicatorTintColor = [UIColor grayColor];
}

- (void)layoutSubViews
{
    for (NSInteger index = 0; index < _pageNum; index ++) {
        NSArray *views = _layoutBlock(self, index);
        [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = view.frame;
            frame = CGRectMake(frame.origin.x + index * screen_wid, frame.origin.y, frame.size.width, frame.size.height);
            view.frame = frame;
            if (_useSystemAnimation) {
                if (index != 0) {
                    view.alpha = 0;
                }                
            }
            [_scrollView addSubview:view];
        }];
    }
}


#pragma mark - init
- (instancetype)init
{
    if ([super init]) {
        [self initDefault];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initDefault];
    }
    return self;
}
- (instancetype)initWithConfigBlock:(NSArray *(^)(IntroductionVC *vc, NSInteger pagNum))block
{
    if (self = [super init]) {
        [self initDefault];
        _layoutBlock = block;
    }
    return self;
}

- (void)initDefault
{
    _scrollView = [[UIScrollView alloc] init];
    _pageC = [[UIPageControl alloc] init];
    _mainViews = [NSMutableDictionary dictionary];
    _minorViews = [NSMutableDictionary dictionary];
}

#pragma mark - scorll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(introductionScrollWithContentOffset:)]) {
        [self.delegate introductionScrollWithContentOffset:scrollView.contentOffset.x];
    }
    if (_useSystemAnimation) {
        if (scrollView.contentOffset.x > -(screen_wid) / 3 && scrollView.contentOffset.x < ((_pageNum - 1) + 1.0 / 3) * (screen_wid) && _pageNum > 0) {
            
            CGFloat scrWid = _scrollView.bounds.size.width;
            CGFloat scrOffX = fabs(_scrollView.contentOffset.x);
            NSInteger nowPage = (scrOffX + scrWid / 2) / scrWid;
            _pageC.currentPage = nowPage;
            [[_minorViews allValues] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != nowPage && view.alpha != 0) {
                    view.alpha = 0;
                }
            }];
            CGFloat ratio = (scrWid / 2 - (fmod(scrOffX, scrWid) < (scrWid / 2) ? fmod(scrOffX, scrWid) : (scrWid - fmod(scrOffX, scrWid)))) / (scrWid / 2);
            NSLog(@"%lf", scrollView.contentOffset.x);
            if (scrollView.contentOffset.x == 375) {
                //            [UIApplication sharedApplication].keyWindow.rootViewController = [UIViewController new];
            }
            UIView *mainView = [_mainViews objectForKey:@(nowPage)];
            if (mainView) {
                mainView.alpha = ratio;
            }
            UIView *minorView = _minorViews[@(nowPage)];
            if (mainView) {
                minorView.alpha = ratio;
                CGFloat offX = ((scrWid / 2) - fmod((scrollView.contentOffset.x + scrWid / 2), scrWid)) * 1.5;
                minorView.transform = CGAffineTransformMakeTranslation(offX, 0);
            }
        }
    }
}

- (void)dealloc
{
    NSLog(@"introductvc dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
