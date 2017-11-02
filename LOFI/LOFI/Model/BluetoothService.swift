//
//  BluetoothService.swift
//  LOFI
//
//  Created by Nguyen Manh Tuan on 11/1/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BluetoothCentralDelegate:class{
    func didConnect()
}

protocol BluetoothPeripheralDelegate:class {
    func didDiscoveryPeripheral()
}

class BluetoothService: NSObject {

    static let shareInstance:BluetoothService = {
        let instance = BluetoothService()
        instance.startBluetoothService()
        return instance
    }()
    
    var mPeripheral:CBPeripheral?
    var mCharacteristics:[CBCharacteristic]?
    
    let BLEService = "FFE0"
    let BLECharacteristic  = "FFE1"
    var password:String?
    
    weak var bluetoothCentralDelegate:BluetoothCentralDelegate?
    weak var bluetoothPeripheralDelegate:BluetoothPeripheralDelegate?
    
    var manager:CBCentralManager!
    var peripherals:[CBPeripheral] = []
    
    func startBluetoothService()  {
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanBluetooth(){
        print("START SCANING")
        self.peripherals.removeAll()
        self.manager.scanForPeripherals(withServices:nil, options: nil)
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.stopScan(sender:)), userInfo:nil , repeats: false)
    }
    
    @objc func stopScan(sender:Any){
        if let timer = sender as? Timer{
            timer.invalidate()
            manager.stopScan()
        }
    }
    
    func sendDirection(direction:Direction)  {
        
        if let message = Utils.directionToString(direction: direction){
            
            guard let peripheral = mPeripheral else{return}
            guard let characteristic = mCharacteristics?.last else{return}
            
            self.sendData(message: message, peripheral: peripheral, characteristic: characteristic)
        }
    }
    
    func sendData(message:String,peripheral:CBPeripheral,characteristic:CBCharacteristic){
        if let messageData = message.data(using: .utf8){
            peripheral.writeValue(messageData, for: characteristic, type: .withoutResponse)
        }
    }
    
}

extension BluetoothService:CBCentralManagerDelegate{
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        mPeripheral = peripheral
        self.bluetoothCentralDelegate?.didConnect()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        let alertVC = UIAlertController(title: "Disconnect", message: "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (done) in
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
        peripheral.delegate = nil
        mPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        //print("can not connect to \(peripheral.name)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !self.peripherals.contains(peripheral){
            self.peripherals.append(peripheral)
            self.bluetoothPeripheralDelegate?.didDiscoveryPeripheral()
            print("didDiscover \(String(describing: peripheral.name))")
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let stateStr = ["Unknown", "Resetting", "Unsupported",
                        "Unauthorized", "PoweredOff", "PoweredOn"]
        
        print("Manager State \(stateStr[central.state.rawValue])")
        
    }
    
}

extension BluetoothService:CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let services = peripheral.services else{return}
        for service in services{
            /* Bluno Service */
            if service.uuid.isEqual(CBUUID(string: BLEService)){
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        
        if service.uuid.isEqual(CBUUID(string: BLEService)){
            guard let characteristics = service.characteristics else{return}
            for char in characteristics{
                if char.uuid.isEqual(CBUUID(string: BLECharacteristic)){
                    peripheral.setNotifyValue(true, for: char)
                    print("Found Bluno DATA Characteristic")
                    
                }
            }
            mCharacteristics = characteristics
        }
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let value = characteristic.value else{return}
        
        switch characteristic.uuid {
        case CBUUID(string: BLECharacteristic):/* Data received */
            let data = String(data: value, encoding: String.Encoding.utf8)
            
            var peripheralName = ""
            
            if let name = peripheral.name{
                peripheralName = name
            }else{
                peripheralName = peripheral.identifier.uuidString
            }
            

            let alert = UIAlertView(title: "message from \(peripheralName)", message: data, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
 
           /*
            let alertVC = UIAlertController(title: "message from \(peripheralName)", message: data, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
            
            if let messageData = password?.data(using: .utf8){
                peripheral.writeValue(messageData, for: characteristic, type: .withoutResponse)
            }
            */
            
            print("Received Data :\(String(describing: data))")
            break
        default:
            break
        }
        
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheralDidUpdateName ")
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("toSendWriteWithoutResponse ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("didReadRSSI ")
    }
    
    @available(iOS 11.0, *)
    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        print("didOpen ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("didModifyServices ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("didWriteValueFor ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print("didUpdateValueFor ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        print("didDiscoverIncludedServicesFor ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didWriteValueFor ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("didDiscoverDescriptorsFor ")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor ")
    }
    
    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        print("peripheralDidUpdateRSSI ")
    }
    
    
}
