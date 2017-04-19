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
    
}

// MARK: - extension

extension ProductViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //Como reduzir uma imagem
        let smallSize = CGSize(width: 300, height: 280  )
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivImage.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }

}

