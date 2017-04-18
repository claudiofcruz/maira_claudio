//
//  UIViewController+CoreData.swift
//  MOB12MairaRamos_ClaudioCruz
//
//  Created by Claudio Cruz on 18/04/17.
//  Copyright © 2017 ClaudioCruz. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
