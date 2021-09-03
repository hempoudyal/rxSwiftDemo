import UIKit
import PlaygroundSupport
import RxSwift
import RxCocoa

let names = BehaviorSubject<[String]>(value: ["Peter"])

names.asObservable()
    .throttle(.seconds(2), scheduler: MainScheduler.instance) //prints just one value,
    .filter({ value in
        return value.count > 1
    })
    .debug("events")
    .map({ value in
        return "groups: \(value)"
    })
    .subscribe(onNext: { value in
    print(value)
})

names.onNext(["Peter", "Sam"])
names.onNext(["Alice", "Wendy"])


