import UIKit
import RxSwift
import RxCocoa
import RxRelay


/* Subject - observable + observer

Relays - wrapper around subjects that never complete */

/* Publish Subject */
let pSub = PublishSubject<String>() //emits new element to subscriber
pSub.onNext("PS E1 1")

let ob1 = pSub.subscribe(onNext: {
    element in
    print(element)
})

pSub.onNext("PS E1 2") //add a new element, observer will receive it
pSub.onNext("PS E1 3")

/* Behavior Subject */

let bSub = BehaviorSubject<String>(value: "BS E1 1") //emits last element to subscriber
//behavior emits latest element, you can't create one without providing initial value

let ob2 = bSub.subscribe(onNext: {
    element in
    print(element)
})

bSub.onNext("BS E1 2")

/* Replay Subject */

let rSub = ReplaySubject<Int>.create(bufferSize: 2) //emits a buffer size of elements to new subscribers
rSub.onNext(1)
rSub.onNext(2)
rSub.onNext(3) //prints last 2 as of buffer size

let ob3 = rSub.map({
    elem in
    elem * 2
}).subscribe(onNext: {element in
    print(element)
})

/* Async Subject */
let aSub = AsyncSubject<String>() //emits only the last next event in the sequence, only when subject receiveds a completed event
aSub.onNext("AS E1 1")
aSub.onNext("AS E1 2")

aSub.onCompleted() //source observer has to complete and it emits only the last value

let ob4 = aSub.subscribe(onNext: {element in
    print(element)
})

/* Publish Relay */
let pRel = PublishRelay<String>()
pRel.accept("pRel E1 1") //observer subscribes after the accept method

let ob5 = pRel.subscribe(onNext: {element in
    print(element)
})

pRel.accept("pRel E1 2") //already subscribed and prints to the console

/* Behavior Relay */
let bRel = BehaviorRelay<String>(value: "bRel E1 1") //acts more like behaviour subject, prints both value

let ob6 = bRel.subscribe(onNext: {element in
    print(element)
})

bRel.accept("bRel E1 2")
