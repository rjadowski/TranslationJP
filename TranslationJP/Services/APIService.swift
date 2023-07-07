import Foundation

class APIService {
    private var model: String = "gpt-3.5-turbo"
    private var maxTokens: Int = 500
    
    func translate(text: String, mode: TranslationMode, completion: @escaping (String?, Error?) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key not found"]))
            return
        }
        
        let headers = ["Authorization": "Bearer \(apiKey)",
                       "Content-Type": "application/json"]
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        let (systemMessage, userMessage) = mode.message(text: text)
        
        let body: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": systemMessage],
                ["role": "user", "content": userMessage]
            ],
            "temperature": 0.7,
            "max_tokens": maxTokens,
            "stop": ["User:", "AI:"]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        do {
            guard let bodyData = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed) else {
                completion(nil, NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON body"]))
                return
            }
            
            request.httpBody = bodyData
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                    return
                }
                
                do {
                    let jsonResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    guard let message = jsonResponse.choices.first?.message.content else {
                        completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"]))
                        return
                    }
                    
                    completion(message, nil)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        }
    }
}

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

extension TranslationMode {
    func message(text: String) -> (String, String) {
        switch self {
        case .formalJapanese:
            return ("You are a helpful language assistant that translates English to formal Japanese. You can only output Japanese characters. The output should be natural Japanese",
                "Write the following English text in formal Japanese without Romaji: '\(text)'. The format should be: xxxxx. Do not include Romaji")
        case .casualJapanese:
            return ("You are a helpful language assistant that translates English to friendly, casual Japanese. You can only output Japanese characters. The output should be expressive, natural Japanese",
                "Write the following English text in casual and friendly Japanese without Romaji: '\(text)'. The format should be: xxxxx. Do not include Romaji")
        case .english:
            return ("You are a helpful language assistant that translates Japanese to English. The output should be in natural English",
                "Write the following Japanese text in English: '\(text)'. Do not include any other information, simply the translation.")
        }
    }
}
