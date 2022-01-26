//
//  RestaurantDetail.swift
//  JahezTask
//
//  Created by Satham Hussain on 1/26/22.
//

import Foundation
import UIKit
import SDWebImage
class RestaurantDetail: UIViewController {
    var restaurant : Restaurant?
    @IBOutlet weak var imgVew : UIImageView!
    @IBOutlet weak var restaurantNameLbl : UILabel!
    @IBOutlet weak var descLbl : UILabel!
    @IBOutlet weak var hoursLbl : UILabel!
    @IBOutlet weak var ratingLbl : UILabel!
    override func viewDidLoad() {
        print(restaurant?.name ?? "")
        imgVew.sd_setImage(with: URL(string: restaurant?.image ?? ""))
                restaurantNameLbl.text = restaurant?.name ?? ""
        descLbl.text = restaurant?.description ?? ""
        hoursLbl.text = restaurant?.hours ?? ""
        ratingLbl.text = "Rating :\(restaurant?.rating ?? 0)"
    }
}
