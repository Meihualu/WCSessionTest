//
//  ViewController.m
//  WCSessionTest
//
//  Copyright (c) 2015 Arnfried Griesert
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateTextFieldContextValue];
    [self updateTextFieldReceivedAttribute];
    [self updateTextFieldSentAttribute];
    [self updateIndicatorColors];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidReceiveApplicationContext:) name:@"DID_RECEIVE_APPLICATION_CONTEXT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSessionWatchStateDidChange:) name:@"SESSION_WATCH_STATE_DID_CHANGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSessionReachabilityDidChange:) name:@"SESSION_REACHABILITY_DID_CHANGE" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField {
    [textField resignFirstResponder];
    if ([WCSession isSupported]) {
        [[WCSession defaultSession] updateApplicationContext:@{@"message": textField.text} error:nil];
        [self updateTextFieldReceivedAttribute];
        [self updateTextFieldSentAttribute];
    }
    return YES;
}

#pragma mark -

- (void)updateTextFieldContextValue {
    if ([WCSession isSupported]) {
        NSDictionary *receivedApplicationContext = [[WCSession defaultSession] receivedApplicationContext];
        if ([receivedApplicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [receivedApplicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _textFieldContextValue.text = contextValue;
            }
        }
    }
}

- (void)updateTextFieldReceivedAttribute {
    if ([WCSession isSupported]) {
        NSDictionary *receivedApplicationContext = [[WCSession defaultSession] receivedApplicationContext];
        if ([receivedApplicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [receivedApplicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _textFieldReceivedAttribute.text = contextValue;
            }
        }
    }
}

- (void)updateTextFieldSentAttribute {
    if ([WCSession isSupported]) {
        NSDictionary *applicationContext = [[WCSession defaultSession] applicationContext];
        if ([applicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [applicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _textFieldSentAttribute.text = contextValue;
            }
        }
    }
}

- (void)updateIndicatorColors {
    if ([WCSession isSupported]) {
        _labelPaired.backgroundColor = [[WCSession defaultSession] isPaired] ? [UIColor greenColor] : [UIColor redColor];
        _labelInstalled.backgroundColor = [[WCSession defaultSession] isWatchAppInstalled] ? [UIColor greenColor] : [UIColor redColor];
        _labelComplication.backgroundColor = [[WCSession defaultSession] isComplicationEnabled] ? [UIColor greenColor] : [UIColor redColor];
    }
}

#pragma mark -

- (IBAction)onButtonUpdateValues:(id)Sender {
    [self updateTextFieldReceivedAttribute];
    [self updateTextFieldSentAttribute];
    [self updateIndicatorColors];
}

- (void)onDidReceiveApplicationContext:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *applicationContext = notification.userInfo;
        if ([applicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [applicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _textFieldContextValue.text = contextValue;
            }
        }
        
        [self updateTextFieldReceivedAttribute];
        [self updateTextFieldSentAttribute];
    });
}

- (void)onSessionWatchStateDidChange:(NSNotification *)notification {
    [self updateIndicatorColors];
}

- (void)onSessionReachabilityDidChange:(NSNotification *)notification {
    [self updateIndicatorColors];
}

@end
