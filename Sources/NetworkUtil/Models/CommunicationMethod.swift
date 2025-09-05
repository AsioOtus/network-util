import Foundation

enum CommunicationMethod {
    case data
    case uploadData(Data)
    case uploadFromFile(URL)
}
