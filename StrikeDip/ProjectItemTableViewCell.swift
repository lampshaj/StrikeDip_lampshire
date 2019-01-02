//
//  ProjectItemTableViewCell.swift
//  StrikeDip
//
//  Created by Aaron Lampshire on 12/8/17.
//  Copyright © 2017 Aaron Lampshire. All rights reserved.
//

import UIKit

class ProjectItemTableViewCell: UITableViewCell, UITextFieldDelegate {
//    @IBOutlet weak var titleTextField:UITextField!
//    weak var toDoItem:ToDoItem!
    @IBOutlet weak var titleTextField:UITextField!
    weak var projectItem:ProjectItem!
    let white = UIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        projectItem.title = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
