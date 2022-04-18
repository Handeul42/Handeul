//
//  FiveWords+CoreDataProperties.swift
//  kWordle
//
//  Created by 강희영 on 2022/04/18.
//
//

import Foundation
import CoreData


extension FiveWords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FiveWords> {
        return NSFetchRequest<FiveWords>(entityName: "FiveWords")
    }

    @NSManaged public var word: String?
    @NSManaged public var jamo: String?
    @NSManaged public var dict: String?

}

extension FiveWords : Identifiable {

}
