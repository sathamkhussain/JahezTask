//
//  TableViewRestaurants.swift
//  JahezTask
//
//  Created by Satham Hussain on 1/26/22.
//

import UIKit
import SDWebImage
class TableViewRestaurants: UIViewController {
    var restaurantLSt = [Restaurant]()
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Restaurants"
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.restaurantLSt.removeAll()
        WebService.fetchRestaurants { restaurants in
            self.restaurantLSt = restaurants
            self.restaurantLSt = self.restaurantLSt.sorted(by: { $0.distance ?? 0.0 > $1.distance ?? 0.0 })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}



extension TableViewRestaurants : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantLSt.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        let restaurant = restaurantLSt[indexPath.row]
        cell.resImgView.sd_setImage(with: URL(string: restaurant.image ?? ""))
        cell.resNameLbl.text = restaurant.name ?? ""
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = self.restaurantLSt[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetail
        vc.restaurant = restaurant
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
