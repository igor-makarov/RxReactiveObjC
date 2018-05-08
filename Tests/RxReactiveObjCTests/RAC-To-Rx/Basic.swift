//
//  RAC-To-Rx.swift
//
//

import XCTest
import ReactiveObjC
import RxSwift
import RxReactiveObjC

class RACToRxBasicTests: XCTestCase {
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        continueAfterFailure = false
    }
    
    func test_Next() {
        for count in [1, 2, 10] {
            XCTContext.runActivity(named: "\(count) values") { _ in
                let signal = RACSignal<NSString>.createSignal {
                    for i in 0..<count {
                        $0.sendNext("\(i)")
                    }
                    return RACDisposable()
                }
                let values = expectation(description: "value")
                values.expectedFulfillmentCount = count
                Observable.from(signal)
                    .subscribe(onNext: { str in
                        XCTAssertNotNil(str)
                        values.fulfill()
                    })
                    .disposed(by: disposeBag)
                wait(for: [values], timeout: 2)
            }
        }
    }
    
    func test_Completed() {
        let signal = RACSignal<NSString>.createSignal {
            $0.sendCompleted()
            return RACDisposable()
        }
        let completion = expectation(description: "completion")
        Observable.from(signal)
            .subscribe(onCompleted: { completion.fulfill() })
            .disposed(by: disposeBag)
        wait(for: [completion], timeout: 2)
    }
    
    func test_NoError() {
        let signal = RACSignal<NSString>.createSignal {
            $0.sendCompleted()
            return RACDisposable()
        }
        let completion = expectation(description: "completion")
        let errored = expectation(description: "errored")
        errored.isInverted = true
        Observable.from(signal)
            .subscribe(onError: { _ in errored.fulfill() },
                       onCompleted: { completion.fulfill() })
            .disposed(by: disposeBag)
        wait(for: [completion, errored], timeout: 2)
    }
    
    func test_Error() {
        let signal = RACSignal<NSString>.createSignal {
            $0.sendError(NSError(domain: "Error", code: 2, userInfo: nil))
            return RACDisposable()
        }
        
        let errored = expectation(description: "errored")
        Observable.from(signal)
            .subscribe(onError: { error in
                XCTAssertEqual(error as NSError, NSError(domain: "Error", code: 2, userInfo: nil))
                errored.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [errored], timeout: 2)
    }
    
    func test_Dispose() {
        let dispose = expectation(description: "dispose")
        let signal = RACSignal<NSString>.createSignal { subscriber in
            subscriber.sendCompleted()
            return RACDisposable(block: {
                XCTAssertNotNil(subscriber) // to ensure capture
                dispose.fulfill()
            })
        }
        _ = Observable.from(signal)
            .subscribe { _ in }
            .disposed(by: disposeBag)
        wait(for: [dispose], timeout: 1)
    }
    
    func test_NotDispose() {
        let dispose = expectation(description: "dispose")
        dispose.isInverted = true
        let signal = RACSignal<NSString>.createSignal { subscriber in
            return RACDisposable(block: {
                XCTAssertNotNil(subscriber) // to ensure capture
                dispose.fulfill()
            })
        }
        _ = Observable.from(signal)
            .subscribe { _ in }
            .disposed(by: disposeBag)
        wait(for: [dispose], timeout: 3)
    }
}
