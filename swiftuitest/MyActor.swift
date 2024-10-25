//
//  MyActor.swift
//  swiftuitest
//
//  Created by Kazutaka Homma on 2024-10-25.
//

import Combine
import Foundation

class VM {
    public let myActor = MyActor()

    deinit {
        print("deinit \(self)")
        myActor.end()
    }
}

actor MyActor {
    deinit {
        print("deinit \(self)")
    }

    let subject = PassthroughSubject<Int, Never>()
    var publisher: AnyPublisher<Int, Never> {
        subject.eraseToAnyPublisher()
    }

    var count = 0

    func start() {
        Task {
            for await i in publisher.asyncStream() {
                handle(i)
            }
            print("leaving asyncStream Task")
        }

        for i in 0 ..< 1 {
            subject.send(i)
        }
    }

    func handle(_ i: Int) { count += i }

    nonisolated func end() {
        // This make sure for-await ends
        Task { await subject.send(completion: .finished) }
    }
}

public extension AnyPublisher where Failure == Never {
    func asyncStream() -> AsyncStream<Output> {
        AsyncStream { continuation in
            let cancellable = sink { _ in
                // This line was missing
                continuation.finish()
            } receiveValue: { value in
                continuation.yield(value)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}
