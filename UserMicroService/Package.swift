// Generated automatically by Perfect Assistant Application
// Date: 2017-03-31 19:43:48 +0000
import PackageDescription
let package = Package(
    name: "UserMicroService",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Redis.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", majorVersion: 2),
        .Package(url: "https://github.com/stormpath/Turnstile-Perfect.git", majorVersion:1)
    ]
)
