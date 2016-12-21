//
//  ViewController.m
//  NTLocationSelectView
//
//  Created by NTTian on 2016/12/20.
//  Copyright © 2016年 liying. All rights reserved.
//

#import "ViewController.h"
#import "NTChooseLocationView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

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

- (IBAction)selectAction:(id)sender {
    NTChooseLocationView * locationView = [[NTChooseLocationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    __weak typeof (self) weakSelf = self;
    locationView.showAnimate = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
        }];
    };
    locationView.hiddenAnimate = ^(){
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.view.transform =CGAffineTransformMakeScale(1, 1);
        }];
    };

    [locationView showLocationViewWithData:nil WithBlock:^(NSString *location, NSString *locationCode) {
        weakSelf.locationLabel.text = location;
    }];
    [[[UIApplication sharedApplication] windows][0] addSubview:locationView];
}

@end
