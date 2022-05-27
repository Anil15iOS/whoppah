import XCTest
import Resolver
import WhoppahCoreNext
import WhoppahModel
import Combine

@testable import WhoppahDataStore

final class AuthenticationTests: WhoppahDataStoreTestBase {
    
    private var cancellables = Set<AnyCancellable>()
    private static let validEmail = "dennis+10@whoppah.com"
    private static let validPassword = "$Es3wrsepcNN"
    private let invalidEmail = "\(UUID().uuidString)" + validEmail
    private let invalidPassword = "\(UUID().uuidString)" + validPassword
    
    override func setUp() {
        super.setUp()
    }
    
//    func testValidCredentialsLogin() throws {
//        let expectation = self.expectation(description: "")
//        
//        let repo = ApolloAuthRepository()
//        
//        repo.signIn(method: .email,
//                    token: nil,
//                    email: AuthenticationTests.validEmail,
//                    password: AuthenticationTests.validPassword)
//            .sink { result in
//                switch result {
//                case .failure(let error):
//                    XCTFail(error.localizedDescription)
//                case .finished:
//                    break
//                }
//            } receiveValue: { token in
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: defaultTimeout)
//    }
//    
//    func testInvalidEmailLogin() throws {
//        let expectation = self.expectation(description: "")
//        
//        let repo = ApolloAuthRepository()
//        
//        repo.signIn(method: .email,
//                    token: nil,
//                    email: invalidEmail,
//                    password: AuthenticationTests.validPassword)
//            .sink { result in
//                switch result {
//                case .failure:
//                    expectation.fulfill()
//                case .finished:
//                    break
//                }
//            } receiveValue: { token in
//                XCTFail()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: defaultTimeout)
//    }
//    
//    func testInvalidPasswordLogin() throws {
//        let expectation = self.expectation(description: "")
//        
//        let repo = ApolloAuthRepository()
//        
//        repo.signIn(method: .email,
//                    token: nil,
//                    email: AuthenticationTests.validEmail,
//                    password: invalidPassword)
//            .sink { result in
//                switch result {
//                case .failure:
//                    expectation.fulfill()
//                case .finished:
//                    break
//                }
//            } receiveValue: { token in
//                XCTFail()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: defaultTimeout)
//    }
//    
//    func testInvalidEmailAndPasswordLogin() throws {
//        let expectation = self.expectation(description: "")
//        
//        let repo = ApolloAuthRepository()
//        
//        repo.signIn(method: .email,
//                    token: nil,
//                    email: invalidEmail,
//                    password: invalidPassword)
//            .sink { result in
//                switch result {
//                case .failure:
//                    expectation.fulfill()
//                case .finished:
//                    break
//                }
//            } receiveValue: { token in
//                XCTFail()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: defaultTimeout)
//    }
}
