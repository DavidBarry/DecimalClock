//
//  DecimalClockViewController.m
//  DecimalClock
//
//  Created by David Barry on 1/6/12.
//  Copyright (c) 2012 David Barry. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "DecimalClockViewController.h"
#import "DecimalTimeHolderOfSecrets.h"
#import "DecimalTimeComponents.h"

@interface DecimalClockViewController () 
@property (nonatomic, strong) DecimalTimeHolderOfSecrets *theOneTruth;
@property (nonatomic, strong) NSTimer *pingTimer;

- (void)setNumber:(int)number forLabel:(UILabel *)label;
- (CGPoint)offScreenCenterForLabel:(UILabel *)label;
- (void)setLabelsWithoutAnimation;
- (void)updateReferenceForLabel:(UILabel *)currentLabel toLabel:(UILabel *)newLabel;
@end

@implementation DecimalClockViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
   [super viewDidLoad];
   self.hourLabel.font = [UIFont fontWithName:@"Inconsolata" size:400.0];
   self.minuteTensLabel.font = [UIFont fontWithName:@"Inconsolata" size:200.0];
   self.minuteOnesLabel.font = [UIFont fontWithName:@"Inconsolata" size:200.0];
   self.secondTensLabel.font = [UIFont fontWithName:@"inconsolata" size:72.0];
   self.secondOnesLabel.font = [UIFont fontWithName:@"inconsolata" size:72.0];
   
   [self setLabelsWithoutAnimation];
    
   self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:([self.theOneTruth millisInADecimalSecond] / 1000.0) target:self selector:@selector(ping) userInfo:nil repeats:YES];
}

- (DecimalTimeHolderOfSecrets *)theOneTruth {
   if (!_theOneTruth) {
      _theOneTruth = [[DecimalTimeHolderOfSecrets alloc] init];
   }
   return _theOneTruth;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - The Action
- (void)setNumber:(int)number forLabel:(UILabel *)label {
   NSString *numberString = [NSString stringWithFormat:@"%d", number];
   UILabel *newLabel = [[UILabel alloc] initWithFrame:label.frame];
   newLabel.font = label.font;
   newLabel.text = numberString;
   newLabel.backgroundColor = [UIColor clearColor];
   
   if ([label.text isEqualToString:numberString]) 
      return;
   
   CGPoint newCenter = [self offScreenCenterForLabel:label];
   [self.view addSubview:newLabel];
   [self updateReferenceForLabel:label toLabel:newLabel];
   
   newLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
   newLabel.alpha = 0.0;
   
   [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationCurveEaseOut animations:^{
      newLabel.alpha = 1.0;
      newLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
   } completion:nil];
   
   [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
      label.center = newCenter;
   } completion:^(BOOL finished) {
      [label removeFromSuperview];
   }];
   
}

- (CGPoint)offScreenCenterForLabel:(UILabel *)label {
   CGPoint returnPoint = label.center;
   
   //Hour goes up, minute tens left, and minute ones down
   if (label == self.hourLabel)
      returnPoint.y = 0 - (label.frame.size.height / 2);
   else if (label == self.minuteTensLabel)
      returnPoint.x = 0 - (label.frame.size.width / 2);
   else if (label == self.minuteOnesLabel || label == self.secondTensLabel) 
      returnPoint.y = self.view.frame.size.height + (label.frame.size.height / 2);
   else if (label == self.secondOnesLabel)
      returnPoint.x = self.view.frame.size.width + (label.frame.size.width / 2);
   
   return returnPoint;
}

- (void)updateReferenceForLabel:(UILabel *)currentLabel toLabel:(UILabel *)newLabel {
   if (currentLabel == self.hourLabel)
      self.hourLabel = newLabel;
   else if (currentLabel == self.minuteTensLabel)
      self.minuteTensLabel = newLabel;
   else if (currentLabel == self.minuteOnesLabel)
      self.minuteOnesLabel = newLabel;
   else if (currentLabel == self.secondTensLabel)
      self.secondTensLabel = newLabel;
   else if (currentLabel == self.secondOnesLabel)
      self.secondOnesLabel = newLabel;
}

- (void)ping {
   DecimalTimeComponents *decimalTime = [self.theOneTruth timeComponentsForNow];
   [self setNumber:decimalTime.hours forLabel:self.hourLabel];
   [self setNumber:decimalTime.minutes / 10 forLabel:self.minuteTensLabel];
   [self setNumber:decimalTime.minutes % 10 forLabel:self.minuteOnesLabel];
   [self setNumber:decimalTime.seconds / 10 forLabel:self.secondTensLabel];
   [self setNumber:decimalTime.seconds % 10 forLabel:self.secondOnesLabel];
}

- (void)setLabelsWithoutAnimation {
   DecimalTimeComponents *decimalTime = [self.theOneTruth timeComponentsForNow];
   self.hourLabel.text = [NSString stringWithFormat:@"%d", decimalTime.hours];
   self.minuteTensLabel.text = [NSString stringWithFormat:@"%d", decimalTime.minutes / 10];
   self.minuteOnesLabel.text = [NSString stringWithFormat:@"%d", decimalTime.minutes % 10];
   self.secondTensLabel.text = [NSString stringWithFormat:@"%d", decimalTime.seconds / 10];
   self.secondOnesLabel.text = [NSString stringWithFormat:@"%d", decimalTime.seconds % 10];
}
@end
