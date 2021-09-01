//
//  ViewController.swift
//  RxSwift App
//
//  Created by Hem Poudyal on 30.08.21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController{

    /*
    let tableViewItems = Observable.just([Food.init(name: "Hamburger", image: "hamburger"),
                                         Food.init(name: "Pizza", image: "pizza"),
                                         Food.init(name: "Salmon", image: "salmon"),
                                         Food.init(name: "Momo", image: "momo"),
                                         Food.init(name: "Curry", image: "salmon"),
                                         Food.init(name: "Salad", image: "pizza"),
                                         Food.init(name: "Pancakes", image: "hamburger")])
    
    let tableViewItems =  BehaviorRelay.init(value: [Food.init(name: "Hamburger", image: "hamburger"),
                                         Food.init(name: "Pizza", image: "pizza"),
                                         Food.init(name: "Salmon", image: "salmon"),
                                         Food.init(name: "Momo", image: "momo"),
                                         Food.init(name: "Curry", image: "salmon"),
                                         Food.init(name: "Salad", image: "pizza"),
                                         Food.init(name: "Pancakes", image: "hamburger")]) */
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    let tableViewItemsSectioned = BehaviorRelay.init(value: [
        SectionModel(header: "Main Courses", items: [
                        Food.init(name: "Hamburger", image: "hamburger"),
                                                             Food.init(name: "Pizza", image: "pizza"),
                                                             Food.init(name: "Salmon", image: "salmon"),
                                                             Food.init(name: "Momo", image: "momo"),
                                                             Food.init(name: "Curry", image: "salmon"),]),
        SectionModel(header: "Deserts", items: [ Food.init(name: "Salad", image: "pizza"),
                                                  Food.init(name: "Pancakes", image: "hamburger")])
    ])
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
        dataSource, tableView, indexPath, item in
        
        let cell : FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FoodTableViewCell
        cell.foodLabel.text = item.name
        cell.foodImageView.image = UIImage.init(named: item.image)
        return cell
        
    }, titleForHeaderInSection: {
        
        dataSource, index in
        return dataSource.sectionModels[index].header
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Menu"
        let foodQuery = searchBar.rx.text.orEmpty
                        .throttle(.milliseconds(300), scheduler: MainScheduler.instance) //if user decides to change the text, delay to wait
                        .distinctUntilChanged() //returns distinct value from observables
                        .map({
                            query in
                            
                            self.tableViewItemsSectioned.value.map ({ sectionModel in
                                SectionModel(header: sectionModel.header, items: sectionModel.items.filter({
                                    food in
                                    query.isEmpty || food.name.lowercased().contains(query.lowercased())
                                }))
                            })
                            
        }).bind(to: tableView
                    .rx
                    .items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // for model, this is an observable so we need to subscribe to it
        tableView.rx.modelSelected(Food.self).subscribe(onNext: { foodObject in
            let foodVC = self.storyboard?.instantiateViewController(identifier: "FoodVC") as! FoodDetailViewController
            foodVC.imageName.accept(foodObject.image) //accepting for behavior relay element
            self.navigationController?.pushViewController(foodVC, animated: true)
        }).disposed(by: disposeBag)
        
        /*
        // if you want to work with indexpath, use rxCocoa method
        tableView.rx.itemSelected.subscribe(onNext: {indexPath in
            let foodVC = self.storyboard?.instantiateViewController(identifier: "FoodVC") as! FoodDetailViewController
            foodVC.imageName = tableViewItems[indexPath.row] //blah blah
            self.navigationController?.pushViewController(foodVC, animated: true)
        }).disposed(by: disposeBag)
         */
    }
    
}

