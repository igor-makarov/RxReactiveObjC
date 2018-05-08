//
//  RAC-To-Rx.swift
//
//

import XCTest
import ReactiveObjC
import RxSwift
import RxReactiveObjC

class RxToRACBasicTests: XCTestCase {
    var disposable: RACScopedDisposable?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
        disposable = nil
    }
    
    func test_Next() {
        for count in [1, 2, 10] {
            XCTContext.runActivity(named: "\(count) values") { _ in
                let observable = Observable.from(Array(0..<count)).map { "\($0)" as NSString }
                let values = expectation(description: "value")
                values.expectedFulfillmentCount = count

                disposable = observable.asSignal()
                    .subscribeNext { _ in values.fulfill() }
                    .asScopedDisposable()
                wait(for: [values], timeout: 2)
            }
        }
    }
    
    func test_Completed() {
        let observable = Observable<NSString>.empty()
        let completion = expectation(description: "completion")
        disposable = observable.asSignal()
            .subscribeCompleted { completion.fulfill() }
            .asScopedDisposable()
        wait(for: [completion], timeout: 2)
    }

    func test_NoError() {
        let observable = Observable<NSString>.empty()
        let completion = expectation(description: "completion")
        let errored = expectation(description: "errored")
        errored.isInverted = true
        disposable = observable.asSignal()
            .subscribeError({ _ in errored.fulfill() },
                            completed: { completion.fulfill() })
            .asScopedDisposable()
        wait(for: [completion, errored], timeout: 2)
    }

    func test_Error() {
        let observable = Observable<NSString>.error(NSError(domain: "Error", code: 2, userInfo: nil))

        let errored = expectation(description: "errored")
        disposable = observable.asSignal()
            .subscribeError { error in
                XCTAssertNotNil(error)
                XCTAssertEqual(error! as NSError, NSError(domain: "Error", code: 2, userInfo: nil))
                errored.fulfill()
            }
            .asScopedDisposable()
        wait(for: [errored], timeout: 2)
    }

    func test_Dispose() {
        let dispose = expectation(description: "dispose")
        let observable = Observable<NSString>.create { observer in
            observer.onCompleted()
            return Disposables.create {
                XCTAssertNotNil(observer)
                dispose.fulfill()
            }
        }

        disposable = observable.asSignal()
            .subscribeCompleted { }
            .asScopedDisposable()
        wait(for: [dispose], timeout: 1)
    }

    func test_NotDispose() {
        let dispose = expectation(description: "dispose")
        dispose.isInverted = true
        let observable = Observable<NSString>.create { observer in
            return Disposables.create {
                XCTAssertNotNil(observer)
                dispose.fulfill()
            }
        }

        disposable = observable.asSignal()
            .subscribeCompleted { }
            .asScopedDisposable()
        wait(for: [dispose], timeout: 3)
    }
}
