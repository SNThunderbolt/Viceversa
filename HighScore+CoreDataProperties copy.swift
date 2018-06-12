//
//  HighScore+CoreDataProperties.swift
//  
//
//  Created by NouriMac on 6/3/18.
//
//

import Foundation
import CoreData


extension HighScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HighScore> {
        return NSFetchRequest<HighScore>(entityName: "HighScore")
    }

    @NSManaged public var highScoreValue: Int32

}
