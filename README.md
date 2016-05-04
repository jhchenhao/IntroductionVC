# IntroductionVC
介绍
有些app第一次启动时会有介绍界面  这个就是我为了简化创建介绍页分装的一个类

```
IntroductionVC *vc = [[IntroductionVC alloc] initWithConfigBlock:^(IntroductionVC *vc, NSInteger pagNum) {
//在这个block中写界面
//        if (pagNum == 1) {  //设置第几页 如果不写每页都是一样的
        UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 200, 200)];
        imagev.image = [UIImage imageNamed:@"IMG_0108"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 280, 50)];
        view.backgroundColor = [UIColor yellowColor];
        [vc.mainViews setObject:imagev forKey:@(pagNum)];//加入这个字典会有动画 但是必须要开启useSystemAnimation属性
        [vc.minorViews setObject:view forKey:@(pagNum)];//加入这个字典也会有动画 但是必须要开启useSystemAnimation属性
        return @[imagev, view]; //返回每页添加的子视图
//        }
        return [NSArray array];
    }];
    vc.pageNum = 3;//一共有几页
    vc.delegate = self;<IntroductionDelegate> //设置代理
    vc.useSystemAnimation = YES;//是否开启动画
    self.window.rootViewController = vc;
    
    
    /代理方法
    - (void)introductionScrollWithContentOffset:(CGFloat)offset
```
    
