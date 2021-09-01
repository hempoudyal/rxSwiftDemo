//
//  FoodDetailViewController.swift
//  RxSwift App
//
//  Created by Hem Poudyal on 30.08.21.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxRelay

class FoodDetailViewController: UIViewController {
    @IBOutlet weak var foodImageView: UIImageView!
    
    let imageName = BehaviorRelay<String>(value: "")
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        /* false attempt
        let bRel = BehaviorRelay<String>(value: imageName)
        _ = bRel.subscribe(onNext: {
            elem in
            self.foodImageView.image = UIImage.init(named: elem)
        })
         */
        
        imageName.map({
            name in
            UIImage.init(named: name)
        }).bind(to: foodImageView.rx.image)
        .disposed(by: bag)
        
    }
}
