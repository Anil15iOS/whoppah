//
//  StatsByPeriodItem.swift
//  WhoppahModel
//
//  Created by CleanDataModelGenerator.
//
import Foundation
import CoreLocation

public struct StatsByPeriodItem: Equatable {
	public let signups: Int?
	public let signupsgoogle: Int?
	public let signupsfnf: Int?
	public let signupsfbig: Int?
	public let signupstv: Int?
	public let signupsother: Int?
	public let signupsinvited: Int?
	public let adscreated: Int?
	public let adsapprovalrate: Double?
	public let adsapprovalrateart: Double?
	public let adsapprovalratefurniture: Double?
	public let adsapprovalratelighting: Double?
	public let adsapprovalratedecoration: Double?
	public let numberofitemsthathadbid: Int?
	public let numberofchats: Int?
	public let numberofbids: Int?
	public let numberofsales: Int?
	public let grossmarginvalue: Double?
	public let averageordervalue: Double?
	public let averagesalesfee: Double?
	public let feesrevenue: Double?
	public let totalcourierrevenue: Double?
	public let totalcouriercount: Double?
	public let averagecourierrevenue: Double?
	public let courierratio: Double?
	public let totalrevenue: Double?

	public init(
		signups: Int? = nil,
		signupsgoogle: Int? = nil,
		signupsfnf: Int? = nil,
		signupsfbig: Int? = nil,
		signupstv: Int? = nil,
		signupsother: Int? = nil,
		signupsinvited: Int? = nil,
		adscreated: Int? = nil,
		adsapprovalrate: Double? = nil,
		adsapprovalrateart: Double? = nil,
		adsapprovalratefurniture: Double? = nil,
		adsapprovalratelighting: Double? = nil,
		adsapprovalratedecoration: Double? = nil,
		numberofitemsthathadbid: Int? = nil,
		numberofchats: Int? = nil,
		numberofbids: Int? = nil,
		numberofsales: Int? = nil,
		grossmarginvalue: Double? = nil,
		averageordervalue: Double? = nil,
		averagesalesfee: Double? = nil,
		feesrevenue: Double? = nil,
		totalcourierrevenue: Double? = nil,
		totalcouriercount: Double? = nil,
		averagecourierrevenue: Double? = nil,
		courierratio: Double? = nil,
		totalrevenue: Double? = nil
	) {
		self.signups = signups
		self.signupsgoogle = signupsgoogle
		self.signupsfnf = signupsfnf
		self.signupsfbig = signupsfbig
		self.signupstv = signupstv
		self.signupsother = signupsother
		self.signupsinvited = signupsinvited
		self.adscreated = adscreated
		self.adsapprovalrate = adsapprovalrate
		self.adsapprovalrateart = adsapprovalrateart
		self.adsapprovalratefurniture = adsapprovalratefurniture
		self.adsapprovalratelighting = adsapprovalratelighting
		self.adsapprovalratedecoration = adsapprovalratedecoration
		self.numberofitemsthathadbid = numberofitemsthathadbid
		self.numberofchats = numberofchats
		self.numberofbids = numberofbids
		self.numberofsales = numberofsales
		self.grossmarginvalue = grossmarginvalue
		self.averageordervalue = averageordervalue
		self.averagesalesfee = averagesalesfee
		self.feesrevenue = feesrevenue
		self.totalcourierrevenue = totalcourierrevenue
		self.totalcouriercount = totalcouriercount
		self.averagecourierrevenue = averagecourierrevenue
		self.courierratio = courierratio
		self.totalrevenue = totalrevenue
	}
}
