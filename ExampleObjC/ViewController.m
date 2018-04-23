//
//  ViewController.m
//  ExampleObjC
//
//  Created by xiaopin on 2018/4/23.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+XPModal.h"

@interface ViewController ()

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XPModalConfiguration *configuration = [XPModalConfiguration defaultConfiguration];
    CGSize contentSize;
    switch (indexPath.row) {
        case 0:
            configuration.direction = XPModalDirectionTop;
            contentSize = CGSizeMake(CGFLOAT_MAX, 300.0);
            break;
        case 1:
            configuration.direction = XPModalDirectionRight;
            contentSize = CGSizeMake(200.0, CGFLOAT_MAX);
            break;
        case 2:
            configuration.direction = XPModalDirectionBottom;
            configuration.enableInteractiveTransitioning = NO;
            configuration.enableBackgroundAnimation = YES;
            configuration.backgroundColor = [UIColor purpleColor];
            contentSize = CGSizeMake(CGFLOAT_MAX, 300.0);
            break;
        case 3:
            configuration.direction = XPModalDirectionLeft;
            contentSize = CGSizeMake(200.0, [UIScreen mainScreen].bounds.size.height);
            break;
        case 4:
            configuration.direction = XPModalDirectionCenter;
            contentSize = CGSizeMake(200.0, 300.0);
            break;
        default: return;
    }
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor brownColor];
    [self presentModalWithViewController:vc contentSize:contentSize configuration:configuration completion:nil];
}


@end
