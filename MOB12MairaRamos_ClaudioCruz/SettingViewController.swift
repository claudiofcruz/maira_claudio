//
//  SettingViewController.swift
//  MOB12MairaRamos_ClaudioCruz
//
//  Created by Claudio Cruz on 21/04/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit
import CoreData

class SettingViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tvStates: UITableView!
    
    
    // MARK: - Properties
    
    var dataSource: [States] = []
    var label: UILabel!
    enum StateAlertType {
        case add
        case edit
    }
    
    var nameField: Bool = false
    var taxField: Bool = false
    
    weak var actionToEnable : UIAlertAction?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tvStates.estimatedRowHeight = 106
        tvStates.rowHeight = UITableViewAutomaticDimension
        label = UILabel(frame: CGRect(x: tvStates.frame.origin.x,
                                      y: tvStates.frame.origin.y,
                                      width: tvStates.frame.width,
                                      height: tvStates.frame.height))
        label.text = "Lista de estados vazia"
        label.textAlignment = .center
        label.textColor = .black
        
        tvStates.backgroundView = label
        
        self.loadStates();
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
        self.becomeFirstResponder()
    }
    
   
    @IBAction func changeDolar(_ sender: UITextField) {
        
        UserDefaults.standard.set(tfDolar.text, forKey: "dolar")
        sender.resignFirstResponder()

    }
    
    @IBAction func changeIOF(_ sender: UITextField) {

        UserDefaults.standard.set(tfIOF.text, forKey: "iof")
        sender.resignFirstResponder()
        
    }
    
    
    @IBAction func addState(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tvStates.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: StateAlertType, state: States?) {
        let title = (type == .add) ? "Adicionar " : "Editar "
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
            
            //Invoke method to validate alert field
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }

        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            textField.keyboardType = .decimalPad
            
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
            
            //Invoke method to validate alert field
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: { (_) -> Void in
            
        })
        
        let action = UIAlertAction(title: title, style: .default, handler:{ (_) -> Void in
            let state = state ?? States(context: self.context)
            
            state.name = alert.textFields?.first?.text
            
            if let tax = Double(String(alert.textFields![1].text!).replacingOccurrences(of: ",", with: ".")){
                state.tax = tax
            }
            
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        self.actionToEnable = action
        action.isEnabled = false
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Method to validate alert field content
    func textChanged(_ sender:UITextField) {
        if sender.placeholder == "Nome do estado" {
            nameField = (sender.text?.characters.count)! > 0
        } else {
            taxField = (sender.text?.characters.count)! > 0
        }
        
        self.actionToEnable?.isEnabled  = (nameField && taxField)
    }
}

// MARK: - Extension

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = (dataSource.count == 0) ? label : nil
        return dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellState", for: indexPath)
        
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let editState = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, state: editState)
        }
        editAction.backgroundColor = .blue
        
        return [editAction, deleteAction]
    }
}
