@class BCTab;

@protocol BCTabBarDelegate;

@interface BCTabBar : UIView

- (id)initWithFrame:(CGRect)aFrame;
- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated;
- (void)setSelectedTabNum:(NSUInteger)tabNum animated:(BOOL)animated;

@property (nonatomic, strong) NSArray *tabs;
@property (nonatomic, assign) NSUInteger selectedTabNum;
@property (nonatomic, strong) BCTab *selectedTab;
@property (nonatomic, assign) id <BCTabBarDelegate> delegate;
@property (nonatomic, strong) UIImageView *arrow;
@end

@protocol BCTabBarDelegate
- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;
@end