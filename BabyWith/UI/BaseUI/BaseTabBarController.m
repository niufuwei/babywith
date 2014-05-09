//
//  BaseTabBarController.m
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "BaseTabBarController.h"
#define COLOR(R,G,B)        [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]

#define kTabMainColor       COLOR(190,190,190)

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.tabBar.hidden = YES;
        [self hideExistingTabBar];
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"BaseTabBar" owner:self options:nil];
        _mSegmentBar = [nibObjects objectAtIndex:0];
        _mSegmentBar.mDelegate = self;
        _mSegmentBar.mNormalTextColor       = kTabMainColor;
        _mSegmentBar.mHightlightedTextColor = [UIColor whiteColor];
        _mSegmentBar.mSelectIndex = 0;
        _mSegmentBar.frame = self.tabBar.frame;
        [self.view addSubview:_mSegmentBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

-(void)segmentSelected:(id)sender
{
    self.selectedIndex = _mSegmentBar.mSelectIndex;
}

- (UIViewController*)getCurrentViewController{
    NSInteger index =  self.selectedIndex;
    return [self.viewControllers objectAtIndex:index];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
