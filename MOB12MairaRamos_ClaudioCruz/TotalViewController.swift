//
//  TotalViewController.swift
//  MOB12MairaRamos_ClaudioCruz
//
//  Created by Claudio Cruz on 22/04/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var lbDolar: UILabel!
    @IBOutlet weak var lbReais: UILabel!
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        var dolar = 1.00
        
        if let sDolar = UserDefaults.standard.string(forKey: "dolar") {
            dolar = Double(sDolar.replacingOccurrences(of: ",", with: "."))!
        }
        
        var iof = 1.00
        
        if let sIof = UserDefaults.standard.string(forKey: "iof") {
            iof = 1 + (Double(sIof.replacingOccurrences(of: ",", with: "."))!/100)
        }
        
        var totalReais = 0.00
        var totalUSD   = 0.00
        
        
        for product in appDelegate.productList {
            
            //Totalizador em USD
            totalUSD += product.price
            
            var totProduct = product.price
            
            //Adiciona IOF caso pago em Cartão de Crédito
            if product.iscreditpaid {
                totProduct = totProduct * iof
            }
            
            //Adiciona o imposto do estado da compra do produto
            let tax = 1 + ((product.state?.tax)! / 100)
            
            totProduct = totProduct * tax
            
            //Converte o valor do produto De Trump's para Temer's ops.. Reais
            totProduct = totProduct * dolar
            totalReais += totProduct
        }
        
        lbDolar.text = formatCurrency(value: totalUSD, format: "en_US")
        lbReais.text = formatCurrency(value: totalReais, format: "pt_BR")

    }
    
    func formatCurrency(value: Double, format: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: format)
        return formatter.string(from: NSNumber(floatLiteral: value))!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods

    func loadProducts() {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
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

// MARK: - Extensions
extension TotalViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}

