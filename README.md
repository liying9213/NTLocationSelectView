# NTLocationSelectView
##Describe
收货地址选择器（京东）
## Installation

### CocoaPods    

```ruby
pod 'NTLocationSelect'
```

Then, run the following command:

```bash
$ pod install
```
###Usage
```
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
//        location 选择的地址
//        locationCode 地址所对应的ID(1;1;1)分别对应(省;市;区;镇)
    }];
    [[[UIApplication sharedApplication] windows][0] addSubview:locationView];
```

