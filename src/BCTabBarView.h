@class BCTabBar;

@interface BCTabBarView : UIView<UIScrollViewDelegate>

// @property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray * tabViews;
@property (nonatomic, strong) BCTabBar *tabBar;
@property (nonatomic, assign) int selectedTab;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) BOOL scrollPagingUsed;


@end
