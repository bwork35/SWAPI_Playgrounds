import UIKit

struct Person: Decodable {
    var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api")
    static let personEndpoint = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else {return completion(nil)}
        let semifinalURL = baseURL.appendingPathComponent(personEndpoint)
        let finalURL = semifinalURL.appendingPathComponent("\(id)")
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
                print("We had an error fetching our categories")
            }
            guard let data = data else {return completion(nil)}
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("We had an error decoding the data - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
                print("We had an error fetching our categories")
            }
            guard let data = data else {return completion(nil)}
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("We had an error decoding the data - \(error) - \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
}

SwapiService.fetchPerson(id: 10) { person in
  if let person = person {
    print(person)
    
    for item in person.films {
          SwapiService.fetchFilm(url: item) { film in
              if let film = film {
                print("")
                print(film)
                
              }
          }
    }
  }
}




