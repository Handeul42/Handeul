//
//  Persistable.swift
//  한들
//
//  Created by JaemooJung on 2022/04/26.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype PersistedObject: RealmSwift.Object
    init(persistedObject: PersistedObject)
    func persistedObject() -> PersistedObject
}
