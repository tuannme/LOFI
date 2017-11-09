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
    @IBOutlet weak var squareBtn: ImageButton!
    @IBOutlet weak var triangleBtn: ImageButton!
    @IBOutlet weak var xBtn: ImageButton!
    @IBOutlet weak var oBtn: ImageButton!
    @IBOutlet weak var touchPad: UIImageView!
    
    var isMove = false
    var privot = Date()
    var prevLocation:CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        squareBtn.tapAction = {
            var message = "S"
            if let customValue = UserDefaults.standard.object(forKey: SQUARE) as? String {
                message = customValue
            }
            BluetoothService.shareInstance.sendMessage(message: message)
        }
        triangleBtn.tapAction = {
            var message = "T"
            if let customValue = UserDefaults.standard.object(forKey: TRIANGLE) as? String {
                message = customValue
            }
            BluetoothService.shareInstance.sendMessage(message: message)
        }
        xBtn.tapAction = {
            var message = "X"
            if let customValue = UserDefaults.standard.object(forKey: X) as? String {
                message = customValue
            }
            BluetoothService.shareInstance.sendMessage(message: message)
        }
        oBtn.tapAction = {
            var message = "O"
            if let customValue = UserDefaults.standard.object(forKey: O) as? String {
                message = customValue
            }
            BluetoothService.shareInstance.sendMessage(message: message)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension TouchPadViewController{
    
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
        
        let offset = touchPad.frame.size.width/2
        
        if isMove {
            
            let maxSize = touchPadContainer.frame.width
            let centerX = touch.x - offset > 0 && touch.x + offset < maxSize ? touch.x : touchPad.center.x
            let centerY = touch.y  - offset > 0 && touch.y  + offset < maxSize ? touch.y : touchPad.center.y
            
            let center = CGPoint(x: centerX, y: centerY)
            
            /*send data every 1s*/
            
            let now = Date()
            if now.timeIntervalSince(self.privot) >= 1{
                self.privot = now
                let direction = Utils.getDirectionPeriod(prevLocation: self.prevLocation, currentLocation: center)
                if direction != .NON{
                    BluetoothService.shareInstance.sendDirection(direction: direction)
                }
                self.prevLocation = center
            }
            //self.prevLocation = center
            
            /* send data when move > 10 unit
            let direction = Utils.getDirectionBasic(prevLocation: prevLocation, currentLocation: center)
            if direction != .NON{
                prevLocation = center
                BluetoothService.shareInstance.sendDirection(direction: direction)
            }
            */
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
    
}
