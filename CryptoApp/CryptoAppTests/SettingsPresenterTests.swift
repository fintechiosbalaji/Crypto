//
//  SettingsPresenterTests.swift
//  CryptoAppTests
//
//  Created by Rockz on 23/12/24.
//

import XCTest
@testable import CryptoApp
import Nimble
import Combine

class MockSettingsInteractor: SettingsInteractorProtocol {
    func loadSettingsdata() -> [SettingsSection] {
        return mockSettings
    }
}

final class SettingsPresenterTests: XCTestCase {
    
    var presenter: SettingsPresenter!
    var interactor: MockSettingsInteractor!
    var router: SettingsRouter!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        self.interactor = MockSettingsInteractor()
        self.router = SettingsRouter()
        self.presenter = SettingsPresenter(interactor: interactor, router: router)
    }
    
    override func tearDownWithError() throws {
        self.presenter = nil
        interactor = nil
        router = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testExample() throws {
        self.presenter.loadSettings()
        
        self.presenter.$settingsSections
            .sink {  sections in
                expect(sections).to(equal(self.interactor.loadSettingsdata()))
            }
            .store(in: &self.cancellables)
    }
}
