//
//  BluetoothScanViewController.swift
//  LOFI
//
//  Created by TuanNM on 10/30/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import CoreBluetooth


class BluetoothScanViewController: UIViewController {


    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var scanLb: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        BluetoothService.shareInstance.bluetoothPeripheralDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    @objc func displayRobots(){
        tbView.isHidden = false
        tbView.alpha = 0
        tbView.reloadData()
        
        UIView.animate(withDuration: 0.2) {
            self.tbView.alpha = 1
            self.blueView.alpha = 0
            self.scanLb.alpha = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension BluetoothScanViewController:BluetoothPeripheralDelegate{
    func didDiscoveryPeripheral() {
        self.displayRobots()
    }
}


extension BluetoothScanViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BluetoothService.shareInstance.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peripheral = BluetoothService.shareInstance.peripherals[indexPath.row]
        let cell = tbView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.textColor = UIColor.white
        if let peripheralName = peripheral.name{
            cell?.textLabel?.text = peripheralName
        }else{
            cell?.textLabel?.text = peripheral.identifier.uuidString
        }
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = UIColor.orange
        cell?.backgroundColor = UIColor.white
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let inputPass = UIAlertController(title: "Enter password", message: "", preferredStyle: .alert)
        inputPass.addTextField { (textField) in
            textField.placeholder = "enter here"
        }
        
        inputPass.addAction(UIAlertAction(title: "OK", style: .default, handler: { (done) in
            guard let textField = inputPass.textFields?.last else{return}
            BluetoothService.shareInstance.password = textField.text
            let peripheral = BluetoothService.shareInstance.peripherals[indexPath.row]
            BluetoothService.shareInstance.manager.connect(peripheral, options: nil)
        }))
        
        self.present(inputPass, animated: true, completion: nil)
        
        tbView.deselectRow(at: indexPath, animated: true)
    }
}
