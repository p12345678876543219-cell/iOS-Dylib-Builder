#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FloatingMenuController : NSObject
+ (instancetype)sharedInstance;
- (void)showMenu;
@end

@interface FloatingMenuWindow : UIWindow
@end

@implementation FloatingMenuWindow
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // Cho phép chạm xuyên qua cửa sổ nền, chỉ nhận chạm vào các View con
    return [super pointInside:point withEvent:event];
}
@end

@interface MenuViewController : UIViewController
@property (nonatomic, strong) UILabel *clockLabel;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) NSTimer *clockTimer;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    // 1. Tạo nút nổi có hình ảnh (Draggable Floating Button)
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(50, 100, 60, 60);
    self.floatingButton.layer.cornerRadius = 30;
    self.floatingButton.clipsToBounds = YES;
    self.floatingButton.layer.borderWidth = 2.0f;
    self.floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // Đặt hình ảnh cho nút (Bạn có thể thay thế bằng URL hoặc UIImage từ bundle)
    // Ví dụ sử dụng icon hệ thống hoặc màu sắc tạm thời
    [self.floatingButton setBackgroundColor:[UIColor systemIndigoColor]];
    [self.floatingButton setTitle:@"MENU" forState:UIControlStateNormal];
    [self.floatingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    // Thêm sự kiện kéo thả (Pan Gesture)
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:actionHandlePan:];
    [self.floatingButton addGestureRecognizer:panGesture];
    
    // Thêm sự kiện bấm để bật/tắt menu
    [self.floatingButton addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.floatingButton];
    
    // 2. Tạo khung Menu chính
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 250, 200)];
    self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaCoordinate:0.85];
    self.menuView.layer.cornerRadius = 16;
    self.menuView.layer.borderWidth = 1.5f;
    self.menuView.layer.borderColor = [UIColor systemCyanColor].CGColor;
    self.menuView.hidden = YES; // Mặc định ẩn
    
    // Tiêu đề Menu
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 220, 25)];
    titleLabel.text = @"MOD MENU VIP";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:titleLabel];
    
    // Đồng hồ hiển thị thời gian thật
    self.clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 220, 30)];
    self.clockLabel.textColor = [UIColor greenColor];
    self.clockLabel.font = [UIFont monospacedDigitSystemFontOfSize:18 weight:UIFontWeightBold];
    self.clockLabel.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:self.clockLabel];
    
    // Nút tắt/mở tính năng mẫu trong menu
    UISwitch *featureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(180, 100, 0, 0)];
    [featureSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 150, 30)];
    switchLabel.text = @"Tính năng ẩn";
    switchLabel.textColor = [UIColor whiteColor];
    switchLabel.font = [UIFont systemFontOfSize:14];
    
    [self.menuView addSubview:featureSwitch];
    [self.menuView addSubview:switchLabel];
    
    [self.view addSubview:self.menuView];
    
    // 3. Khởi động Timer cập nhật đồng hồ theo thời gian thật
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
    [self updateClock];
}

// Xử lý kéo thả nút nổi trên màn hình
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint center = gesture.view.center;
    gesture.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
}

// Bật/tắt hiển thị Menu
- (void)toggleMenu:(id)sender {
    self.menuView.hidden = !self.menuView.hidden;
}

// Cập nhật thời gian thật cho đồng hồ
- (void)updateClock {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    self.clockLabel.text = [formatter stringFromDate:[NSDate date]];
}

- (void)switchChanged:(UISwitch *)sender {
    if (sender.isOn) {
        // Code kích hoạt hack/tính năng tại đây
    } else {
        // Code tắt tính năng tại đây
    }
}

@end

@interface FloatingMenuController ()
@property (nonatomic, strong) FloatingMenuWindow *window;
@end

@implementation FloatingMenuController

+ (instancetype)sharedInstance {
    static FloatingMenuController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FloatingMenuController alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self performSelectorOnMainThread:@selector(setupWindow) withObject:nil waitUntilDone:NO];
    }
    return self;
}

- (void)setupWindow {
    UIWindowScene *scene = nil;
    for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
        if (s.activationState == UISactivationStateForegroundActive) {
            scene = s;
            break;
        }
    }
    
    if (scene) {
        self.window = [[FloatingMenuWindow alloc] initWithWindowScene:scene];
    } else {
        self.window = [[FloatingMenuWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelAlert + 100;
    self.window.rootViewController = [[MenuViewController alloc] init];
    [self.window makeKeyAndVisible];
}

- (void)showMenu {
    // Đã tự khởi tạo qua constructor
}

@end

// Hàm khởi chạy tự động khi dylib được tiêm vào ứng dụng (Constructor)
__attribute__((constructor)) void entry() {
    [FloatingMenuController sharedInstance];
}
