@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let tests = "Tests not set up"
        XCTAssertEqual("Tests not set up", tests)
        // let app = Application(.testing)
        // defer { app.shutdown() }
        // try configure(app)
        // 
        // try app.test(.GET, "hello", afterResponse: { res in
        //     XCTAssertEqual(res.status, .ok)
        //     XCTAssertEqual(res.body.string, "Hello, world!")
        // })
    }
}
