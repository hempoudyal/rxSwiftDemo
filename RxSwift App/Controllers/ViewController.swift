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
                                         Food.init(name: "Pancakes", image: "hamburger")]) */
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    let tableViewItemsSectioned = BehaviorRelay.init(value: [
        SectionModel(header: "Main Courses", items: [
                        Food.init(name: "Hamburger", image: "hamburger", price: 3.75, favorite: false),
                        Food.init(name: "Pizza", image: "pizza", price: 2.80, favorite: true),
                        Food.init(name: "Salmon", image: "salmon", price: 3.25, favorite: false),
                        Food.init(name: "Momo", image: "momo", price: 4.99, favorite: true),
                        Food.init(name: "Curry", image: "curry", price: 2.99, favorite: false),]),
        SectionModel(header: "Deserts", items: [ Food.init(name: "Salad", image: "salad", price: 5.25, favorite: false),
                                                 Food.init(name: "Pancakes", image: "pancakes", price: 3.50, favorite: false)])
    ])
    
    
    func setFavoriteButton(state: Bool) -> UIImage{
        if state{
            return UIImage.init(systemName: "star.fill")!
        } else {
            return UIImage.init(systemName: "star")!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Menu"
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
            dataSource, tableView, indexPath, item in
            
            let cell : FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FoodTableViewCell
            
            cell.foodLabel.text = item.name
            cell.foodImageView.image = UIImage.init(named: item.image)
            cell.price.text = String(item.price)
            
            let favImage = self.setFavoriteButton(state: item.favorite)
            cell.favoriteButton.setImage(favImage, for: .normal)
            
            return cell
            
        }, titleForHeaderInSection: {
            
            dataSource, index in
            return dataSource.sectionModels[index].header
            
        })
        
        _ = searchBar.rx.text.orEmpty
                        .throttle(.seconds(1), scheduler: MainScheduler.instance) //if user decides to change the text, delay to wait
                        .distinctUntilChanged() //returns distinct value from observables
                        .map({
                            query in
                            
                            self.tableViewItemsSectioned.value.map ({ sectionModel in
                                SectionModel(header: sectionModel.header, items: sectionModel.items.filter({
                                    food in
                                    return query.isEmpty || food.name.lowercased().contains(query.lowercased())
                                }))
                            })
                            
        }).bind(to: tableView
                    .rx
                    .items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // for model, this is an observable so we need to subscribe to it
        tableView.rx
            .modelSelected(Food.self)
            .debug("my test")
            .subscribe(onNext: { foodObject in
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

