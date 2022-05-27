import XCTest
import Resolver
import WhoppahCoreNext
import WhoppahModel

@testable import WhoppahDataStore

class MockUserProvider: UserProviding {}

struct TestAppConfigurationProvider: AppConfigurationProvider {
    var environment: AppEnvironment {
        AppEnvironment("Testing",
                       host: "https://gateway.testing.whoppah.com",
                       authHost: "https://dashboard.testing.whoppah.com",
                       graphHost: "https://gateway.testing.whoppah.com",
                       mediaHost: "https://gateway.testing.whoppah.com",
                       version: "v1")
    }
}

class WhoppahDataStoreTestBase: XCTestCase {
    var defaultTimeout: TimeInterval = 4
    
    override func setUp() {
        Resolver.registerWhoppahDataStoreServices()
        Resolver.register { MockUserProvider() as UserProviding }
        Resolver.register { TestAppConfigurationProvider() as AppConfigurationProvider }
        Resolver.register { ConsoleCrashReporter() as CrashReporter }
        Resolver.register { InAppNotifier() }
    }
}
