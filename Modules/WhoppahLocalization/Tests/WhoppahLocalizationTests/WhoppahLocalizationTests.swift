import XCTest
import Resolver
@testable import WhoppahLocalization

enum TestEnum: String {
    case one
    case two
    case three
}

struct TestData: DataStoreLocalizable {
    let title: String
    let key: String
    let testEnum: TestEnum
    
    public func localize(_ path: KeyPath<Self, String>, params: String...) -> String {
        localizer.localize(path, model: self, params: params)
    }
}

extension TestData: Resolving {
    var localizer: DataStoreLocalizer<TestData> {
        resolver.resolve()
    }
}

extension TestData {
    class Localizer1: DataStoreLocalizer<TestData> {
        let prefix = "localizer1."
        
        override func localize(_ path: KeyPath<TestData, String>,
                               model: TestData,
                               params: [String]) -> String
        {
            switch path {
            case \.title:
                return "\(prefix)\(model.key)"
            case \.testEnum.rawValue:
                return "\(prefix)\(model.testEnum.rawValue)"
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
    
    class Localizer2: DataStoreLocalizer<TestData> {
        let prefix = "localizer2."
        
        override func localize(_ path: KeyPath<TestData, String>,
                               model: TestData,
                               params: [String]) -> String
        {
            switch path {
            case \.title:
                return "\(prefix)\(model.key)"
            case \.testEnum.rawValue:
                guard let firstParam = params.first else { return missingLocalization(forKey: path) }
                return "\(prefix)\(model.testEnum.rawValue)\(firstParam)"
            default:
                return missingLocalization(forKey: path)
            }
        }
    }
}

final class WhoppahLocalizationTests: XCTestCase {
    
    func testLocalizerSwitch() throws {
        let localizer1 = TestData.Localizer1()
        Resolver.register { localizer1 as DataStoreLocalizer<TestData> }
        
        let testData = TestData(title: "", key: UUID().uuidString, testEnum: .two)
        
        XCTAssertEqual(testData.localize(\.title), "\(localizer1.prefix)\(testData.key)")
        XCTAssertEqual(testData.localize(\.testEnum.rawValue), "\(localizer1.prefix)\(testData.testEnum.rawValue)")
        
        let localizer2 = TestData.Localizer2()
        Resolver.register { localizer2 as DataStoreLocalizer<TestData> }
        
        XCTAssertEqual(testData.localize(\.title), "\(localizer2.prefix)\(testData.key)")
        XCTAssertEqual(testData.localize(\.testEnum.rawValue), "")
        let param = UUID().uuidString
        XCTAssertEqual(testData.localize(\.testEnum.rawValue, params: param), "\(localizer2.prefix)\(testData.testEnum.rawValue)\(param)")
    }
}
