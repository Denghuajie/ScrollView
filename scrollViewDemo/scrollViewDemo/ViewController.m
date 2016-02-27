//
//  ViewController.m
//  scrollViewDemo
//
//  Created by Mr.Deng on 16/2/27.
//  Copyright © 2016年 Mr.Deng. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "Masonry.h"
#define kUIScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kUIScreenHeight [UIScreen mainScreen].bounds.size.height
#define btnW 80
#define kSmallScrollViewH 40
@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *smallScrollView;

@property (strong, nonatomic) UIScrollView *bigScrollView;

@property (strong, nonatomic) UIView *tipView;

@property (strong, nonatomic) NSArray *titleArray;

@property (nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) BaseViewController *baseVc;
//@property (strong, nonatomic) UIView *cContentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = [NSArray arrayWithObjects:@"美食", @"化妆", @"烘焙", @"吃货", @"么么哒", @"设计", @"摄影", @"服务", @"运动", nil];
    
    self.smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 40)];
    self.smallScrollView.delegate = self;
    self.smallScrollView.contentSize = CGSizeMake(9 * btnW, 0);
    
    [self.view addSubview:self.smallScrollView];
    
    
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kUIScreenWidth, kUIScreenHeight - 40)];
    [self enableScrollSwitch];
    self.bigScrollView.contentSize = CGSizeMake(9 * kUIScreenWidth, 0);
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.bounces = NO;
    [self.view addSubview:self.bigScrollView];
    
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnW, 0, btnW, self.smallScrollView.frame.size.height);
        btn.backgroundColor = [UIColor brownColor];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.smallScrollView addSubview:btn];
    }
    self.currentIndex = 0;
    self.tipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.smallScrollView.frame.size.height - 3, btnW, 3)];
    self.tipView.backgroundColor = [UIColor redColor];
    [self.smallScrollView addSubview:self.tipView];
    
    [self addChildViewControllers];
}


- (void)addChildViewControllers
{
    for (int i = 0; i < self.titleArray.count; i++) {
        
        BaseViewController *vc = [BaseViewController new];
        
        [self addChildViewController:vc];
        
        
        [self.bigScrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(i * kUIScreenWidth, 0, kUIScreenWidth, self.bigScrollView.frame.size.height);
        
    }
}

- (void)enableScrollSwitch
{
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.bounces = NO;
    
    self.bigScrollView.scrollEnabled = YES;
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.directionalLockEnabled = YES;
    self.bigScrollView.delegate = self;
}

- (void)btnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    self.currentIndex = index;
    
}
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex >= 9 || currentIndex < 0) return;
    _currentIndex = currentIndex;
    
    for (UIButton *btn in self.smallScrollView.subviews) {
        if([btn isKindOfClass:[UIButton class]]){
            if (btn.tag == currentIndex) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    
    
    [self.bigScrollView setContentOffset:CGPointMake(kUIScreenWidth*currentIndex, 0) animated:YES];
    
    UIButton *btn = self.smallScrollView.subviews[currentIndex];
    
    CGFloat offsetX = btn.center.x - self.smallScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.smallScrollView.contentSize.width -self.smallScrollView.frame.size.width;
    if (offsetX < 0) {
        offsetX = 0;
    }else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.smallScrollView setContentOffset:offset animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bigScrollView) {

        CGRect frame = self.tipView.frame;
        
        frame.origin.x = btnW * scrollView.contentOffset.x/kUIScreenWidth;
        
        self.tipView.frame = frame;
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.bigScrollView) {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        self.currentIndex = index;
    }
    
    
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        if (scrollView == self.bigScrollView) {
            int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
            
            self.currentIndex = index;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
