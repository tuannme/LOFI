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
    
    @IBOutlet weak var lofiLb: UILabel!
    
    @IBOutlet weak var gamePadView: ButtonMenuView!
    @IBOutlet weak var rotationView: ButtonMenuView!
    @IBOutlet weak var microPhoneView: ButtonMenuView!
    
    var bluetoothVC:BluetoothScanViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.didTapLofi))
        lofiLb.isUserInteractionEnabled = true
        lofiLb.addGestureRecognizer(tapGes)
        
        gamePadView.tapAction = {
            self.touchPadContainer.isHidden = false
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = true
        }
        rotationView.tapAction = {
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = false
            self.microphoneContainer.isHidden = true
        }
        
        microPhoneView.tapAction = {
            self.touchPadContainer.isHidden = true
            self.bluetoothContainer.isHidden = true
            self.rotationContainer.isHidden = true
            self.microphoneContainer.isHidden = false
        }
    }
    @objc func didTapLofi() {
        UIView.animate(withDuration: 0.1, animations: {
            self.lofiLb.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (done) in
            self.lofiLb.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        bluetoothContainer.isHidden = true
        touchPadContainer.isHidden = true
        rotationContainer.isHidden = true
        microphoneContainer.isHidden = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inforAction(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bluetoothSegue"{
            if let _bluetoothVC = segue.destination as? BluetoothScanViewController{
                bluetoothVC = _bluetoothVC
            }
        }
    }
    
    @IBAction func bluetoothAction(_ sender: Any) {
        bluetoothContainer.isHidden = false
        touchPadContainer.isHidden = true
        rotationContainer.isHidden = true
        microphoneContainer.isHidden = true
        bluetoothVC?.scanBluetooth()

    }
    
    
}
