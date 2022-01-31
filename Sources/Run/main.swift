//
// PureSwift web app
//
// A small package "registry" for sharing packages that are implementd in pure Swift.
// This provides easier search for these pakcages when working on projects that do not
// (only) involve Apple devices (e.g. projects that run on Linux or Windows, Vapor servers, 
// command line tools, scripts, ...)
// 
// © Jonas Everaert (2022)
//
// Licensed under the MIT License
// See `LICENSE` file.
//

import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
