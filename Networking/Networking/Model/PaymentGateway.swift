import Foundation

/// Represents a Payment Gateway.
///
public struct PaymentGateway: Equatable {

    /// Features for payment gateway.
    ///
    public enum Features: Equatable {
        case products
        case refunds
        case custom(raw: String)
    }

    /// Site identifier.
    ///
    public let siteID: Int64

    /// Gateway Identifier.
    ///
    public let gatewayID: String

    /// Title for the payment gateway.
    ///
    public let title: String

    /// Description of the payment gateway.
    ///
    public let description: String

    /// Wether the payment gateway is enabled on the site or not.
    ///
    public let enabled: Bool

    /// List of features the payment gateway supports.
    ///
    public let features: [Features]
}

// MARK: Gateway Decodable
extension PaymentGateway: Decodable {

    public enum DecodingError: Error {
        case missingSiteID
    }

    private enum CodingKeys: String, CodingKey {
        case gatewayID = "id"
        case title
        case description
        case enabled
        case features = "method_supports"

    }

    public init(from decoder: Decoder) throws {
        guard let siteID = decoder.userInfo[.siteID] as? Int64 else {
            throw DecodingError.missingSiteID
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gatewayID = try container.decode(String.self, forKey: .gatewayID)
        let title = try container.decode(String.self, forKey: .title)
        let description = try container.decode(String.self, forKey: .description)
        let enabled = try container.decode(Bool.self, forKey: .enabled)
        let features = try container.decode([Features].self, forKey: .features)

        self.init(siteID: siteID,
                  gatewayID: gatewayID,
                  title: title,
                  description: description,
                  enabled: enabled,
                  features: features)
    }
}

// MARK: Features Decodable
extension PaymentGateway.Features: RawRepresentable, Decodable {

    /// Enum containing the 'Known' Features Keys
    ///
    private enum Keys {
        static let products = "products"
        static let refunds = "refunds"
    }

    public init?(rawValue: String) {
        switch rawValue {
        case Keys.products:
            self = .products
        case Keys.refunds:
            self = .refunds
        default:
            self = .custom(raw: rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .products:
            return Keys.products
        case .refunds:
            return Keys.refunds
        case .custom(let raw):
            return raw
        }
    }
}
