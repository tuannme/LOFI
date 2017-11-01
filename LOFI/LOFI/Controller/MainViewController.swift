//
//  MainViewController.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var touchPadContainer: UIView!
    @IBOutlet weak var bluetoothContainer: UIView!
    @IBOutlet weak var rotationContainer: UIView!
    @IBOutlet weak var microphoneContainer: UIView!
    
    @IBOutlet weak var menuView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    var bluetoothVC:BluetoothScanViewController?
    var rotaionVC:RotationViewController?
    var microVC:MicrophoneViewController?
    
    var items = ["GAMEPAD","ROTAION","MICROPHONE","REMOTE"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.didTapLofi))
        menuView.isUserInteractionEnabled = true
        menuView.addGestureRecognizer(tapGes)
        
        BluetoothService.shareInstance.bluetoothCentralDelegate = self
        
    }
    @objc func didTapLofi() {
        UIView.animate(withDuration: 0.1, animations: {
            self.menuView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (done) in
            self.menuView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        bluetoothContainer.isHidden = true
        touchPadContainer.isHidden = true
        rotationContainer.isHidden = true
        microphoneContainer.isHidden = true
        
        self.rotaionVC?.stopMotion()
        self.microVC?.stopSpeaking()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inforAction(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination
        
        switch  destinationVC{
        case is BluetoothScanViewController:
            bluetoothVC = (destinationVC as! BluetoothScanViewController)
            break
        case is RotationViewController:
            rotaionVC = (destinationVC as! RotationViewController)
            break
        case is MicrophoneViewController:
            microVC = (destinationVC as! MicrophoneViewController)
            break
        default:
            break
        }
        
    }
    
    @IBAction func bluetoothAction(_ sender: Any) {
        bluetoothContainer.isHidden = false
        touchPadContainer.isHidden = true
        rotationContainer.isHidden = true
        microphoneContainer.isHidden = true
        BluetoothService.shareInstance.scanBluetooth()
        self.rotaionVC?.stopMotion()
        self.microVC?.stopSpeaking()
    }
}

extension MainViewController:BluetoothCentralDelegate{

    func didConnect() {
        self.touchPadContainer.isHidden = false
        self.bluetoothContainer.isHidden = true
        self.rotationContainer.isHidden = true
        self.microphoneContainer.isHidden = true
    }

}

extension MainViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item  = items[indexPath.row]
        itemCell.setUp(item: item)
        
        itemCell.itemView.tapAction = {
            self.didTapItem(index: indexPath.row)
        }
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }
    
    func didTapItem(index:Int) {
        switch index {
        case 0:
            self.touchPadContainer.isHidden = false
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = true
            break
        case 1:
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = false
            self.microphoneContainer.isHidden = true
            self.rotaionVC?.startMotionDetect()
            break
        case 2:
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = false
            self.microVC?.startSpeaking()
            break
        case 3:
            break
        default:
            break
        }
    }
    
}

extension MainViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
}
