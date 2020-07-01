//
//  Actor.swift
//  Flynn
//
//  Created by Rocco Bowling on 5/10/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

// swiftlint:disable force_cast

import Foundation
import Pony

public typealias BehaviorArgs = [Any]

public extension Array {
    // Extract and convert a subscript all in one command. Since we don't have compiler
    // support for checking parameters with behaviors, I am leaning towards crashing
    // in order to help identify buggy code faster.
    func get<T>(_ idx: Int) -> T {
        return self[idx] as! T
    }
    subscript<T>(x idx: Int) -> T {
        return self[idx] as! T
    }

    func check(_ idx: Int) -> Any {
        return self[idx]
    }
}

public typealias BehaviorBlock = ((BehaviorArgs) -> Void)

private func failReferenceTypesToBehavior(_ arg: Any) {
    print("warning: passing \(type(of: arg)) to behavior can lead to data races (use value types instead)")
    print("         add symbolic breakpoint for failReferenceTypesToBehavior for more information")
}

private func checkReferenceTypesToBehavior(_ args: BehaviorArgs) {
    //for arg in args where type(of: arg) is AnyClass {
    for arg in args where type(of: arg) is AnyClass {
        if !(arg is Actor) && !(arg is Behavior) {
            failReferenceTypesToBehavior(arg)
        }
        break
    }
}

@dynamicCallable
public class ChainableBehavior<T: Actor> {
    private weak var actor: T?
    private let fastBlocks: FastBlockCalls
    private let checkForUnsafeArguments = Flynn.checkForUnsafeArguments

    public init(_ actor: T, _ block: @escaping BehaviorBlock) {
        self.actor = actor
        self.fastBlocks = FastBlockCalls(block)
    }

    public init(_ block: @escaping BehaviorBlock) {
        self.actor = nil
        self.fastBlocks = FastBlockCalls(block)
    }

    deinit {
        //print("deinit - ChainableBehavior")
        fastBlocks.dealloc()
    }

    public func setActor(_ actor: T) {
        self.actor = actor
    }

    @discardableResult public func dynamicallyCall(withArguments args: BehaviorArgs) -> T {
        if checkForUnsafeArguments {
            checkReferenceTypesToBehavior(args)
        }
        fastBlocks.call(actor!, args)
        return actor!
    }

    @discardableResult public func dynamicallyFlow(withArguments args: BehaviorArgs) -> T {
        fastBlocks.call(actor!, args)
        return actor!
    }
}

@dynamicCallable
public class Behavior {
    private weak var actor: Actor?
    private let fastBlocks: FastBlockCalls
    private let checkForUnsafeArguments = Flynn.checkForUnsafeArguments

    public init(_ actor: Actor, _ block: @escaping BehaviorBlock) {
        self.actor = actor
        self.fastBlocks = FastBlockCalls(block)
    }

    public init(_ block: @escaping BehaviorBlock) {
        self.actor = nil
        self.fastBlocks = FastBlockCalls(block)
    }

    deinit {
        //print("deinit - Behavior")
        fastBlocks.dealloc()
    }

    public func setActor(_ actor: Actor) {
        self.actor = actor
    }

    public func dynamicallyCall(withArguments args: BehaviorArgs) {
        if checkForUnsafeArguments {
            checkReferenceTypesToBehavior(args)
        }
        fastBlocks.call(actor!, args)
    }

    public func dynamicallyFlow(withArguments args: BehaviorArgs) {
        fastBlocks.call(actor!, args)
    }
}
