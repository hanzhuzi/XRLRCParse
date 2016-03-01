//
//  CustomNavigationController.m
//  XRLrcParse
//
//  Created by xuran on 16/3/1.
//  Copyright © 2016年 X.R. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)customNavigation
{
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Arial Unicode MS" size:20.0],
                                               NSForegroundColorAttributeName : [UIColor blackColor], NSBackgroundColorAttributeName : [UIColor orangeColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
