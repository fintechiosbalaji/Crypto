//
//  SignInPresenterTests.swift
//  CryptoAppTests
//
//  Created by Rockz on 10/12/24.
//

import XCTest
import Combine
import Nimble
@testable import CryptoApp

final class SignInPresenterTests: XCTestCase {
    
    var presenter: SigninPresenter!
    var interactor: SigninInteractor!
    var router: SigninRouter!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        interactor = SigninInteractor(loginValidation: LoginValidation())
        router = SigninRouter()
        presenter = SigninPresenter(interactor: interactor, router: router)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        interactor = nil
        router = nil
        cancellables = nil
        super.tearDown()
    }
    
    private func createPresenter(email: String, password: String) -> SigninPresenter {
        presenter.email = email 
        presenter.password = password
        return presenter
    }
    
    func testValidation() throws {
        let presenter = createPresenter(email: "test@example.com", password: "Valid@123")
        presenter.$isValid
            .sink { isValid in
               // XCTAssertTrue(isValid)
                expect(isValid).to(beTrue())
            }
            .store(in: &cancellables)
    }
    
    func testInvalidEmailError() throws {
        let expectation = self.expectation(description: "InvalidEmailError")
        presenter.$emailError
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, "Invalid email address")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        presenter.email = "invalid-email"
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testInvalidPasswordError() throws {
        let expectation = self.expectation(description: "InvalidPasswordError")
        presenter.$passwordError
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, "Password must be at least 8 characters")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        presenter.password = "short"
        waitForExpectations(timeout: 1, handler: nil)
    }
    // Test sign-in success
    func testSignInSuccess() throws {
        presenter.email = "balaji@gmail.com"
        presenter.password = "Tester@1"
        presenter.signIn()
        
        XCTAssertEqual(presenter.loginStatus, .success)
        XCTAssertTrue(presenter.navigateToDashboard)
        XCTAssertNil(presenter.errorMessage)
    }
    
    func testSignInFailure() {
        presenter.email = "test@example.com"
        presenter.password = "balaji@1"
        presenter.isValid = true
        
        presenter.signIn()

        XCTAssertEqual(presenter.loginStatus, .failure)
        XCTAssertFalse(presenter.navigateToDashboard)
    }
}
