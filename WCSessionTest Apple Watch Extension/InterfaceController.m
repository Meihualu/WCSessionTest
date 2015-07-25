//
//  InterfaceController.m
//  WCSessionTest Apple Watch Extension
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

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self updateLabelContextValue];
    [self updateLabelReceivedAttribute];
    [self updateLabelSendAttribute];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidReceiveApplicationContext:) name:@"DID_RECEIVE_APPLICATION_CONTEXT" object:nil];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)onButtonModify {
    if (![WCSession isSupported]) {
        return;
    }
    
    [self presentTextInputControllerWithSuggestions:@[@"one", @"two", @"three"] allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
        if ([results count] == 1 && [[results objectAtIndex:0] isKindOfClass:[NSString class]]) {
            NSString *input = [results objectAtIndex:0];
            [[WCSession defaultSession] updateApplicationContext:@{@"message": input} error:nil];
            _labelContextValue.text = input;
            [self updateLabelReceivedAttribute];
            [self updateLabelSendAttribute];
        }
    }];
}

- (IBAction)onButtonUpdateValues {
    [self updateLabelReceivedAttribute];
    [self updateLabelSendAttribute];
}

#pragma mark -

- (void)updateLabelContextValue {
    if ([WCSession isSupported]) {
        NSDictionary *receivedApplicationContext = [[WCSession defaultSession] receivedApplicationContext];
        if ([receivedApplicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [receivedApplicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _labelContextValue.text = contextValue;
            }
        }
    }
}

- (void)updateLabelReceivedAttribute {
    if ([WCSession isSupported]) {
        NSDictionary *receivedApplicationContext = [[WCSession defaultSession] receivedApplicationContext];
        if ([receivedApplicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [receivedApplicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _labelReceivedAttribute.text = [NSString stringWithFormat:@"R: %@", contextValue];
            }
        }
    }
}

- (void)updateLabelSendAttribute {
    if ([WCSession isSupported]) {
        NSDictionary *applicationContext = [[WCSession defaultSession] applicationContext];
        if ([applicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [applicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _labelSentAttribute.text = [NSString stringWithFormat:@"S: %@", contextValue];
            }
        }
    }
}

#pragma mark -

- (void)onDidReceiveApplicationContext:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *applicationContext = notification.userInfo;
        if ([applicationContext isKindOfClass:[NSDictionary class]]) {
            NSString *contextValue = [applicationContext objectForKey:@"message"];
            if ([contextValue isKindOfClass:[NSString class]]) {
                _labelContextValue.text = contextValue;
            }
        }
        
        [self updateLabelReceivedAttribute];
        [self updateLabelSendAttribute];
    });
}

@end



