//
//  NeedsDependency.swift
//  Finda
//

import Foundation
import Coordinator

//    Protocol you need to apply to all the Coordinators,
//    so the new `dependencies` value is propagated down
protocol NeedsDependency: class {
    var dependencies: AppDependency? { get set }
}

extension NeedsDependency where Self: Coordinating {
    func updateChildCoordinatorDependencies() {
        self.childCoordinators.forEach { (_, coordinator) in
            if let c = coordinator as? NeedsDependency {
                c.dependencies = dependencies
            }
        }
    }
}
