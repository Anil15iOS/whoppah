//
//  Bid+Conversion.swift
//  
//
//  Created by Marko Stojkovic on 12.4.22..
//

import Foundation
import WhoppahModel

extension GraphQL.RejectBidMutation.Data.RejectBid: WhoppahModelConvertable {
  var toWhoppahModel: Bid {
      
      let bid = Bid(id: self.id,
                    auction: self.auction.id,
                    buyer: UUID(),
                    merchant: UUID(),
                    state: self.state.toWhoppahModel,
                    order: nil,
                    created: Date(),
                    expiryDate: Date(),
                    endDate: Date(),
                    amount: self.amount.toWhoppahModel,
                    isCounter: false,
                    thread: nil)
      
      return bid
  }
}

extension GraphQL.AcceptBidMutation.Data.AcceptBid: WhoppahModelConvertable {
  var toWhoppahModel: Bid {
      
      let bid = Bid(id: self.id,
                    auction: self.auction.id,
                    buyer: UUID(),
                    merchant: UUID(),
                    state: self.state.toWhoppahModel,
                    order: nil,
                    created: Date(),
                    expiryDate: Date(),
                    endDate: Date(),
                    amount: self.amount.toWhoppahModel,
                    isCounter: false,
                    thread: nil)
      
      return bid
  }
}

extension GraphQL.CreateBidMutation.Data.CreateBid: WhoppahModelConvertable {
  var toWhoppahModel: Bid {
      
      let bid = Bid(id: self.id,
                    auction: self.auction.id,
                    buyer: self.buyer.id,
                    merchant: UUID(),
                    state: self.state.toWhoppahModel,
                    order: nil,
                    created: Date(),
                    expiryDate: Date(),
                    endDate: Date(),
                    amount: self.amount.toWhoppahModel,
                    isCounter: false,
                    thread: self.thread?.id)
      
      return bid
  }
}

extension GraphQL.CreateCounterBidMutation.Data.CreateCounterBid: WhoppahModelConvertable {
  var toWhoppahModel: Bid {
      
      let bid = Bid(id: self.id,
                    auction: self.auction.id,
                    buyer: self.buyer.id,
                    merchant: UUID(),
                    state: self.state.toWhoppahModel,
                    order: nil,
                    created: Date(),
                    expiryDate: Date(),
                    endDate: Date(),
                    amount: self.amount.toWhoppahModel,
                    isCounter: false,
                    thread: nil)
      
      return bid
  }
}

extension GraphQL.AcceptBidMutation.Data.AcceptBid.Amount {
    var toWhoppahModel: Price {
        
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.RejectBidMutation.Data.RejectBid.Amount {
    var toWhoppahModel: Price {
        
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.CreateCounterBidMutation.Data.CreateCounterBid.Amount {
    var toWhoppahModel: Price {
        
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.CreateBidMutation.Data.CreateBid.Amount {
    var toWhoppahModel: Price {
        
        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.GetBidQuery.Data.Bid.Amount: WhoppahModelConvertable {
    var toWhoppahModel: Price {

        return .init(amount: self.amount,
                     currency: self.currency.toWhoppahModel)
    }
}

extension GraphQL.BidState: WhoppahModelConvertable {
    var toWhoppahModel: BidState {
        switch self {
        case .new:           return .new
        case .accepted:      return .accepted
        case .canceled:      return .canceled
        case .processing:    return .processing
        case .completed:     return .completed
        case .expired:       return .expired
        case .rejected:      return .rejected
        case .__unknown:     return .unknown
        }
    }
}

extension GraphQL.GetBidQuery.Data.Bid: WhoppahModelConvertable {
    var toWhoppahModel: Bid {
       
        let bid = Bid(id: self.id,
                      auction: self.auction.id,
                      buyer: self.buyer.id,
                      merchant: self.merchant.id,
                      state: self.state.toWhoppahModel,
                      order: self.order?.id,
                      created: self.created.toWhoppahModel,
                      expiryDate: self.expiryDate.toWhoppahModel,
                      endDate: self.endDate?.toWhoppahModel,
                      amount: self.amount.toWhoppahModel,
                      isCounter: self.isCounter,
                      thread: self.thread?.id)
        
        return bid
    }
}
