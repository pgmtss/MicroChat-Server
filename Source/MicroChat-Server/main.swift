import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let root = "./webroot"

// 配置服务器端口、根目录等
let server = HTTPServer()
server.serverPort = 8181
server.documentRoot = root

// 配置路由
let basic = RouteManager()
server.addRoutes(Routes(basic.routes))

do {
    try server.start() // 开启服务器
} catch PerfectError.networkError(let err, let msg) {
    print("Netword error thrown: \(err) \(msg)")
}
