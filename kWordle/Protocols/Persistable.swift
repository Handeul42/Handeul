//
//  Persistable.swift
//  한들
//
//  Created by JaemooJung on 2022/04/26.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
