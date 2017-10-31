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
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var boundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func startMotionDetect(){
        
        let stepMoveFactor:CGFloat = 8
        
        motionManager.deviceMotionUpdateInterval = 1/60
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { (data, error) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                
                var rect = self.rotationView.frame
                
                print("\(data.acceleration.x) : \(data.acceleration.y)")
                
                let moveToX = rect.origin.x - CGFloat(data.acceleration.y)*stepMoveFactor
                let maxX = self.boundView.frame.size.width - rect.size.width
                
                let moveToY = rect.origin.y + CGFloat(data.acceleration.x)*stepMoveFactor
                let maxY = self.boundView.frame.size.height - rect.size.height
                
                if moveToX >= 0 && moveToX <= maxX{
                    rect.origin.x += CGFloat(data.acceleration.y)*stepMoveFactor
                }else if moveToX < 0 {
                    rect.origin.x = 1
                }else if moveToX > maxX{
                    rect.origin.x = maxX - 1
                }
                
                if moveToY >= 0 && moveToY <= maxY{
                    rect.origin.y += CGFloat(data.acceleration.x)*stepMoveFactor
                }else if moveToY < 0 {
                    rect.origin.y = 1
                }else if moveToY > maxY{
                    rect.origin.y = maxY + 1
                }
                
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.rotationView.frame = rect
                }, completion: nil)
                
            }
        }
    }
    
    func stopMotion(){
        motionManager.stopAccelerometerUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
