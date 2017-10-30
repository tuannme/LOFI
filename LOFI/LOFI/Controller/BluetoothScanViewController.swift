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

    let BLEService = "dfb0"
    let BLECharacteristic  = "dfb1"
    let SAMPLE_SERVICE = "00000000-0000-0000-0000-000000000001"
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var scanLb: UILabel!
    
    var manager:CBCentralManager!
    var mainPeripheral:CBPeripheral?
    var mainCharacteristic:CBCharacteristic?
    
    var peripherals:[CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func scanBluetooth(){
        
        print("START SCANING")
        peripherals.removeAll()
        manager.scanForPeripherals(withServices:nil, options: nil)
        displayRobots()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.stopScan(sender:)), userInfo:nil , repeats: false)
        
    }
    
    @objc func stopScan(sender:Any){
        if let timer = sender as? Timer{
            timer.invalidate()
            manager.stopScan()
        }
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

extension BluetoothScanViewController:CBCentralManagerDelegate{
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connect to \(peripheral.name)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected \(peripheral.name)")
        peripheral.delegate = nil
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("can not connect to \(peripheral.name)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral){
            peripherals.append(peripheral)
            print("didDiscover \(peripheral.name)")
        }
        
        
        
        tbView.reloadData()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let stateStr = ["Unknown", "Resetting", "Unsupported",
                        "Unauthorized", "PoweredOff", "PoweredOn"]
        
        print("Manager State \(stateStr[central.state.rawValue])")
        
    }
    
}

extension BluetoothScanViewController:CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else{return}
        for service in services{
            /* Device Information Service */
            if service.uuid.isEqual(CBUUID(string: "180A")){
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            /* GAP (Generic Access Profile) for Device Name */
            if service.uuid.isEqual(CBUUID(string: CBUUIDCharacteristicUserDescriptionString)){
                peripheral.discoverCharacteristics(nil, for: service)
            }//CBUUIDGenericAccessProfileString
            
            /* Bluno Service */
            if service.uuid.isEqual(CBUUID(string: BLEService)){
                peripheral.discoverCharacteristics(nil, for: service)
            }

        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if service.uuid.isEqual(CBUUID(string: "180A")){
            guard let characteristics = service.characteristics else{return}
            for char in characteristics{
                if char.uuid.isEqual(CBUUID(string: "2A29")){
                    peripheral.readValue(for: char)
                    print("Found a Device Manufacturer Name Characteristic")
                }else if char.uuid.isEqual(CBUUID(string: "2A23")){
                    peripheral.readValue(for: char)
                    print("Found a Device Manufacturer Name Characteristic")
                }
            }
        }
        
        if service.uuid.isEqual(CBUUID(string: CBUUIDCharacteristicUserDescriptionString)){
            guard let characteristics = service.characteristics else{return}
            for char in characteristics{
                if char.uuid.isEqual(CBUUID(string: CBUUIDCharacteristicUserDescriptionString)){
                    peripheral.readValue(for: char)
                    print("Found a Device Name Characteristic")
                }
            }
        }
        
        if service.uuid.isEqual(CBUUID(string: BLEService)){
            guard let characteristics = service.characteristics else{return}
            for char in characteristics{
                if char.uuid.isEqual(CBUUID(string: BLECharacteristic)){
                    peripheral.setNotifyValue(true, for: char)
                    print("Found Bluno DATA Characteristic")
                }
            }
        }
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let value = characteristic.value else{return}
        
        switch characteristic.uuid {
        case CBUUID(string: CBUUIDCharacteristicUserDescriptionString):/* Value for device Name received */
            let deviceName = String(data: value, encoding: String.Encoding.utf8)
            print("device name :\(deviceName)")
            break
        case CBUUID(string: "2A29"):/* Value for manufacturer name received */
            let manufacturer = String(data: value, encoding: String.Encoding.utf8)
            print("Manufacturer name :\(manufacturer)")
            break
        case CBUUID(string: "2A23"): /* Value for manufacturer name received */
            let systemID = String(data: value, encoding: String.Encoding.utf8)
            print("System ID :\(systemID)")
            break
        case CBUUID(string: BLECharacteristic):/* Data received */
            let data = String(data: value, encoding: String.Encoding.utf8)
            print("Received Data :\(data)")
            break
        default:
            break
        }
        
    }
    
}

extension BluetoothScanViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peripheral = peripherals[indexPath.row]
        let cell = tbView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.textColor = UIColor.white
        if let peripheralName = peripheral.name{
            cell?.textLabel?.text = peripheralName
        }else{
            cell?.textLabel?.text = peripheral.identifier.uuidString
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tbView.deselectRow(at: indexPath, animated: true)
    }
}
