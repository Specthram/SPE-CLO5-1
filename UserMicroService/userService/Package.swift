// Generated automatically by Perfect Assistant Application
// Date: 2017-04-04 10:12:46 +0000
import PackageDescription
let package = Package(
    name: "UserMicroService",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Redis.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", majorVersion: 2),
        .Package(url: "https://github.com/stormpath/Turnstile-Perfect.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 1),
    ]
)