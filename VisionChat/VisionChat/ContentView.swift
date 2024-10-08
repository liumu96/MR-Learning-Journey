//
//  ContentView.swift
//  VisionChat
//
//  Created by liuxing on 2024/8/16.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var userInput: String = ""
    
    // API Response will be rendered here
    @State private var apiResponse: String = ""
    
    private var openApiKey: String = "sk-xxxxx"

    var body: some View {
        VStack {
            SearchBar(text: $userInput, onSearchButtonClicked: {
                sendToOpenAI(input: userInput)
            })
            
            ScrollView {
                TypewritterEffect(fullText: apiResponse, speed: 0.05)
                    .padding()
            }
        }
        .padding()
    }
    
    func sendToOpenAI(input: String) {
        // Ensure the URL is correct and safe to use
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openApiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/jaon", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body with correct parameters
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "user", "content": input]
            ]
        ]
        
        // Ensure the request's body can be encoded
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Failed to serialize body")
            return
        }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.apiResponse = "Error making request: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.apiResponse = "Error: Server returned an error status code."
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.apiResponse = "Error: No data received."
                }
                return
            }
            
            // Decode the JSON response
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(OpenAIResponse.self, from: data)
                DispatchQueue.main.async {
                    // Update the UI with the first choice's text
                    self.apiResponse = response.choices.first?.message.content ?? "No response text."
                }
            } catch {
                DispatchQueue.main.async {
                    self.apiResponse = "Error decoding response: \(error.localizedDescription)"
                }
            }
        }
        task.resume()
    }
    
    struct OpenAIResponse: Codable {
        let choices: [Choice]
    }
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
