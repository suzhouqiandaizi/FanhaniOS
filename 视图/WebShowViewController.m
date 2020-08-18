//
//  AboutOurViewController.m
//  ReceiveTask
//
//  Created by WangZhenyu on 2018/11/21.
//  Copyright © 2018 WangZhenyu. All rights reserved.
//

#import "WebShowViewController.h"
#import <WebKit/WebKit.h>
#import "NJKWebViewProgressView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "UIAlertView+Blocks.h"

#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height

@interface WebShowViewController ()<WKUIDelegate, WKNavigationDelegate>{
    NJKWebViewProgressView *_progressView;
    BOOL  _flagged;
}
//@property (weak, nonatomic) CALayer *progresslayer;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic)UIBarButtonItem* backButtonItem;
@property (nonatomic)UIBarButtonItem* customBackBarItem;
@property (nonatomic)UIBarButtonItem* closeButtonItem;

/**
 *  array that hold snapshots
 */
@property (nonatomic)NSMutableArray* snapShotsArray;

/**
 *  current snapshotview displaying on screen when start swiping
 */
@property (nonatomic)UIView* currentSnapShotView;

/**
 *  previous view
 */
@property (nonatomic)UIView* prevSnapShotView;

/**
 *  background alpha black view
 */
@property (nonatomic)UIView* swipingBackgoundView;

/**
 *  left pan ges
 */
@property (nonatomic)UIPanGestureRecognizer* swipePanGesture;

/**
 *  if is swiping now
 */
@property (nonatomic)BOOL isSwipingBack;

@end

@implementation WebShowViewController

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if ( self.presentedViewController)
    {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        if (@available(iOS 9.0, *)) {
            config.requiresUserActionForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        //设置是否允许画中画技术 在特定设备上有效
        if (@available(iOS 9.0, *)) {
            config.allowsPictureInPictureMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        if (@available(iOS 9.0, *)) {
            config.applicationNameForUserAgent = @"SJX";
        } else {
            // Fallback on earlier versions
        }
        
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64 + IS_iPhoneX_Top, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE - 64 - IS_iPhoneX_Top)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView sizeToFit];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
//    self.urlStr = @"http://www.baidu.com";
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    [self.view addSubview:self.webView];

    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progressColor = ThemeColor;

    [self updateNavigationItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)dealloc {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存溢出");
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        if (object == self.webView){
            NSLog(@"=========%f", self.webView.estimatedProgress);
            [_progressView setProgress:self.webView.estimatedProgress animated:YES];
        }else if([keyPath isEqualToString:@"title"] && object == _webView){
            self.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}


//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    self.title = webView.title;
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    self.title = webView.title;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    [_progressView setProgress:0 animated:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
    
}


// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSString * urlStr = navigationResponse.response.URL.absoluteString;
//    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
//
////需要响应身份验证时调用 同样在block中需要传入用户身份凭证
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//    
//    //用户身份信息
//    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
//    //为 challenge 的发送方提供 credential
//    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
//    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
//    
//}
//
////进程被终止时调用
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
//    
//}

#pragma mark - WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


#pragma mark - logic of push and pop snap shot views
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    
    UIView* currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{
       @"request":request,
       @"snapShotView":currentSnapShotView
       }
     ];
    //    NSLog(@"now array count %d",self.snapShotsArray.count);
}

-(void)startPopSnapshotView{
    if (self.isSwipingBack) {
        return;
    }
    if (!self.webView.canGoBack) {
        return;
    }
    self.isSwipingBack = YES;
    //create a center of scrren
    CGPoint center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    self.currentSnapShotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    
    //add shadows just like UINavigationController
    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    self.currentSnapShotView.layer.shadowRadius = 5;
    self.currentSnapShotView.layer.shadowOpacity = 0.75;
    
    //move to center of screen
    self.currentSnapShotView.center = center;
    
    self.prevSnapShotView = (UIView*)[[self.snapShotsArray lastObject] objectForKey:@"snapShotView"];
    center.x -= 60;
    self.prevSnapShotView.center = center;
    self.prevSnapShotView.alpha = 1;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.prevSnapShotView];
    [self.view addSubview:self.swipingBackgoundView];
    [self.view addSubview:self.currentSnapShotView];
}

-(void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance{
    if (!self.isSwipingBack) {
        return;
    }
    
    if (distance <= 0) {
        return;
    }
    
    CGPoint currentSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    currentSnapshotViewCenter.x += distance;
    CGPoint prevSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    prevSnapshotViewCenter.x -= (boundsWidth - distance)*60/boundsWidth;
    //    NSLog(@"prev center x%f",prevSnapshotViewCenter.x);
    
    self.currentSnapShotView.center = currentSnapshotViewCenter;
    self.prevSnapShotView.center = prevSnapshotViewCenter;
    self.swipingBackgoundView.alpha = (boundsWidth - distance)/boundsWidth;
}

-(void)endPopSnapShotView{
    if (!self.isSwipingBack) {
        return;
    }
    
    //prevent the user touch for now
    self.view.userInteractionEnabled = NO;
    
    if (self.currentSnapShotView.center.x >= boundsWidth) {
        // pop success
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.swipingBackgoundView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            [self.webView goBack];
            [self.snapShotsArray removeLastObject];
            self.view.userInteractionEnabled = YES;
            
            self.isSwipingBack = NO;
        }];
    }else{
        //pop fail
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2-60, boundsHeight/2);
            self.prevSnapShotView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            
            self.isSwipingBack = NO;
        }];
    }
}

#pragma mark - update nav items

-(void)updateNavigationItems{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    if (self.webView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        //弃用customBackBarItem，使用原生backButtonItem
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer,self.customBackBarItem,self.closeButtonItem] animated:NO];
    }else{
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.backButtonItem, nil];
    }
}

#pragma mark - events handler
-(void)swipePanGestureHandler:(UIPanGestureRecognizer*)panGesture{
    CGPoint translation = [panGesture translationInView:self.webView];
    CGPoint location = [panGesture locationInView:self.webView];
    //    NSLog(@"pan x %f,pan y %f",translation.x,translation.y);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 50 && translation.x > 0) {  //开始动画
            [self startPopSnapshotView];
        }
    }else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateEnded){
        [self endPopSnapShotView];
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self popSnapShotViewWithPanGestureDistance:translation.x];
    }
}

-(void)customBackItemClicked{
    [self.webView goBack];
    [self performSelector:@selector(updateNavigationItems) withObject:self afterDelay:0.1];
}

-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIBarButtonItem*)backButtonItem{
    if (!_backButtonItem) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.whiteBackBtn) {
            btn.frame=CGRectMake(0, 0, 44, 44);
            [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
            if (IOS11_OR_LATER) {
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH_DEVICE /375.0,0,0)];
            }
            [btn addTarget:self action:@selector(closeItemClicked) forControlEvents:UIControlEventTouchUpInside];
            _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }else{
            btn.frame=CGRectMake(0, 0, 44, 44);
            [btn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
            if (IOS11_OR_LATER) {
                btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -12 *SCREEN_WIDTH_DEVICE /375.0,0,0)];
            }
            [btn addTarget:self action:@selector(closeItemClicked) forControlEvents:UIControlEventTouchUpInside];
            _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
        
    }
    return _backButtonItem;
}


-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIButton *backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        if (self.whiteBackBtn) {
            [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        }else{
            [backButton setTitleColor:TextColor forState:UIControlStateNormal];
            [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        }
        
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [backButton sizeToFit];
        backButton.frame=CGRectMake(0, 0, 44, 44);
        if (IOS11_OR_LATER) {
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0,backButton.titleLabel.bounds.size.width - 14, 0,-backButton.titleLabel.bounds.size.width);
        }else{
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0,backButton.titleLabel.bounds.size.width, 0,-backButton.titleLabel.bounds.size.width);
        }
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
//        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, 40, 40);
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        if (self.whiteBackBtn) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
        }
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(closeItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _closeButtonItem;
}

-(UIView*)swipingBackgoundView{
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _swipingBackgoundView;
}

-(NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(BOOL)isSwipingBack{
    if (!_isSwipingBack) {
        _isSwipingBack = NO;
    }
    return _isSwipingBack;
}

-(UIPanGestureRecognizer*)swipePanGesture{
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandler:)];
    }
    return _swipePanGesture;
}
@end
