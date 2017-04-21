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
    var fetchedResultController: NSFetchedResultsController<States>!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.product != nil {
            
            tfName.text = product.name
            
            if product.image != nil {
                ivImage.image = product.image as? UIImage
            }
            
            tfState.text = product.state!.name
            tfPrice.text = "\(product.price)"
            swCard.isOn = product.iscreditpaid
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    @IBAction func addProduct(_ sender: UIButton) {

        if checkAllFields() {

            if product == nil {
                product = Product(context: context)
            }
            
            
            product.name = tfName.text
            product.price = Double(tfPrice.text!)!
            product.iscreditpaid = swCard.isOn
            product.state?.name = tfState.text
            
            if smallImage != nil {
                product.image = ivImage.image
            }
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
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
        
        return false
    }
    
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startEditingStates(_ sender: UITextField) {
        
        //Verifica se possui estados cadastrados no momento de iniciar a edição do tfStates, caso negativo abre a tela de settings
        loadStates()
        if let count = fetchedResultController.fetchedObjects?.count {
            if count == 0 {
                performSegue(withIdentifier: "settingsSegue", sender: nil)
            }
        }
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - extension

extension ProductViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
//        //Como reduzir uma imagem
//        let smallSize = CGSize(width: ivImage.frame.width, height: ivImage.frame.height )
//        UIGraphicsBeginImageContext(smallSize)
//        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
//        smallImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
//        ivImage.image = smallImage
        smallImage = image
        ivImage.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProductViewController:NSFetchedResultsControllerDelegate {
    
}

