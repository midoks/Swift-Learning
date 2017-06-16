//
//  ViewController.m
//  QrcodeScanLoginDemo
//
//  Created by midoks on 2017/6/16.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ViewController");
    
    UIButton *login = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    [login setTitle:@"login" forState:UIControlStateNormal];
    login.backgroundColor = [UIColor yellowColor];
    [login addTarget:self action:@selector(QrcodeScan:) forControlEvents:UIControlEventTouchUpInside];
    login.center = self.view.center;
    
    [self.view addSubview:login];
    
}


-(void)QrcodeScan:(UIButton *)btn
{
    NSLog(@"QrcodeScan");
    ScanViewController *scan = [[ScanViewController alloc] init];
    
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
