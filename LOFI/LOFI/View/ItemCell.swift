//
//  ItemCell.swift
//  LOFI
//
//  Created by TuanNM on 10/31/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemView: MenuItem!
    
    func setUp(item:String){
       itemView.title = item
       itemView.image = UIImage(named: item)
    }
}
