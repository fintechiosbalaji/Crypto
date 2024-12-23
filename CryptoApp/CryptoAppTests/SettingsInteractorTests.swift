//
//  SettingInteractorTests.swift
//  CryptoAppTests
//
//  Created by Rockz on 23/12/24.
//

import XCTest
@testable import CryptoApp
import Nimble

final class SettingsInteractorTests: XCTestCase {
    
    var interactor: SettingsInteractor!

    override func setUpWithError() throws {
        self.interactor = SettingsInteractor()
    }

    override func tearDownWithError() throws {
        self.interactor = nil
        super.tearDown()
    }

    func testLoadSettingsdata() throws {
        let expectedData = mockSettings
        let result = self.interactor.loadSettingsdata()
        expect(result).to(equal(expectedData))
    }
}
