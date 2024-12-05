import SwiftUI

struct ContentView: View {
    @State private var resources: [Resource] = [] // Stores API response
    @State private var isLoading = false         // Tracks loading state
    @State private var errorMessage: String?     // Error handling
    
    let url = URL(string: "http://127.0.0.1:8000/resources")! // Replace with your server URL
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: fetchResources) {
                Text(isLoading ? "Loading..." : "Fetch Data")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isLoading ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isLoading)
            
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if resources.isEmpty && !isLoading {
                Text("No data loaded yet.")
                    .foregroundColor(.gray)
            } else {
                List(resources) { resource in
                    Text(resource.message)
                }
            }
        }
        .padding()
    }
    
    func fetchResources() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Call the API and decode the response
                let fetchedResources = try await getResource(from: url)
                DispatchQueue.main.async {
                    resources = fetchedResources // You can modify this for multiple resources
                    isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
