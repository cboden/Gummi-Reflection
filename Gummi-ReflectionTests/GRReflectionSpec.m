//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GRReflection.h"
#import "SomeObject.h"
#import "SomeOtherObject.h"
#import "SomeProtocol.h"

SPEC_BEGIN(GRReflectionSpec)

        void (^isClass)(id) = ^(id object) {
            [[theValue([GRReflection isClass:object]) should] beYes];
            [[theValue([GRReflection isProtocol:object]) should] beNo];
            [[theValue([GRReflection isInstance:object]) should] beNo];
        };

        void (^isProtocol)(id) = ^(id object) {
            [[theValue([GRReflection isClass:object]) should] beNo];
            [[theValue([GRReflection isProtocol:object]) should] beYes];
            [[theValue([GRReflection isInstance:object]) should] beNo];
        };

        void (^isInstance)(id) = ^(id object) {
            [[theValue([GRReflection isClass:object]) should] beNo];
            [[theValue([GRReflection isProtocol:object]) should] beNo];
            [[theValue([GRReflection isInstance:object]) should] beYes];
        };

        void (^isNothing)(id) = ^(id object) {
            [[theValue([GRReflection isClass:object]) should] beNo];
            [[theValue([GRReflection isProtocol:object]) should] beNo];
            [[theValue([GRReflection isInstance:object]) should] beNo];
        };

        describe(@"Reflection", ^{

            it(@"gets the type of a property class", ^{
                id class = [GRReflection getTypeForProperty:@"otherObject" ofClass:[SomeObject class]];
                [[class should] equal:[SomeOtherObject class]];
            });

            it(@"gets the type of a property protocol", ^{
                id protocol = [GRReflection getTypeForProperty:@"someProtocol" ofClass:[SomeObject class]];
                [[protocol should] equal:@protocol(SomeProtocol)];
            });

            it(@"raises exeption for unknown property names", ^{
                [[theBlock(^{
                    [GRReflection getTypeForProperty:@"iDoNotExist" ofClass:[SomeObject class]];
                }) should] raiseWithName:@"GIReflectorException"];
            });

            it(@"is a class", ^{
                id object = [SomeObject class];
                isClass(object);
            });

            it(@"is a protocol", ^{
                id object = @protocol(SomeProtocol);
                isProtocol(object);
            });

            it(@"is an instance", ^{
                id object = [[SomeObject alloc] init];
                isInstance(object);
            });

            it(@"nil is handled correctly", ^{
                isNothing(nil);
            });

        });

        SPEC_END