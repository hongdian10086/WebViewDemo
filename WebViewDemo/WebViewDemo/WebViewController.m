//
//  WebViewController.m
//  WebViewDemo
//
//  Created by laikidi on 2018/7/13.
//  Copyright © 2018年 Algor. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property WebViewJavascriptBridge* bridge;


@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_bridge) { return; }
    
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    

    [_bridge registerHandler:@"getUserInfos" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Javascript传递数据: %@", data);
        NSDictionary *dic = data;
        responseCallback([NSString stringWithFormat:@"IOS：我知道，是%@",dic[@"foo"]]);
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshNotification" object:dic[@"foo"]];
    }];
    
    
    
    //    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    [_bridge callHandler:@"testJavascriptHandler" data:@"你好啊，js" responseCallback:^(id response) {
        NSLog(@"接收到js返回数据 %@", response);
    }];
    [_bridge callHandler:@"testObjcCallback" data:@{ @"foo":@"testObjcCallback" } responseCallback:^(id response) {
        NSLog(@"testObjcCallback responded: %@", response);
    }];
    
    
    [self loadExamplePage:webView];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage:(WKWebView*)webView {
        NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"iosWebView" ofType:@"html"];
        NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        [webView loadHTMLString:appHtml baseURL:baseURL];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.176:8888/iosWebView.html"]]];
    
    
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
