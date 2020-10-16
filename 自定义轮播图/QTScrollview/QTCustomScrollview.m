//
//  QTCustomScrollview.m
//  自定义轮播图
//
//  Created by 漫漫人生路 on 2020/10/15.
//  Copyright © 2020 漫漫人生路. All rights reserved.
//

#import "QTCustomScrollview.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "QTCountDown.h"

@interface QTCustomScrollview () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollview;
/// 是否是刷新（刚进来时为NO，更换图片时为YES）
@property (assign, nonatomic) BOOL isRefresh;
/// 是否显示最后一个按钮 （默认不显示）
@property (assign, nonatomic) BOOL isShowLastBut;
/// 是否自动播放  ( 默认不播放)
@property (assign, nonatomic) BOOL isAuto;
/// 是否显示最后一个按钮 （默认不显示）
@property (assign, nonatomic) NSInteger showImagePage;
/// view 数组
@property (strong, nonatomic)NSMutableArray *viewsArray;
/// 图片数组
@property (strong, nonatomic)NSMutableArray *photosArray;
/// 总共几页
@property (assign, nonatomic) NSInteger page;
/// 一页显示几个（默认八个）
@property (assign, nonatomic) NSInteger indexPage;
/// 一页显示几行（默认2行）如果 index = 1，则 lines 为1
@property (assign, nonatomic) NSInteger linesPage;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) QTCountDown *QT_timer; // 定时器

@end

@implementation QTCustomScrollview

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.indexPage = 8; // 默认一个 8 个
    self.linesPage = 2; // 默认为 2 行
    self.isAuto = NO;
    self.page = 1;
    
    [self addSubview:self.scrollview];
    [self addSubview:self.pageControl];
    
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(self);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.bottom.centerX.equalTo(self);
    }];
}

- (void)layoutSubviews
{
    self.isRefresh = YES;
    [self show];
}
- (void)show{
    if (self.isShowLastButton == YES) {
        self.isAuto = NO;
    }
    
    [self.QT_timer destoryTimer];
    
    if (self.indexPage < 1) {
        self.indexPage = 1;
    }
    if (self.indexPage == 1) {
        self.linesPage = 1;
    }
    
    self.page = self.photosArray.count / self.indexPage + 1; // 共几页
    if (self.isShowLastBut == YES) {
        self.page = self.photosArray.count / self.indexPage + 1;
    }else{
        self.page = (self.photosArray.count-1) / self.indexPage + 1;
    }
    
    if (self.page == 1) {
        self.isAuto = NO; // 只有一页时关闭自动播放
        self.pageControl.hidden = YES; // 只有一页时隐藏分页控件
    }else{
        self.pageControl.hidden = NO;
    }
    
    for (int i=0; i<self.viewsArray.count; i++) {
        UIView *view = [self.scrollview viewWithTag:10000+i];
        [view removeFromSuperview];
    }
    
    self.scrollview.contentSize = CGSizeMake((self.page+(self.isAuto==YES ? 2 : 0)) * self.frame.size.width, 0);
    self.scrollview.pagingEnabled = YES;
    self.scrollview.bounces = NO;
    
    [self addViewToScrollview];
    
    self.pageControl.numberOfPages = self.page;
    
    if (self.isShowLastBut == YES) {
        if (self.photosArray.count%self.indexPage == 0) {
            if (self.showImagePage > self.page) {
                self.showImagePage = self.page-1;
                [self.scrollview setContentOffset:CGPointMake(self.showImagePage * self.frame.size.width, 0) animated:NO];
            }
        }
    }
    
    __weak typeof(self) weakSelf = self;
    if (self.isAuto == YES) {
        [self.QT_timer countDownWithTime:3 Block:^{
            //
            [weakSelf.scrollview setContentOffset:CGPointMake(weakSelf.scrollview.contentOffset.x + weakSelf.scrollview.frame.size.width, 0) animated:YES];
        }];
    }
}

/// 添加 view 到 scrollview
- (void)addViewToScrollview
{
    CGFloat backview_W = self.frame.size.width;
    CGFloat backview_H = self.frame.size.height;
    CGFloat backview_X = 0;
    CGFloat backview_Y = 0;
    
    if (self.isAuto == YES) {
        UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(backview_X, backview_Y, backview_W, backview_H)];
        firstView.tag = 10001 + self.page;
        [self.viewsArray addObject:firstView];
        firstView.backgroundColor = self.backgroundColor;
        [self.scrollview addSubview:firstView];
        [self addImageViewsToView:firstView index:self.page-1];
        
        for (int i=0; i<self.page; i++) {
            backview_X = (i+1) * backview_W;
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(backview_X, backview_Y, backview_W, backview_H)];
            backview.tag = 10001 + i;
            [self.viewsArray addObject:backview];
            backview.backgroundColor = self.backgroundColor;
            [self.scrollview addSubview:backview];
            [self addImageViewsToView:backview index:i];
        }
        
        UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(backview_W * (self.page+1), backview_Y, backview_W, backview_H)];
        lastView.tag = 10000;
        [self.viewsArray addObject:lastView];
        lastView.backgroundColor = self.backgroundColor;
        [self.scrollview addSubview:lastView];
        [self addImageViewsToView:lastView index:0];
    }else{
        for (int i=0; i<self.page; i++) {
            backview_X = i * backview_W;
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(backview_X, backview_Y, backview_W, backview_H)];
            backview.tag = 10001 + i;
            [self.viewsArray addObject:backview];
            backview.backgroundColor = self.backgroundColor;
            [self.scrollview addSubview:backview];
            [self addImageViewsToView:backview index:i];
        }
    }
}

// 添加图片到 view 上面
- (void)addImageViewsToView:(UIView *)backview index:(NSInteger)i
{
    NSInteger num = (self.indexPage+1) / self.linesPage; // 一行几个
    if (self.indexPage == 1 && self.linesPage == 1) {
        num = 1;
    }
    CGFloat space = 10; //间隔
    CGFloat margin = 5; //边距
    CGFloat view_W = (self.frame.size.width - (num-1)*space - 2*margin) / num;
    CGFloat view_H = (self.frame.size.height - (self.linesPage-1)*space - 2*margin) / self.linesPage;
    CGFloat view_X = margin;
    CGFloat view_Y = margin;
    NSInteger pageNum = self.indexPage;
    if ((self.photosArray.count - i*self.indexPage) >= self.indexPage) {
        pageNum = self.indexPage;
    }else{
        pageNum = self.photosArray.count - i*self.indexPage + (self.isShowLastBut == YES? 1 : 0);
    }
    
    for (int j=0; j<pageNum; j++) {
        view_X = margin + j%num * (view_W + space);
        view_Y = margin + j/num * (view_H + space);
        NSInteger number = i*self.indexPage+j; // 第几个view
        if (number < self.photosArray.count) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(view_X, view_Y, view_W, view_H)];
            view.backgroundColor = [UIColor redColor];
            [backview addSubview:view];
            
            [self addImageView:view ImageURL:self.photosArray[number] Index:i*self.indexPage + j];
        }else{
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view_X, view_Y, view_W, view_H)];
            [backview addSubview:button];
            [button setTitle:@"自助投放" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)clickButton
{
    if (self.isClickLastBtn) {
        self.isAuto = NO;
        self.isClickLastBtn();
    }
}
/// 添加图片
- (void)addImageView:(UIView *)view ImageURL:(NSString *)imageUrl Index:(NSInteger)index
{
    /* - - - - - - - 可以自定义 - - - - - - - - - */
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    imageview.tag = index;
    imageview.backgroundColor = [UIColor grayColor];
    imageview.clipsToBounds = YES;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    [imageview sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    [view addSubview:imageview];

    imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
    [imageview addGestureRecognizer:Tap];
}
- (void)clickImageView:(UITapGestureRecognizer *)tap
{
    UIImageView *imageview = (UIImageView *)tap.view;
    
    // 添加需要的数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@((long)imageview.tag) forKey:@"index"]; // 点击了第几个
        
    if (self.parameters) {
        self.parameters(dict);
    }
}

#pragma mark - set
- (void)setIsAuto_play:(BOOL)isAuto_play
{
    _isAuto_play = isAuto_play;
    self.isAuto = isAuto_play;
    
    [self refreshView];
}
- (void)setShowPage:(NSInteger)showPage
{
    _showPage = showPage;
    self.showImagePage = showPage;
    
    [self refreshView];
}
- (void)setIsShowLastButton:(BOOL)isShowLastButton
{
    _isShowLastButton = isShowLastButton;
    self.isShowLastBut = isShowLastButton;
    
    [self refreshView];
}
- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.indexPage = index;
    
    [self refreshView];
}
- (void)setImagesArray:(NSArray *)ImagesArray
{
    _ImagesArray = ImagesArray;
    [self.photosArray removeAllObjects];
    [self.photosArray addObjectsFromArray:ImagesArray];
    
    [self refreshView];
}

#pragma mark - get
- (QTCountDown *)QT_timer
{
    if (!_QT_timer) {
        _QT_timer = [[QTCountDown alloc] init];
    }
    return _QT_timer;
}
- (NSMutableArray *)viewsArray
{
    if (!_viewsArray) {
        _viewsArray = [[NSMutableArray alloc] init];
    }
    return _viewsArray;
}
- (NSMutableArray *)photosArray
{
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}
- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.backgroundColor = self.backgroundColor;
        _scrollview.delegate = self;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
    }
    return _scrollview;;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:236 green:236 blue:236 alpha:1];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    }
    return _pageControl;
}

#pragma mark - scrollview delegete
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"偏移量：%f",scrollView.contentOffset.x);
//    NSLog(@"第%.f页",scrollView.contentOffset.x/self.frame.size.width + 1);
    NSInteger pageNUm = scrollView.contentOffset.x/self.frame.size.width;
    if (pageNUm == 0){
        pageNUm = 1;
    }
    if (self.isAuto == YES) {
        self.pageControl.currentPage = pageNUm-1;
        NSInteger page_x = self.scrollview.contentOffset.x;
        if (page_x == 0){
            [self.scrollview setContentOffset:CGPointMake((self.frame.size.width)*self.page, 0) animated:NO];
        }
        if (page_x == (self.frame.size.width) * (self.page+1)){
            [self.scrollview setContentOffset:CGPointMake((self.frame.size.width) * 1, 0) animated:NO];
        }
    }else{
        self.pageControl.currentPage = scrollView.contentOffset.x/self.frame.size.width;
    }
}
// 滑动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.QT_timer destoryTimer];
}
// 滑动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    __weak typeof(self) weakSelf = self;
    if (self.isAuto == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            [weakSelf.QT_timer countDownWithTime:3 Block:^{
                //
                [weakSelf.scrollview setContentOffset:CGPointMake(weakSelf.scrollview.contentOffset.x + weakSelf.scrollview.frame.size.width, 0) animated:YES];
            }];
        });
    }
}


- (void)refreshView
{
    if (self.isRefresh == YES) {
        [self show];
    }
}

- (void)dealloc
{
    [self.QT_timer destoryTimer];
}

@end
