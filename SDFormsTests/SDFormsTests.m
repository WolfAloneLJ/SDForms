//
//  SDFormsTests.m
//  SDFormsTests
//
//  Created by Rafal Kwiatkowski on 25.03.2015.
//  Copyright (c) 2015 Snowdog sp. z o.o. All rights reserved.
//

#import <Kiwi.h>
#import "TestClass.h"
#import "SDForms.h"

SPEC_BEGIN(SDFormsSpec)

describe(@"SDPickerField", ^{
    
    context(@"when updating value with related object", ^{
        __block SDPickerField *pickerField;
        __block TestClass *testObject;
        
        beforeEach(^{
            testObject = [[TestClass alloc] init];
            testObject.value = @2;
            testObject.formattedValue = @"Item1";
            
            NSArray *items = @[@[@"Item1", @"Item2", @"Item3"]];
            NSArray *values = @[@[@1, @2, @3]];
            
            pickerField = [[SDPickerField alloc] initWithObjects:@[testObject]
                                             relatedPropertyKeys:@[@"value"]
                                              formattedValueKeys:@[@"formattedValue"]
                                      settableFormattedValueKeys:@[@"settabeFormattedValue"]
                                                           items:items
                                                          values:values];
        });
        
        it(@"sets object values as own values", ^{
            [[pickerField.value.firstObject should] equal:@2];
            [[pickerField.formattedValue.firstObject should] equal:@"Item2"];
            [[testObject.value should] equal:@2];
            [[testObject.settabeFormattedValue should] equal:@"Item2"];
            
        });
        
        it(@"sets object values based on own value", ^{
            pickerField.value = @[@3];
            [[pickerField.value.firstObject should] equal:@3];
            [[pickerField.formattedValue.firstObject should] equal:@"Item3"];
            [[testObject.value should] equal:@3];
            [[testObject.settabeFormattedValue should] equal:@"Item3"];
        });
        
        it(@"sets value out of range", ^{
            pickerField.value = @[@4];
            [[pickerField.value.firstObject should] equal:@1];
            [[pickerField.formattedValue.firstObject should] equal:@"Item1"];
            [[testObject.value should] equal:@1];
            [[testObject.settabeFormattedValue should] equal:@"Item1"];
        });
        
        it(@"sets NSNull value", ^{
            pickerField.value = @[[NSNull null]];
            [[pickerField.value.firstObject should] equal:@1];
            [[pickerField.formattedValue.firstObject should] equal:@"Item1"];
            [[testObject.value should] equal:@1];
            [[testObject.settabeFormattedValue should] equal:@"Item1"];
        });
        
        it(@"sets object values below minimum index", ^{
            
            pickerField.minimumSelectedIndexes = @[@1];
            pickerField.value = @[@1];
            [[pickerField.value.firstObject should] equal:@2];
            [[pickerField.formattedValue.firstObject should] equal:@"Item2"];
            [[testObject.value should] equal:@2];
            [[testObject.settabeFormattedValue should] equal:@"Item2"];
            
        });
        
        afterEach(^{
            testObject = nil;
            pickerField = nil;
        });
    });
    
    context(@"when updating value without related object", ^{
        __block SDPickerField *pickerField;
        
        beforeEach(^{
            
            NSArray *items = @[@[@"Item1", @"Item2", @"Item3"]];
            NSArray *values = @[@[@1, @2, @3]];
            
            pickerField = [[SDPickerField alloc] initWithObjects:nil relatedPropertyKeys:nil items:items values:values];
        });
        
        it(@"first object selected by default", ^{
            [[pickerField.value.firstObject should] equal:@1];
            [[pickerField.formattedValue.firstObject should] equal:@"Item1"];
        });
        
        it(@"setting value", ^{
            pickerField.value = @[@2];
            [[pickerField.value.firstObject should] equal:@2];
            [[pickerField.formattedValue.firstObject should] equal:@"Item2"];
        });
        
        afterEach(^{
            pickerField = nil;
        });
    });
    
    context(@"when setting related object", ^{
        __block SDPickerField *pickerField;
        __block TestClass *testObject;
        __block NSArray *items;
        __block NSArray *values;
        
        beforeEach(^{
            testObject = [[TestClass alloc] init];
            
            items = @[@[@"Item1", @"Item2", @"Item3"]];
            values = @[@[@1, @2, @3]];
        });
        
        it(@"related object has value out of range", ^{
            
            testObject.value = @4;
            testObject.formattedValue = @"Item1";
            
            pickerField = [[SDPickerField alloc] initWithObjects:@[testObject]
                                             relatedPropertyKeys:@[@"value"]
                                              formattedValueKeys:@[@"formattedValue"]
                                      settableFormattedValueKeys:@[@"settabeFormattedValue"]
                                                           items:items
                                                          values:values];
            
            [[pickerField.value.firstObject should] equal:@1];
            [[pickerField.formattedValue.firstObject should] equal:@"Item1"];
            [[testObject.value should] equal:@1];
            [[testObject.settabeFormattedValue should] equal:@"Item1"];
        });

        it(@"related object has nil value", ^{
            
            testObject.value = nil;
            testObject.formattedValue = @"Item1";
            
            pickerField = [[SDPickerField alloc] initWithObjects:@[testObject]
                                             relatedPropertyKeys:@[@"value"]
                                              formattedValueKeys:@[@"formattedValue"]
                                      settableFormattedValueKeys:@[@"settabeFormattedValue"]
                                                           items:items
                                                          values:values];
            
            [[pickerField.value.firstObject should] equal:@1];
            [[pickerField.formattedValue.firstObject should] equal:@"Item1"];
            [[testObject.value should] equal:@1];
            [[testObject.settabeFormattedValue should] equal:@"Item1"];
        });
        
        it(@"related object has NSNull value", ^{
            
            testObject.value = [NSNull null];
            testObject.formattedValue = @"Item1";
            
            pickerField = [[SDPickerField alloc] initWithObjects:@[testObject]
                                             relatedPropertyKeys:@[@"value"]
                                              formattedValueKeys:@[@"formattedValue"]
                                      settableFormattedValueKeys:@[@"settabeFormattedValue"]
                                                           items:items
                                                          values:values];
            
            [[pickerField.value.firstObject should] equal:@1];
            [[pickerField.formattedValue.firstObject should] equal:@"Item1"];
            [[testObject.value should] equal:@1];
            [[testObject.settabeFormattedValue should] equal:@"Item1"];
        });
        
        it(@"related object has value below minimum index", ^{
            
            testObject.value = @1;
            testObject.formattedValue = @"Item1";
            
            pickerField = [[SDPickerField alloc] initWithObjects:nil
                                             relatedPropertyKeys:nil
                                              formattedValueKeys:nil
                                      settableFormattedValueKeys:nil
                                                           items:items
                                                          values:values];
            
            pickerField.minimumSelectedIndexes = @[@1];
            
            pickerField.relatedObject = testObject;
            pickerField.relatedPropertyKey = @"value";
            pickerField.settabeFormattedValueKey = @"settabeFormattedValue";
            
            [[pickerField.value.firstObject should] equal:@2];
            [[pickerField.formattedValue.firstObject should] equal:@"Item2"];
            [[testObject.value should] equal:@2];
            [[testObject.settabeFormattedValue should] equal:@"Item2"];
        });
        
        it(@"items are not set in the constructor", ^{
            
            testObject.value = @2;
            testObject.formattedValue = @"Item1";
            
            pickerField = [[SDPickerField alloc] initWithObject:testObject
                                             relatedPropertyKey:@"value"
                                             formattedValueKey:@"formattedValue"
                                      settableFormattedValueKey:@"settabeFormattedValue"];
            pickerField.items = items;
            pickerField.values = values;
            
            [[pickerField.value.firstObject should] equal:@2];
            [[pickerField.formattedValue.firstObject should] equal:@"Item2"];
            [[testObject.value should] equal:@2];
            [[testObject.settabeFormattedValue should] equal:@"Item2"];
        });
        
        it(@"settable formatted value key is not set in constructor", ^{
            
            testObject.value = @2;
            testObject.formattedValue = @"Item1";
            
            pickerField = [[SDPickerField alloc] initWithObject:testObject
                                             relatedPropertyKey:@"value"
                                              formattedValueKey:@"formattedValue"
                                      settableFormattedValueKey:nil];
            pickerField.items = items;
            pickerField.values = values;
            pickerField.settabeFormattedValueKey = @"settabeFormattedValue";
            
            [[pickerField.value.firstObject should] equal:@2];
            [[pickerField.formattedValue.firstObject should] equal:@"Item2"];
            [[testObject.value should] equal:@2];
            [[testObject.settabeFormattedValue should] equal:@"Item2"];
        });
        
        afterEach(^{
            testObject = nil;
            pickerField = nil;
        });
    });
    
    context(@"when using public interface", ^{
        __block SDPickerField *pickerField;
        __block TestClass *testObject;
        __block NSArray *items;
        __block NSArray *values;
        
        beforeEach(^{
            items = @[@[@"Item1", @"Item2", @"Item3"]];
            values = @[@[@1, @2, @3]];
        });
        
        it(@"selecting item by index with related object", ^{
            
            testObject = [[TestClass alloc] init];
            testObject.value = @2;
            testObject.formattedValue = @"Item1";
            
            pickerField = [[SDPickerField alloc] initWithObjects:@[testObject]
                                             relatedPropertyKeys:@[@"value"]
                                              formattedValueKeys:@[@"formattedValue"]
                                      settableFormattedValueKeys:@[@"settabeFormattedValue"]
                                                           items:items
                                                          values:values];
            
            [pickerField selectItem:2 inComponent:0];
            
            [[pickerField.value.firstObject should] equal:@3];
            [[pickerField.formattedValue.firstObject should] equal:@"Item3"];
            [[testObject.value should] equal:@3];
            [[testObject.settabeFormattedValue should] equal:@"Item3"];
        });
        
        it(@"selecting item by index without related object", ^{
            
            pickerField = [[SDPickerField alloc] initWithObjects:nil
                                             relatedPropertyKeys:nil
                                              formattedValueKeys:nil
                                      settableFormattedValueKeys:nil
                                                           items:items
                                                          values:values];
            
            [pickerField selectItem:2 inComponent:0];
            
            [[pickerField.value.firstObject should] equal:@3];
            [[pickerField.formattedValue.firstObject should] equal:@"Item3"];
        });
        
        afterEach(^{
            testObject = nil;
            pickerField = nil;
        });
    });
    
    context(@"when calling delegate methods", ^{
        __block SDPickerField *pickerField;
        __block NSObject<SDPickerFieldProtocol> *delegate;
        __block NSArray *items;
        __block NSArray *values;
        
        beforeEach(^{
            items = @[@[@"Item1", @"Item2", @"Item3"]];
            values = @[@[@1, @2, @3]];
            
            pickerField = [[SDPickerField alloc] initWithObjects:nil
                                             relatedPropertyKeys:nil
                                              formattedValueKeys:nil
                                      settableFormattedValueKeys:nil
                                                           items:items
                                                          values:values];
            
            delegate = [KWMock nullMockForProtocol:@protocol(SDPickerFieldProtocol)];
            pickerField.pickerFieldDelegate = delegate;
        });
        
        it(@"setting old value", ^{
            [[delegate shouldNot] receive:@selector(pickerField:didSelectRow:inComponent:)];
            pickerField.value = @[@1];
        });
        
        it(@"setting value", ^{
            [[delegate should] receive:@selector(pickerField:didSelectRow:inComponent:)];
            pickerField.value = @[@2];
        });
        
        it(@"selecting item", ^{
            [[delegate should] receive:@selector(pickerField:didSelectRow:inComponent:)];
            [pickerField selectItem:1 inComponent:0];
        });
        
        it(@"selecting item with picker view", ^{
            [[delegate should] receive:@selector(pickerField:didSelectRow:inComponent:)];
            [pickerField pickerView:nil didSelectRow:1 inComponent:0];
        });
        
        it (@"setting related object", ^{
            [[delegate should] receive:@selector(pickerField:didSelectRow:inComponent:)];
            TestClass *testObject = [[TestClass alloc] init];
            testObject.value = @2;
            testObject.formattedValue = @"Item1";
            pickerField.relatedObject = testObject;
            pickerField.relatedPropertyKey = @"value";
        });
        
        afterEach(^{
            pickerField = nil;
            delegate = nil;
        });
    });

});

SPEC_END