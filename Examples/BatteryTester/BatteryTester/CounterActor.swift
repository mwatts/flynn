//
//  ViewController.swift
//  BatteryTester
//
//  Created by Rocco Bowling on 6/10/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

import Foundation
import Flynn

class Counter: Actor {
    public var unsafeCount: Int = 0
    public var unsafeSleepAmount: UInt32 = 0

    private var done: Bool = false
    private let batchCount: Int  = 100000

    init(_ sleepAmount: UInt32, _ qos: Int32) {
        super.init()

        if let qos = CoreAffinity(rawValue: qos) {
            unsafeCoreAffinity = qos
        }

        unsafeSleepAmount = sleepAmount

        beCount()
    }

    private func _beCount() {
        for _ in 0..<batchCount {
            unsafeCount += 1
        }
        if done == false {
            if unsafeSleepAmount > 0 {
                usleep(unsafeSleepAmount)
            }
            self.beCount()
        }
    }

    private func _beStop() {
        self.done = true
    }

    private func _beSetCoreAffinity(_ affinity: Int32) {
        if let qos = CoreAffinity(rawValue: affinity) {
            self.unsafeCoreAffinity = qos
        }
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension Counter {

    @discardableResult
    public func beCount() -> Self {
        unsafeSend(_beCount)
        return self
    }
    @discardableResult
    public func beStop() -> Self {
        unsafeSend(_beStop)
        return self
    }
    @discardableResult
    public func beSetCoreAffinity(_ affinity: Int32) -> Self {
        unsafeSend { self._beSetCoreAffinity(affinity) }
        return self
    }

}
