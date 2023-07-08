import Foundation

// Defines the structure of the API request parameters
struct APIParameters: Codable {
     let model: String
     let messages:[Message]
     let temperature: Double
     let max_tokens: Int
     let stop: [String]
     
     // Defines the structure of the message for API request
     struct Message: Codable {
         let role: String
         let content: String
     }
}

// Service to make API requests
class APIService {
    // Define the model and maximum tokens
    private let model: String = "gpt-3.5-turbo"
    private let maxTokens: Int = 500
    
    // Define custom API errors
    enum APIError: Error {
        case keyNotFound, noData, unexpectedFormat, failedToSerializeJSON
    }
    
    // Function to translate a given text based on the specified translation mode
    func translate(text: String, mode: TranslationMode, completion: @escaping (Result<String, APIError>) -> Void) {
        // Obtain API key from info dictionary, return error if not found
        guard let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            completion(.failure(.keyNotFound))
            return
        }
        
        // Headers for the API request
        let headers = ["Authorization": "Bearer \(apiKey)",
                       "Content-Type": "application/json"]
        
        // API endpoint URL
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        
        // Messages for the API request body
        let (systemMessage, userMessage) = mode.message(text: text)
        
        // Body of the API request
        let body = APIParameters(model: model, messages: [
            .init(role: "system", content: systemMessage),
            .init(role: "user", content: userMessage)
        ], temperature: 0.5, max_tokens: maxTokens, stop: ["User:", "AI:"])
        
        // Create the API request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        // Try to encode the body into JSON format, return error if failed
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(.failure(.failedToSerializeJSON))
            return
        }
        
        // Make the API request
        URLSession.shared.dataTask(with: request) { data, _, error in
            // If an error occurs, return no data error
            if let _ = error {
                completion(.failure(.noData))
                return
            }
            
            // Check for existence of data, return error if not found
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Try to decode the API response, return error if failed
            do {
                let jsonResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                // Extract the translated message, return error if not found
                guard let message = jsonResponse.choices.first?.message.content else {
                    completion(.failure(.unexpectedFormat))
                    return
                }
                
                // Return the translated message in the main queue
                DispatchQueue.main.async {
                    completion(.success(message))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
            }
        }.resume()
    }
}

// Extensions to define the structure of the API response
extension APIService {
    struct APIResponse: Codable {
        let choices: [APIChoice]
    }

    struct APIChoice: Codable {
        let message: APIMessage
    }

    struct APIMessage: Codable {
        let content: String
    }
}

// Extension to define the system and user messages based on the translation mode
extension TranslationMode {
    func message(text: String) -> (String, String) {
        switch self {
        case .formalJapanese:
            return ("You are a helpful language assistant that translates English to polite Japanese. The output should be natural, polite Japanese. Please translate the following English text to polite Japanese without Romaji: '\(text)'.", "")
        case .casualJapanese:
            return ("You are a helpful language assistant that translates English to casual, conversational Japanese. The output should be natural, informal Japanese. Please translate the following English text to casual Japanese without Romaji: '\(text)'.", "")
        case .english:
            return ("You are a helpful language assistant that translates Japanese to English. The output should be in natural English. Please translate the following Japanese text to English: '\(text)'.", "")
        }
    }
}


