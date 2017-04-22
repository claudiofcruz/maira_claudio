//
//  ProductViewController.swift
//  MOB12MairaRamos_ClaudioCruz
//
//  Created by Claudio Cruz on 18/04/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    
    // MARK: Properties
    
    var product: Product!
    var smallImage: UIImage!
    var dataSourceStates: [States] = []
    var pickerStates: UIPickerView!
    var stateSelected: States!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerStates = UIPickerView()
        
        pickerStates.delegate = self
        pickerStates.dataSource = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolBar.items = [btCancel,btSpace,btDone]
        
        tfState.inputView = pickerStates
        tfState.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if self.product != nil {
            
            tfName.text = product.name
            
            if product.image != nil {
                smallImage = product.image as? UIImage
                ivImage.image = smallImage
            }
            
            stateSelected = product.state
            tfState.text = stateSelected.name
            
            tfPrice.text = "\(product.price)"
            swCard.isOn = product.iscreditpaid
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
  
    @IBAction func addProduct(_ sender: UIButton) {

        if checkAllFields() {
            tfState.resignFirstResponder()

            if product == nil {
                product = Product(context: context)
            }
            
            product.name = tfName.text
            product.price = Double(tfPrice.text!.replacingOccurrences(of: ",", with: "."))!
            product.iscreditpaid = swCard.isOn
            product.state = stateSelected
            
            
          
            if smallImage != nil {
                product.image = ivImage.image
            }
            
            do {
                try context.save()
            } catch {
                print("Erro na gravação \(error.localizedDescription)")
            }
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }        
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar Imagem", message: "De onde você quer escolher ?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryAction = UIAlertAction(title: "Biblioteca", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .photoLibrary)
            }
            alert.addAction(libraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func checkAllFields() -> Bool {
        if tfName.text == "" {
            showAlert(message: "Favor informar o nome do produto!")
            return false
        }
        
        if tfState.text == "" || stateSelected == nil {
            showAlert(message: "Favor selecionar o Estado!")
            return false
        }
        
        if tfPrice.text == "" {
            showAlert(message: "Favor informa o valor!")
            return false
        }
        
        return true

    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Campo obrigatório", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startEditingStates(_ sender: UITextField) {
        
        loadStates()

        //Verifica se possui estados cadastrados no momento de iniciar a edição do tfStates, caso negativo abre a tela de settings
        if dataSourceStates.count == 0 {
            performSegue(withIdentifier: "settingsSegue", sender: nil)
        }
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSourceStates = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func cancel() {
        tfState.resignFirstResponder()
    }
    
    func done() {
        tfState.text = stateSelected.name
        cancel()
    }

}

// MARK: - extension

extension ProductViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        smallImage = image
        ivImage.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProductViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourceStates.count
    }
    
    
}

extension ProductViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSourceStates[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateSelected = dataSourceStates[row]
        tfState.text = stateSelected.name
    }
}
