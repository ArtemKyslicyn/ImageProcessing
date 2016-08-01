//
//  UIViewController+Messages.m
//  ProcessImageApp
//
//  Created by Arcilite on 01.08.16.
//  Copyright © 2016 Arcilite. All rights reserved.
//

#import "UIViewController+Messages.h"

@implementation UIViewController (Messages)


-(void)errorMessageWithTitle:(NSString*)title message :(NSString*)message{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                        otherButtonTitles: nil];
  [alert show];
}
@end
