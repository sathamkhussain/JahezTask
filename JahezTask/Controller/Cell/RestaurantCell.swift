//
//  RestaurantCellTableViewCell.swift
//  JahezTask
//
//  Created by Satham Hussain on 1/26/22.
//

import UIKit

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var resImgView : UIImageView!
    @IBOutlet weak var resNameLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        resImgView.clipsToBounds = true
        resImgView.layer.cornerRadius = resImgView.frame.size.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
