//
//  PhotoEntity+CoreDataClass.swift
//  PhotosCoreData2
//
//  Created by Robert on 3/22/19.
//  Copyright © 2019 Robert. All rights reserved.
//
//

import UIKit
import CoreData

@objc(PhotoEntity)
public class PhotoEntity: NSManagedObject {

    var image: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)!
            }
            else{
                print("Could not retrive image")
            }
            return nil
        }
        set {
            rawImage = NSData( data: (newValue)!.pngData()!)
        }
    }
    
    convenience init?(name: String?, image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: PhotoEntity.entity(), insertInto: managedContext)
        self.name = name
        self.image = image
    }
}
