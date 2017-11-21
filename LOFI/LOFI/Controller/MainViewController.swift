//
//  MainViewController.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4 = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}
@available(iOS 10.0, *)
class MainViewController: UIViewController {

    @IBOutlet weak var touchPadContainer: UIView!
    @IBOutlet weak var bluetoothContainer: UIView!
    @IBOutlet weak var rotationContainer: UIView!
    @IBOutlet weak var microphoneContainer: UIView!
    @IBOutlet weak var terminalContainer: UIView!
    
    @IBOutlet weak var menuView: UIImageView!
    
    @IBOutlet weak var logoImv: UIImageView!
    
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var bluetoothVC:BluetoothScanViewController?
    var rotaionVC:RotationViewController?
    var microVC:MicrophoneViewController?
    var terminalVC:TerminalViewController?
    
    var date1:Date!
    
    var items = ["GAMEPAD","ROTAION","MICROPHONE","REMOTE"]
    var itemsTitle = ["Gamepad","Rotation","Voice control","Terminal"]
    
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
        
        self.infoBtn.setImage(#imageLiteral(resourceName: "infor"), for: .normal)
        bluetoothContainer.isHidden = true
        touchPadContainer.isHidden = true
        rotationContainer.isHidden = true
        microphoneContainer.isHidden = true
        terminalContainer.isHidden = true
        
        self.rotaionVC?.stopMotion()
        self.microVC?.stopSpeaking()
        self.terminalVC?.inputTextField.resignFirstResponder()
        self.logoImv.isHidden = false
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
        case is TerminalViewController:
            terminalVC = (destinationVC as! TerminalViewController)
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
        self.terminalVC?.inputTextField.resignFirstResponder()
        self.logoImv.isHidden = true
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
        let item  = itemsTitle[indexPath.row]
        let image = items[indexPath.row]
        itemCell.setUp(item: item, imageName: image)
        
        itemCell.itemView.tapAction = {
            self.didTapItem(index: indexPath.row)
        }
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }
    
    func didTapItem(index:Int) {
        
        self.logoImv.isHidden = true
        
        switch index {
        case 0: // tap on gamePad
            self.infoBtn.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
            self.touchPadContainer.isHidden = false
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = true
            self.terminalContainer.isHidden = true
            break
        case 1: // tap on rotation
            self.infoBtn.setImage(#imageLiteral(resourceName: "infor"), for: .normal)
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = false
            self.microphoneContainer.isHidden = true
            self.terminalContainer.isHidden = true
            self.rotaionVC?.startMotionDetect()
            break
        case 2: // tap on voice
            self.infoBtn.setImage(#imageLiteral(resourceName: "infor"), for: .normal)
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = false
            self.terminalContainer.isHidden = true
            self.microVC?.startSpeaking()
            break
        case 3: // tap on terminal
            self.infoBtn.setImage(#imageLiteral(resourceName: "infor"), for: .normal)
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = true
            self.terminalContainer.isHidden = false
            //self.terminalVC?.resetData()
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
