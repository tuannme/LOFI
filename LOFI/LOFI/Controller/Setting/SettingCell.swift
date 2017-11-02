//
//  SettingCell.swift
//  LOFI
//
//  Created by TuanNM on 11/2/17.
//  Copyright © 2017 Nguyen Manh Tuan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SettingCell: UITableViewCell {

    @IBOutlet weak var actionLb: UILabel!
    @IBOutlet weak var formTv: IQTextView!
    @IBOutlet weak var switchBt: UISwitch!
    
    private var key:String!
    private var defaulfValue:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formTv.isEditable = switchBt.isOn
        formTv.delegate = self
    }

    @IBAction func switchChangedAction(_ sender: Any) {
        formTv.isEditable = switchBt.isOn
        if !switchBt.isOn{
            formTv.text = defaulfValue
            // show keyboard
        }
    }
    
    func setData(value:String,keyword:String){
        self.key = keyword
        self.defaulfValue = value
        
        self.actionLb.text = keyword
    
        if let customValue = UserDefaults.standard.object(forKey: key) as? String{
            formTv.text = customValue
        }else{
            formTv.text = defaulfValue
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension SettingCell: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let value = textView.text{
            if value.characters.count > 0 {
                UserDefaults.standard.set(value, forKey: key)
            }
        }
    }
}
