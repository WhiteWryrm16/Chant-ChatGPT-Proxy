import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

// Create a client.
let client = Client(
    serverURL: URL(string: "http://localhost:8080")!,
    transport: URLSessionTransport()
)

let userInput = CommandLine.arguments.dropFirst().first ?? "Any team!"

// Print some placeholder to the console.
setbuf(stdout, nil)  // Don't buffer stdout.
print("🧑‍💼: \(userInput)")
print("---")
print("🤖: ", terminator: "")

// Make the request.
let response = try await client.createChant(
    body: .json(.init(userInput: userInput))
)

// Decode JSON Lines into an async sequence of typed values.
let messages = try response.ok.body.applicationJsonl
    .asDecodedJSONLines(of: Components.Schemas.ChantMessage.self)

for try await message in messages {
    print(message.delta, terminator: "")
}
