//
//  CommonProblemsGuideViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "CommonProblemsGuideViewController.h"

@interface CommonProblemsGuideViewController ()

@end

@implementation CommonProblemsGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"常见问题"];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    [_webView setOpaque:NO];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString: htmlString baseURL:[NSURL URLWithString: htmlPath]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
