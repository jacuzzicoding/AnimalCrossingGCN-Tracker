import Foundation
import SwiftData

enum ACGame: String, CaseIterable, Codable {
    case ACGCN = "Animal Crossing GameCube"
    case ACWW = "Animal Crossing: Wild World"
    case ACCF = "Animal Crossing: City Folk"
    case ACNL = "Animal Crossing: New Leaf"
    case ACNH = "Animal Crossing: New Horizons"
    
    var shortName: String {
        return String(describing: self)
    }
    
    var icon: String {
        switch self {
        case .ACGCN: return "gamecube"
        case .ACWW: return "ds"
        case .ACCF: return "wii"
        case .ACNL: return "3ds"
        case .ACNH: return "switch"
        }
    }
    
    var releaseYear: Int {
        switch self {
        case .ACGCN: return 2001
        case .ACWW: return 2005
        case .ACCF: return 2008
        case .ACNL: return 2012
        case .ACNH: return 2020
        }
    }
}
