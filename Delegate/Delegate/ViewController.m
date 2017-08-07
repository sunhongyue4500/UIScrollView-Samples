//
//  ViewController.m
//  Delegate
//
//  Created by Allen Hsu on 12/13/14.
//  Copyright (c) 2014 Glow, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 只要不松手一直在调用，可以获取scrollView的offset
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self logDraggingAndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self logDraggingAndDecelerating];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%s velocity: %@, targetContentOffset: %@", __PRETTY_FUNCTION__,
          [NSValue valueWithCGPoint:velocity],
          [NSValue valueWithCGPoint:*targetContentOffset]);
    
//    *targetContentOffset = CGPointMake(0, self.scrollView.contentSize.height / 2);
    [self logDraggingAndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, decelerate ? @"减速":@"停止");
    [self logDraggingAndDecelerating];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self logDraggingAndDecelerating];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self logDraggingAndDecelerating];
}

- (void)logDraggingAndDecelerating
{
    NSLog(@"isDraging:%@ isDeceleratin:%@", self.scrollView.isDragging ? @"dragging" : @"", self.scrollView.isDecelerating ? @"decelerating" : @"");
}

@end
