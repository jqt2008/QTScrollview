# QTScrollview

/// 一页显示几个（默认8个）
@property (assign, nonatomic) NSInteger index;

/// 显示第几页（默认显示第一页）当足够大时，直接显示最后一页
@property (assign, nonatomic) NSInteger showPage;

/// 是否显示最后一个按钮 （默认不显示） （当显示最后一个按钮是自动播放不起作用）
/// 注意 如果为 YES 则自动播放不起作用
@property (assign, nonatomic) BOOL isShowLastButton;

/// 是否自动播放  ( 默认不播放)
@property (assign, nonatomic) BOOL isAuto_play;


/// 图片数组
@property (strong, nonatomic)NSArray *ImagesArray;
/// 点击返回的数据（字典 自己添加数据）
@property (copy,nonatomic)clickDict parameters;
/// 点击最后一个显示的按钮
@property (copy,nonatomic)clickButton isClickLastBtn;
