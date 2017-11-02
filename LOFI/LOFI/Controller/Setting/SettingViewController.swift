//
//  SettingViewController.swift
//  LOFI
//
//  Created by TuanNM on 11/2/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    
    var defaultValues = ["LEFT","RIGHT","UP","DOWN"]
    var keys = [MOVE_LEFT,MOVE_RIGHT,MOVE_UP,MOVE_DOWN]
    
    @IBOutlet weak var blueView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
        blueView.isUserInteractionEnabled = true
        blueView.addGestureRecognizer(tapGes)
        
    }
    
    @objc func tapAction(){
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension SettingViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultValues.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        let key = keys[indexPath.row]
        let value = defaultValues[indexPath.row]
        
        cell.setData(value: value, keyword: key)

        return cell
    }
    
}
