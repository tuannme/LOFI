//
//  MainViewController.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class MainViewController: UIViewController {

    @IBOutlet weak var touchPadContainer: UIView!
    @IBOutlet weak var bluetoothContainer: UIView!
    @IBOutlet weak var rotationContainer: UIView!
    @IBOutlet weak var microphoneContainer: UIView!
    @IBOutlet weak var terminalContainer: UIView!
    
    @IBOutlet weak var menuView: UIImageView!
    
    @IBOutlet weak var infoBtn: UIButton!
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
        terminalContainer.isHidden = true
        
        self.rotaionVC?.stopMotion()
        self.microVC?.stopSpeaking()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inforAction(_ sender: Any) {
        if touchPadContainer.isHidden == false{
            let settingVc = SettingViewController(nibName: "SettingViewController", bundle: nil)
            var frameVC = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            settingVc.view.frame = frameVC
            self.addChildViewController(settingVc)
            self.view.addSubview(settingVc.view)
            
            frameVC.origin.x = 0
            
            UIView.animate(withDuration: 0.3) {
                settingVc.view.frame = frameVC
            }
        }
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
        terminalContainer.isHidden = true
        BluetoothService.shareInstance.scanBluetooth()
        self.rotaionVC?.stopMotion()
        self.microVC?.stopSpeaking()
    }
}

@available(iOS 10.0, *)
extension MainViewController:BluetoothCentralDelegate{

    func didConnect() {
        self.touchPadContainer.isHidden = false
        self.bluetoothContainer.isHidden = true
        self.rotationContainer.isHidden = true
        self.microphoneContainer.isHidden = true
        self.terminalContainer.isHidden = true
    }

}

@available(iOS 10.0, *)
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
            self.infoBtn.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
            self.touchPadContainer.isHidden = false
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = true
            self.terminalContainer.isHidden = true
            break
        case 1:
            self.infoBtn.setImage(#imageLiteral(resourceName: "infor"), for: .normal)
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = false
            self.microphoneContainer.isHidden = true
            self.terminalContainer.isHidden = true
            self.rotaionVC?.startMotionDetect()
            break
        case 2:
            self.infoBtn.setImage(#imageLiteral(resourceName: "infor"), for: .normal)
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = false
            self.terminalContainer.isHidden = true
            self.microVC?.startSpeaking()
            break
        case 3:
            self.infoBtn.setImage(#imageLiteral(resourceName: "infor"), for: .normal)
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = true
            self.terminalContainer.isHidden = false
            break
        default:
            break
        }
    }
    
}

@available(iOS 10.0, *)
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
