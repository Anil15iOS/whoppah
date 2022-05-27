// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// GraphQL namespace
public extension GraphQL {
  final class TrackEventMutation: GraphQLMutation {
    /// The raw GraphQL definition of this operation.
    public let operationDefinition: String =
      """
      mutation trackEvent($entity: Entity, $id: UUID!, $event: Event) {
        trackEvent(entity: $entity, id: $id, event: $event)
      }
      """

    public let operationName: String = "trackEvent"

    public var entity: Entity?
    public var id: UUID
    public var event: Event?

    public init(entity: Entity? = nil, id: UUID, event: Event? = nil) {
      self.entity = entity
      self.id = id
      self.event = event
    }

    public var variables: GraphQLMap? {
      return ["entity": entity, "id": id, "event": event]
    }

    public struct Data: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Mutation"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("trackEvent", arguments: ["entity": GraphQLVariable("entity"), "id": GraphQLVariable("id"), "event": GraphQLVariable("event")], type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(trackEvent: Bool) {
        self.init(unsafeResultMap: ["__typename": "Mutation", "trackEvent": trackEvent])
      }

      public var trackEvent: Bool {
        get {
          return resultMap["trackEvent"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "trackEvent")
        }
      }
    }
  }
}
