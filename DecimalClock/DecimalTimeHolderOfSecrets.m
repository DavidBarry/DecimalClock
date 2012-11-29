//
//  SuperTimeHolderOfSecrets.m
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

#import "DecimalTimeHolderOfSecrets.h"
#import "DecimalTimeComponents.h"

const static int secondsInAnHour = 10000;
const static int secondsInAMinute = 100;
const static int millisInADecimalSecond = 864;

@interface DecimalTimeHolderOfSecrets ()
@property (nonatomic, strong) NSCalendar *calendar;

- (DecimalTimeComponents *)timeComponentsForMillis:(NSUInteger)millis;
- (NSUInteger)millisSinceStartOfDay;
@end

@implementation DecimalTimeHolderOfSecrets

- (DecimalTimeComponents *)timeComponentsForMillis:(NSUInteger)millis {
   int seconds = millis / millisInADecimalSecond;
   
   int hours = seconds / secondsInAnHour;
   int leftOverSeconds = seconds % secondsInAnHour;
   int minutes = leftOverSeconds / secondsInAMinute;
   leftOverSeconds = leftOverSeconds % secondsInAMinute;
   
   return [DecimalTimeComponents componentsWithHours:hours minutes:minutes seconds:leftOverSeconds];
}

- (DecimalTimeComponents *)timeComponentsForNow {
   return [self timeComponentsForMillis:[self millisSinceStartOfDay]];
}

- (NSUInteger)millisInADecimalSecond {
   return millisInADecimalSecond;
}

- (NSUInteger)millisSinceStartOfDay {
   NSDate *now = [NSDate date];
   NSDateComponents *blankTodayComponents = [[NSDateComponents alloc] init];
   blankTodayComponents = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
   
   NSDate *startOfTodayDate = [self.calendar dateFromComponents:blankTodayComponents];
   
   NSTimeInterval imperialSecondsToday = [now timeIntervalSinceDate:startOfTodayDate];
   
   return imperialSecondsToday * 1000;
}

- (NSCalendar *)calendar {
   if (!_calendar) {
      _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
   }
   return _calendar;
}
@end
