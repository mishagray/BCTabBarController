#import "BCTabBar.h"
#import "BCTab.h"
#define kTabMargin 2.0

@interface BCTabBar ()
//@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) UIImageView *backgroundImageView;

- (void)positionArrowAnimated:(BOOL)animated;
@end

@implementation BCTabBar
@synthesize tabs, selectedTab, backgroundImageView, arrow, delegate,selectedTabNum;

- (id)initWithFrame:(CGRect)aFrame {

	if (self = [super initWithFrame:aFrame]) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BCTabBarController.bundle/tab-bar-background.png"]];
        self.backgroundImageView.frame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
//        self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.backgroundImageView];
        
		self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BCTabBarController.bundle/tab-arrow.png"]];
		CGRect r = self.arrow.frame;
		r.origin.y = - (r.size.height - 2);
		self.arrow.frame = r;
		[self addSubview:self.arrow];
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
		                        UIViewAutoresizingFlexibleTopMargin;
						 
	}
	
	return self;
}

/* - (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self.backgroundImage drawAtPoint:CGPointMake(0, 0)];
//	[[UIColor blackColor] set];
//	CGContextFillRect(context, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
} */

- (void)setTabs:(NSArray *)array {
    if (tabs != array) {
        for (BCTab *tab in tabs) {
            [tab removeFromSuperview];
        }

        tabs = array;        
        
        for (BCTab *tab in tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
        }
        [self setNeedsLayout];

    }
}

- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated {
	if (aTab != selectedTab) {
		selectedTab = aTab;
		selectedTab.selected = YES;
		
        NSUInteger index = 0;
		for (BCTab *tab in tabs) {
			if (tab != aTab) {
                tab.selected = NO;
            }
            else {
                selectedTabNum = index;
            }
            index++;
		}
        NSLog(@"setSelectedTab animated:%d %d %@",animated, selectedTabNum,[selectedTab description]);
       [self positionArrowAnimated:animated];
	}
}


- (void)setSelectedTabNum:(NSUInteger)aSelectedTabNum animated:(BOOL)animated {
    NSLog(@"setSelectedTabNum:%d ",aSelectedTabNum);
    if (selectedTabNum != aSelectedTabNum) {
        BCTab * tab = [tabs objectAtIndex:aSelectedTabNum];
        [self setSelectedTab:tab animated:animated];
    }
}

- (void)setSelectedTabNum:(NSUInteger)aSelectedTabNum {
    if (selectedTabNum != aSelectedTabNum) {
        [self setSelectedTabNum:aSelectedTabNum animated:YES];
    }
}


- (void)setSelectedTab:(BCTab *)aTab {
    NSLog(@"setSelectedTab %@",[aTab description]);
	[self setSelectedTab:aTab animated:YES];
}

- (void)tabSelected:(BCTab *)sender {
    NSUInteger tabN = [self.tabs indexOfObject:sender];
    NSLog(@"tabSelected to page:%d",tabN);
	[self.delegate tabBar:self didSelectTabAtIndex:tabN];
}

- (void)positionArrowAnimated:(BOOL)animated {
    
    NSLog(@"positionArrowAnimated %@",[self.arrow description]);
    CGFloat duration = 0.2;
    if (animated != TRUE)
        duration = 0.0;
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                        CGRect f = self.arrow.frame;
                        CGPoint tabCenter = self.selectedTab.center;
                        f.origin.x = tabCenter.x - (f.size.width / 2);
                        self.arrow.frame = f;
                        }
                     completion:^(BOOL finished) {
                        }
     ];
    
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = self.bounds;
	f.size.width /= self.tabs.count;
	f.size.width -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
	for (BCTab *tab in self.tabs) {
		f.origin.x += kTabMargin;
		tab.frame = CGRectMake(floorf(f.origin.x), f.origin.y, floorf(f.size.width), f.size.height);
		f.origin.x += f.size.width;
		[self addSubview:tab];
	}
    [self bringSubviewToFront:self.arrow];
	
	[self positionArrowAnimated:NO];
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}


@end
