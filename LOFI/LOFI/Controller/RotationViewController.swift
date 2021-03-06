//
//  RotationViewController.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import CoreMotion

class RotationViewController: UIViewController,UIAccelerometerDelegate  {
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var boundView: UIView!
    
    let motionManager = CMMotionManager()
    var prevLocation:CGPoint!
    
    var privot = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func startMotionDetect(){
        
        print("START _ MOTION ")
        prevLocation = CGPoint(x: rotationView.frame.width/2, y: rotationView.frame.width/2)
        let stepMoveFactor:CGFloat = 8
       
        motionManager.deviceMotionUpdateInterval = 1/60
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { (data, error) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                
                var rect = self.rotationView.frame
                
                //print("\(data.acceleration.x) : \(data.acceleration.y)")
                
                let moveToX = rect.origin.x + CGFloat(data.acceleration.y)*stepMoveFactor
                let maxX = self.boundView.frame.size.width - rect.size.width
                
                let moveToY = rect.origin.y + CGFloat(data.acceleration.x)*stepMoveFactor
                let maxY = self.boundView.frame.size.height - rect.size.height
                
            
                 if moveToX >= 0 && moveToX <= maxX{
                    rect.origin.x += CGFloat(data.acceleration.y)*stepMoveFactor
                 }

                if moveToY >= 0 && moveToY <= maxY{
                    rect.origin.y += CGFloat(data.acceleration.x)*stepMoveFactor
                }
                
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.rotationView.frame = rect
                    
                    let center = self.rotationView.center
                    
                    /*send data every 1s*/
                    let now = Date()
                    if now.timeIntervalSince(self.privot) >= 1{
                        self.privot = now
                        let direction = Utils.getDirectionPeriod(prevLocation: self.prevLocation, currentLocation: center)
                        if direction != .NON{
                            BluetoothService.shareInstance.sendDirection(direction: direction)
                        }
                    }
                    self.prevLocation = center
                    
                    /* get direction by move > 10 unit
                    let direction = Utils.getDirectionBasic(prevLocation: self.prevLocation, currentLocation: center)
                    if direction != .NON{
                        self.prevLocation = center
                        BluetoothService.shareInstance.sendDirection(direction: direction)
                    }
                    */
                }, completion: nil)
                
            }
        }
    }
    

    
    func stopMotion(){
        print("STOP _ MOTION ")
        motionManager.stopAccelerometerUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
