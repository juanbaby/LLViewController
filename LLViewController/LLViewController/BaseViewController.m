//
//  BaseViewController.m
//  LLViewController
//
//  Created by wanglulu on 2017/8/8.
//  Copyright © 2017年 wanglulu. All rights reserved.
//

#import "BaseViewController.h"
#import "NetVC.h"
#import "HotPointVC.h"
#import "VideoVC.h"
#import "MusicVC.h"
#import "ScienceVC.h"
#import "AmuseVC.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
@interface BaseViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *tittleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property(nonatomic,strong)UIButton *recordBut;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentVC];
}

- (void)addContentVC {
    NetVC *netVC = [NetVC new];
    netVC.title = @"网络";
    HotPointVC *hotPoint = [HotPointVC new];
    hotPoint.title = @"热点";
    VideoVC *video = [VideoVC new];
    video.title = @"视频";
    MusicVC *music = [MusicVC new];
    music.title = @"音乐";
    ScienceVC *science = [ScienceVC new];
    science.title = @"科学";
    AmuseVC *amuse = [AmuseVC new];
    amuse.title = @"娱乐";
    [self addChildViewController:netVC];
    [self addChildViewController:hotPoint];
    [self addChildViewController:video];
    [self addChildViewController:music];
    [self addChildViewController:science];
    [self addChildViewController:amuse];
    [self showBaseUI];
}

- (void)showBaseUI{
    _tittleScrollView.contentSize = CGSizeMake(100*self.childViewControllers.count, 0);
    _contentScrollView.contentSize = CGSizeMake(SCREENW*self.childViewControllers.count, 0);
    for (int i = 0; i<self.childViewControllers.count; i++) {
        UIViewController *childVC = self.childViewControllers[i];
        childVC.view.frame = CGRectMake(i*SCREENW, 0, SCREENW, _contentScrollView.frame.size.height);
        UIButton *titleBut = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBut.tag = i+100;
        if (i == 0) {
            titleBut.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.recordBut = titleBut;
        }
        titleBut.center = CGPointMake(50 + 100*i,_tittleScrollView.frame.size.height/2);
        titleBut.bounds = CGRectMake(0, 0, 100, _tittleScrollView.frame.size.height);
        [titleBut setTitle:childVC.title forState:UIControlStateNormal];
        [titleBut setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [titleBut addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tittleScrollView addSubview:titleBut];
        [_contentScrollView addSubview:childVC.view];
    }
   
    
}


- (void)titleButtonAction:(UIButton*)sender {
//    self.recordBut.transform = CGAffineTransformMakeScale(1, 1);
    if ((sender.tag>101)&&(sender.tag<100+self.childViewControllers.count-2)) {
        CGFloat offSet = sender.center.x -(_tittleScrollView.contentOffset.x+_tittleScrollView.center.x);
        CGPoint tittlePoint = _tittleScrollView.contentOffset;
        tittlePoint = CGPointMake(_tittleScrollView.contentOffset.x+offSet, 0);
    [_tittleScrollView setContentOffset:tittlePoint animated:YES];
    }else if (sender.tag<=101){
        [_tittleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (sender.tag>=100+self.childViewControllers.count-2){
        [_tittleScrollView setContentOffset:CGPointMake(self.childViewControllers.count*100-SCREENW, 0) animated:YES];
    }
    [_contentScrollView setContentOffset:CGPointMake((sender.tag-100)*SCREENW, 0) animated:YES] ;
    
}


#pragma mark -- ScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _recordBut = [self.view viewWithTag:(NSInteger)scrollView.contentOffset.x/SCREENW +100];
    CGFloat centerScale = fabs((scrollView.contentOffset.x-SCREENW*(_recordBut.tag-100))/SCREENW);
    CGFloat bigScale =(centerScale)*0.3+1;
    CGFloat smallScale =(1-centerScale)*0.3+1;
    NSInteger nextNum =  (scrollView.contentOffset.x-SCREENW*(_recordBut.tag-100))>0?_recordBut.tag+1:_recordBut.tag-1;
    UIButton *nextBut =[self.view viewWithTag:nextNum];
    _recordBut.transform = CGAffineTransformMakeScale(smallScale, smallScale);
    nextBut.transform = CGAffineTransformMakeScale(bigScale, bigScale);
    if (fmodf(scrollView.contentOffset.x, SCREENW)==0) {
        UIButton *didScrollViewBut = [self.view viewWithTag:scrollView.contentOffset.x/SCREENW+100];
        [self titleButtonAction:didScrollViewBut];
    }
}


@end
