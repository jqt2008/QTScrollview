//
//  ViewController.m
//  自定义轮播图
//
//  Created by 漫漫人生路 on 2020/10/15.
//  Copyright © 2020 漫漫人生路. All rights reserved.
//

#import "ViewController.h"
#import "QTCustomScrollview.h"
#import "Masonry.h"
#import "NextViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet QTCustomScrollview *scrollview2;
@property (strong, nonatomic) QTCustomScrollview *scrollview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.font = [UIFont systemFontOfSize:30];
    label.text = @"代码显示";
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor greenColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setTitle:@"下一页" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextPageController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(120);
        make.height.mas_offset(280);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(self.scrollview);
        make.bottom.equalTo(self.scrollview.mas_top).offset(-20);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerY.equalTo(label);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    
    // 代码添加
    self.scrollview.ImagesArray = @[
        @"https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2534506313,1688529724&fm=26&gp=0.jpg",
        @"https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1593106255,4245861836&fm=26&gp=0.jpg",
        @"https://dss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg",
        @"https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=151472226,3497652000&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3135215632,750931275&fm=26&gp=0.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602758680828&di=4d3ac648ee3acea8acfcbfb3f1aafa27&imgtype=0&src=http%3A%2F%2Fupload.taihainet.com%2F2017%2F0207%2F1486426420230.png"
    ];
    __weak typeof(self) weakSelf = self;
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithArray:self.scrollview.ImagesArray];
    self.scrollview.isClickLastBtn = ^{
        //
        [array1 addObject:array1[arc4random()%(array1.count-1)]];
        weakSelf.scrollview.showPage = 5;
        weakSelf.scrollview.ImagesArray = array1;
    };
    self.scrollview.isAuto_play = YES;
    
    
    // xib 添加
    self.scrollview2.ImagesArray = @[
        @"https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2534506313,1688529724&fm=26&gp=0.jpg",
        @"https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1593106255,4245861836&fm=26&gp=0.jpg",
        @"https://dss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg",
        @"https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=151472226,3497652000&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3135215632,750931275&fm=26&gp=0.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602758680828&di=4d3ac648ee3acea8acfcbfb3f1aafa27&imgtype=0&src=http%3A%2F%2Fupload.taihainet.com%2F2017%2F0207%2F1486426420230.png"
    ];
    self.scrollview2.isShowLastButton = YES;
//    self.scrollview2.index = 4;
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithArray:self.scrollview2.ImagesArray];
    self.scrollview2.isClickLastBtn = ^{
        //
        [array2 addObject:array2[arc4random()%(array2.count-1)]];
        weakSelf.scrollview2.showPage = 10000;
        weakSelf.scrollview2.ImagesArray = array2;
    };
    self.scrollview2.parameters = ^(NSDictionary * _Nonnull dict) {
        //
        NSLog(@"点击了第 %@ 个", dict[@"index"]);
    };
}

- (QTCustomScrollview *)scrollview
{
    if (!_scrollview) {
        _scrollview=  [[QTCustomScrollview alloc] init];
//        _scrollview.backgroundColor = [UIColor greenColor];
//        _scrollview.isShowLastButton = YES;
        _scrollview.index = 1;
        
        _scrollview.parameters = ^(NSDictionary * _Nonnull dict) {
            //
            NSLog(@"点击了第 %@ 个", dict[@"index"]);
        };
    }
    return _scrollview;
}

- (void)nextPageController
{
    NextViewController *viewController =[[NextViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
