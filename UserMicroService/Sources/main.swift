//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import TurnstilePerfect


// C'est trop bon rhooo

// here I create my server
let server = HTTPServer()

// Listen on port 8181.
server.serverPort = 8181


// The Turnstile instance
let turnstile = TurnstilePerfect()

server.setRequestFilters([turnstile.requestFilter])
server.setResponseFilters([turnstile.responseFilter])

let routes = makeUrlRoutes()
server.addRoutes(routes)

print("fin")


do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

