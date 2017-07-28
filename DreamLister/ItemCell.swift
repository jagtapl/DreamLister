//
//  ItemCell.swift
//  DreamLister
//
//  Created by LALIT JAGTAP on 7/26/17.
//  Copyright © 2017 LALIT JAGTAP. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {


    @IBOutlet weak var thumbImage: UIImageView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var details: UILabel!

    func configureCell(item: Item) {
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumbImage.image = item.toImage?.image as? UIImage
    }

}
