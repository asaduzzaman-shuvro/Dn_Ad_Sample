//
//  Debouncer.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 25/8/20.
//  Copyright © 2020 Asaduzzaman Shuvro. All rights reserved.
//

import Foundation

class Debouncer {
    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem
    private var interval: TimeInterval
    
    init(seconds: TimeInterval, workItem: DispatchWorkItem = DispatchWorkItem(block: {}), onQueue queue: DispatchQueue = DispatchQueue.main) {
        self.interval = seconds
        self.workItem = workItem
        self.queue = queue
    }
    
    func debounce(action: @escaping(() -> Void), cancelBlock: (() -> Void)? = nil) {
        workItem.cancel()
        cancelBlock?()
        workItem = DispatchWorkItem(block: {
            action()
        })
        queue.asyncAfter(deadline: .now() + interval, execute: workItem)
    }
}
