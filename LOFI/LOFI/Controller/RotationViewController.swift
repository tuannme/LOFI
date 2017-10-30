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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startMotion()
    }

    var ball:UIImageView!
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
    
    func startMotion(){
        ball = UIImageView(image:UIImage(named:"rotation"))
        ball.frame = CGRect(x:0, y:0, width:50, height:50)
        ball.center = self.view.center
        self.view.addSubview(ball)
        
        motionManager.accelerometerUpdateInterval = 1/60
        
        if motionManager.isAccelerometerAvailable {
            let queue = OperationQueue.current
            motionManager.startAccelerometerUpdates(to: queue!, withHandler: {
                (accelerometerData, error) in
                //动态设置小球位置
                self.speedX += accelerometerData!.acceleration.x
                self.speedY +=  accelerometerData!.acceleration.y
                var posX=self.ball.center.x - CGFloat(self.speedX)
                var posY=self.ball.center.y + CGFloat(self.speedY)
                //碰到边框后的反弹处理
                if posX<0 {
                    posX=0;
                    //碰到左边的边框后以0.4倍的速度反弹
                    self.speedX *= -1.5
                    
                }else if posX > self.view.bounds.size.width {
                    posX=self.view.bounds.size.width
                    //碰到右边的边框后以0.4倍的速度反弹
                    self.speedX *= -0.4
                }
                if posY<0 {
                    posY=0
                    //碰到上面的边框不反弹
                    self.speedY=0
                } else if posY>self.view.bounds.size.height{
                    posY=self.view.bounds.size.height
                    //碰到下面的边框以1.5倍的速度反弹
                    self.speedY *= -0.4
                }
                self.ball.center = CGPoint(x:posX, y:posY)
            })
        }
    }
    
    
    func startMotionDetect(){
        
        let stepMoveFactor:CGFloat = 5
        
        motionManager.deviceMotionUpdateInterval = 5
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { (data, error) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                
                var rect = self.rotationView.frame
                
                print("\(data.acceleration.x) : \(data.acceleration.y)")
                
                let moveToX = rect.origin.x - CGFloat(data.acceleration.x)*stepMoveFactor
                let maxX = self.view.frame.size.width - rect.size.width
                
                let moveToY = rect.origin.y + CGFloat(data.acceleration.y)*stepMoveFactor
                let maxY = self.view.frame.size.height - rect.size.height
               
                if moveToX > 0 && moveToX < maxX{
                    rect.origin.x -= CGFloat(data.acceleration.x)*stepMoveFactor
                }
                
                if moveToY > 0 && moveToY < maxY{
                    rect.origin.y += CGFloat(data.acceleration.y)*stepMoveFactor
                }
                
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.rotationView.frame = rect
                }, completion: nil)
              
            }
        }
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
