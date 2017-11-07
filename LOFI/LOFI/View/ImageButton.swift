//
//  ImageButton.swift
//  LOFI
//
//  Created by Nguyen Manh Tuan on 11/7/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

class ImageButton: UIImageView {

    var tapAction:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOwner))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    @objc func didTapOwner() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (done) in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.tapAction?()
        }
    }
}
