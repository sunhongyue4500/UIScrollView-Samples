//
//  ViewController.m
//  AutoLayout
//
//  Created by Allen Hsu on 11/17/14.
//  Copyright (c) 2014 Glow, Inc. All rights reserved.
//

#import "ViewController.h"
#import "PureLayout.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
/** contentView.width  and superView.width constraint*/ 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (assign, nonatomic) int pageBeforeRotation;
@property (assign, nonatomic) int totalPages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self generateRandomPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - **************** 屏幕旋转处理
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    int page = roundf(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    page = MIN(MAX(page, 0), self.totalPages);
    self.pageBeforeRotation = page;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.pageBeforeRotation, 0.0);
}

- (IBAction)didClickRegenerate:(id)sender {
    [self generateRandomPages];
}

- (void)generateRandomPages
{
    int pages = arc4random() % 10 + 10;
    [self setupPages:pages];
}

- (void)setupPages:(int)pages
{
    self.totalPages = pages;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        NSArray *subviews = self.contentView.subviews;
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        [self.contentWidthConstraint autoRemove];
        // 依据页数修改宽度约束
        // 拉长contentView
        self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:pages];
        
        UILabel *prevLabel = nil;
        for (int i = 0; i < pages; ++i) {
            UILabel *pageLabel = [[UILabel alloc] initWithFrame:self.scrollView.bounds];
            pageLabel.text = [NSString stringWithFormat:@"Page %d of %d", i + 1, pages];
            pageLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:18.0];
            pageLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.contentView addSubview:pageLabel];
            
            [pageLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
            [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            
            if (!prevLabel) {
                // Align to contentView
                // 第一个label 和scrollview的左边对齐
                [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            } else {
                // Align to prev label
                // 其余label的头和上一个label的尾对齐
                [pageLabel autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:prevLabel];
            }
            
            if (i == pages - 1) {
                // Last page
                // 最后一个label和scroolView的右边对齐
                [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
            }
            
            prevLabel = pageLabel;
        }
        
        // 内容偏移清零
        self.scrollView.contentOffset = CGPointZero;
    
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.alpha = 1.0;
        }];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
