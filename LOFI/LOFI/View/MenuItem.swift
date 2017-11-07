//
//  ButtonMenuView.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

class MenuItem: UIView {


    @IBOutlet weak var icImv: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    
    var tapAction:(()->Void)?

    @IBInspectable var title: String? {
        get {
            return titleLb.text
        }
        set(value) {
            titleLb.text = value
        }
    }
    
    @IBInspectable var image: UIImage? {
        get {
            return icImv.image
        }
        set(value) {
            icImv.image = value
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    fileprivate func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        addSubview(view)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapViewAction))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func tapViewAction(){
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (done) in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.tapAction?()
        }
    }
    
    // Loads a XIB file into a view and returns this view.
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
