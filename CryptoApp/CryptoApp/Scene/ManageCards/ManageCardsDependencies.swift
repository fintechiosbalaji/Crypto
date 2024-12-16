//
//  ManageCardsDependencies.swift
//  CryptoApp
//
//  Created by Rockz on 16/11/24
//  Copyright © 2024 Rockz. All rights reserved.
//

import CoreData


// MARK: - View Dependencies

protocol ManageCardsViewDependenciesProtocol {
    
}

struct ManageCardsViewDependencies: ManageCardsViewDependenciesProtocol {
    
}

// MARK: - Presenter Dependencies
protocol ManageCardsPresenterDependenciesProtocol {
    
}

struct ManageCardsPresenterDepenencies: ManageCardsPresenterDependenciesProtocol {
    
    init() {
        
    }
}

// MARK: - Interactor Dependencies

protocol ManageCardsInteractorDependenciesProtocol {
    var context: NSManagedObjectContext { get }
}

class ManageCardsInteractorDependencies: ManageCardsInteractorDependenciesProtocol {
    let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
