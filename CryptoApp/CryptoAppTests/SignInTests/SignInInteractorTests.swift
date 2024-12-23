//
//  SignInTests.swift
//  CryptoAppTests
//
//  Created by Rockz on 10/12/24.
//

import XCTest
@testable import CryptoApp
import Nimble


final class SignInInteractorTests: XCTestCase {
    
    var interactor: SigninInteractor!
    var loginValidation: LoginValidation!
    
    override func setUpWithError() throws {
        loginValidation = LoginValidation()
        interactor = SigninInteractor(loginValidation: loginValidation)
    }
    
    override func tearDownWithError() throws {
        interactor = nil
        loginValidation = nil
        super.tearDown()
    }
    
    // Test for email validation
    func testEmailValidation() {
        //        XCTAssertTrue(loginValidation.validateEmail(with: "test@example.com"))
        //        XCTAssertFalse(loginValidation.validateEmail(with: "invalid-email"))
        //
        expect(self.loginValidation.validateEmail(with: "test@example.com")).to(beTrue());
        expect(self.loginValidation.validateEmail(with: "invalid-email")).to(beFalse())
    }
    
    // Test for password validation
    func testPasswordValidation() {
        //        XCTAssertTrue(loginValidation.isPasswordValid("Tester@1"))
        //        XCTAssertFalse(loginValidation.isPasswordValid("short"))
        //        XCTAssertFalse(loginValidation.isPasswordValid("onlylowercase"))
        
        expect(self.loginValidation.isPasswordValid("Tester@1")).to(beTrue());
        expect(self.loginValidation.isPasswordValid("short")).to(beFalse())
        expect(self.loginValidation.isPasswordValid("onlylowercase")).to(beFalse())
    }
    
    // Test for successful sign-in
    func testSignInSuccess() {
        let email = "balaji@gmail.com"
        let password = "Tester@1"
        let expectation = self.expectation(description: "SignInSuccess")
        interactor.signIn(email:email, password:password ) { result in
            //            switch result {
            //            case .success:
            //                XCTAssertTrue(true)
            //            case .failure:
            //                XCTFail("Sign-in failed with valid credentials")
            //            }
            expect(result).to(beSuccess())
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    // Test for failed sign-in
    func testSignInFailure() {
        let email = "wrong@example.com"
        let password = "wrongPass"
        let expectation = self.expectation(description: "SignInFailure")
        interactor.signIn(email:email, password:password ) { result in
            //            switch result {
            //            case .success:
            //                XCTFail("Sign-in succeeded with invalid credentials")
            //            case .failure(let error):
            //                XCTAssertEqual((error as NSError).domain, "SigninError")
            //                XCTAssertEqual((error as NSError).code, 401)
            //                XCTAssertEqual(error.localizedDescription, "Invalid email or password")
            //            }
            expect(result).to(beFailure())
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    // Test for validation errors
    func testValidationErrors() {
        interactor.validateCredentials(email: "invalid-email", password: "short") { emailError, passwordError in
            //            XCTAssertEqual(emailError, "Invalid email address", "Expected email validation error")
            //            XCTAssertEqual(passwordError, "Password must be at least 8 characters", "Expected password validation error")
            expect(emailError).to(equal("Invalid email address"), description: "Expected email validation error")
            expect(passwordError).to(equal("Password must be at least 8 characters"), description: "Expected password validation error")
        }
    }
}
