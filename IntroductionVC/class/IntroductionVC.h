//
//  IntroductionVC.h
//  IntroductionVC
//
//  Created by jhtxch on 16/4/30.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroductionDelegate <NSObject>

- (void)introductionScrollWithContentOffset:(CGFloat)offset;

@end


@interface IntroductionVC : UIViewController

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableDictionary *mainViews;
@property (nonatomic, strong) NSMutableDictionary *minorViews;
@property (nonatomic, assign) BOOL useSystemAnimation;
@property (nonatomic, weak) id<IntroductionDelegate> delegate;


- (instancetype)initWithConfigBlock:(NSArray *(^)(IntroductionVC *vc, NSInteger pagNum))block;

@end