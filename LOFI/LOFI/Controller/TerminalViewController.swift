//
//  TerminalViewController.swift
//  LOFI
//
//  Created by Nguyen Manh Tuan on 11/9/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

class TerminalViewController: UIViewController {

    
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendBnt: UIButton!
    var arrTerminals:[String] = []
    
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendBnt.layer.cornerRadius = 10
        sendBnt.clipsToBounds = true
        
        inputTextField.layer.borderWidth = 2
        inputTextField.layer.borderColor = UIColor.orange.cgColor
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        inputTextField.leftViewMode = .always
        
        if UIDevice().screenType == .iPhones_5_5s_5c_SE{
            topSpaceConstraint.constant = 75
            inputViewHeightConstraint.constant = 28
        }
        
        BluetoothService.shareInstance.bluetoothDatadelegate = self
        
    }
    func resetData() {
        arrTerminals.removeAll()
        tbView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAction(_ sender: Any) {
        guard let message = inputTextField.text else{return}
        if message.count > 0 {
            BluetoothService.shareInstance.sendMessage(message: message)
            inputTextField.text = ""
        }
    }

}

extension TerminalViewController:BluetoothDataDelegate{
    func didReceiveData(data: String) {
        arrTerminals.insert(data, at: 0)
        tbView.reloadData()
    }
}



extension TerminalViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if UIDevice().screenType == .iPhones_5_5s_5c_SE{
            return 40
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTerminals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(111) as! UILabel
        label.text = arrTerminals[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice().screenType == .iPhones_5_5s_5c_SE{
            return 20
        }
        return 30
    }
    
}
