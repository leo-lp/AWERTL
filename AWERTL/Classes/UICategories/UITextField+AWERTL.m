//
//  UITextField+AWERTL.m
//  AWERTL
//
//  Created by ByteDance on 2018/12/6.
//

#import "UITextField+AWERTL.h"
#import "NSObject+AWERTLReloadBlock.h"
#import "AWERTLDefinitions.h"
#import "AWERTLManager.h"

@implementation UITextField (AWERTL)

+ (void)load
{
    ALPSwizzle(self, setTextAlignment:, awertl_setTextAlignment:);
    ALPSwizzle(self, initWithFrame:, awertl_initWithFrame:);
    ALPSwizzle(self, initWithCoder:, awertl_initWithCoder:);
}

- (instancetype)awertl_initWithFrame:(CGRect)frame
{
    [self awertl_initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (instancetype)awertl_initWithCoder:(NSCoder *)aDecoder
{
    [self awertl_initWithCoder:aDecoder];
    if (self) {
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)awertl_setTextAlignment:(NSTextAlignment)textAlignment
{
    @weakify(self);
    [self awertl_addReloadBlockForKey:@"alignment" andExecuteIt:^{
        @strongify(self);
        if ([AWERTLManager sharedInstance].enableRTL) {
            if (textAlignment == NSTextAlignmentCenter) {
                [self awertl_setTextAlignment:textAlignment];
            } else if (textAlignment == NSTextAlignmentRight) {
                [self awertl_setTextAlignment:NSTextAlignmentLeft];
            } else {
                [self awertl_setTextAlignment:NSTextAlignmentRight];
            }
        } else {
            [self awertl_setTextAlignment:textAlignment];
        }
    }];
}

@end
