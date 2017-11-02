//
//  TouchPadViewController.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import Speech


class TouchPadViewController: UIViewController {

    @IBOutlet weak var touchPadContainer: UIView!
    @IBOutlet weak var touchPad: UIImageView!
    
    @IBOutlet weak var sliderA: UISlider!
    @IBOutlet weak var sliderB: UISlider!
    
    var prevLocation:CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderA.setThumbImage(UIImage(named: "1.png"), for: .normal)
        sliderB.setThumbImage(UIImage(named: "2.png"), for: .normal)

    }
    
    var isMove = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: touchPad) else{return}
        
        let maxSize = touchPad.frame.width
        
        if touch.x > 0 && touch.x < maxSize && touch.y > 0 && touch.y < maxSize{
            prevLocation = CGPoint(x: touchPadContainer.frame.size.width / 2, y: touchPadContainer.frame.size.width / 2)
            isMove = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.touchPad.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { (done) in
                
            }
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first?.location(in: touchPadContainer) else{return}

        if isMove {
            
            let maxSize = touchPadContainer.frame.width
            let centerX = touch.x > 0 && touch.x < maxSize ? touch.x : touchPad.center.x
            let centerY = touch.y > 0 && touch.y < maxSize ? touch.y : touchPad.center.y
            
            let center = CGPoint(x: centerX, y: centerY)
            
            let direction = Utils.getDirectionBasic(prevLocation: prevLocation, currentLocation: center)
            if direction != .NON{
                prevLocation = center
                BluetoothService.shareInstance.sendDirection(direction: direction)
            }
  
            UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.touchPad.center = center
            }, completion: { (done) in
                
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isMove = false
        let maxSize = touchPadContainer.frame.width
        let center = CGPoint(x: maxSize/2, y: maxSize/2)
        UIView.animate(withDuration: 0.2, animations: {
            self.touchPad.center = center
            self.touchPad.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (done) in
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
