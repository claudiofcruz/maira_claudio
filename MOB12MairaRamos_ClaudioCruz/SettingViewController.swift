//
//  SettingViewController.swift
//  MOB12MairaRamos_ClaudioCruz
//
//  Created by Claudio Cruz on 21/04/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfDolar.delegate = self
        tfIOF.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tfDolar.text = UserDefaults.standard.string(forKey: "dolar")
        tfIOF.text = UserDefaults.standard.string(forKey: "iof")
    }
    
    // MARK: - Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    
    @IBAction func changeDolar(_ sender: UITextField) {
        
        UserDefaults.standard.set(tfDolar.text, forKey: "dolar")
        sender.resignFirstResponder()

    }
    
    @IBAction func changeIOF(_ sender: UITextField) {

        UserDefaults.standard.set(tfIOF.text, forKey: "iof")
        sender.resignFirstResponder()
        
    }
}

extension SettingViewController:UITextFieldDelegate{
}
