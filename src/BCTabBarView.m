#import "BCTabBarView.h"
#import "BCTabBar.h"

@interface BCTabBarView ()
@property (nonatomic,assign) BOOL scrollAnimation;

@end

@implementation BCTabBarView
@synthesize tabBar, scrollView, tabViews, selectedTab,scrollPagingUsed;

- (void)setTabBar:(BCTabBar *)aTabBar {
    if (tabBar != aTabBar) {
        [tabBar removeFromSuperview];
        tabBar = aTabBar;
        [self addSubview:tabBar];
    }
}

- (void) setTabViews:(NSArray *)_tabViews {
    tabViews = _tabViews;
    CGFloat xValue = 0.0;
    for (UIView * view in tabViews) {
        view.frame = CGRectMake(xValue, 0, view.frame.size.width, self.tabBar.frame.origin.y);
        xValue += view.frame.size.width;
    }
    [scrollView removeFromSuperview];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.tabBar.frame.origin.y)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(xValue, self.frame.size.width);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.bounces = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal  = YES;
    for (UIView * view in tabViews) {
        [view removeFromSuperview];
        [scrollView addSubview:view];
    }
    [self addSubview:scrollView];
    [self sendSubviewToBack:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.scrollAnimation) return;
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    scrollPagingUsed = YES;
    if (self.tabBar.selectedTabNum != page) {
        selectedTab = page;
        [self.tabBar.delegate tabBar:self.tabBar didSelectTabAtIndex:page];
    }
    scrollPagingUsed = NO;
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)sender
{
    self.scrollAnimation = NO;
}

- (void) setSelectedTab:(int)_selectedTab
{
    if ((!scrollPagingUsed) && (selectedTab != _selectedTab)) {
        selectedTab = _selectedTab;
        CGPoint offset = scrollView.contentOffset;
        UIView * view = [tabViews objectAtIndex:selectedTab];
        offset.x = view.frame.origin.x;
        NSLog(@"setContentOffset For:%d",_selectedTab);
        self.scrollAnimation = YES;
       [scrollView setContentOffset:offset animated:YES];
    }
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = scrollView.frame;
	f.size.height = self.tabBar.frame.origin.y;
	scrollView.frame = f;
	[scrollView layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	[RGBCOLOR(230, 230, 230) set];
	CGContextFillRect(c, self.bounds);
}

@end
