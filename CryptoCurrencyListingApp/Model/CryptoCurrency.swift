//
//  CryptoCurrency.swift
//  CryptoCurrencyListingApp
//
//  Created by Pouya Sadri on 08/02/2024.
//

import Foundation


// Top Level Structre

struct ApiResponse : Decodable{
	let data : [CryptoCurrency]
	let info : ApiInfo
}


// individual cryptocurrency data
struct CryptoCurrency: Decodable,Identifiable,Hashable{
	let id: String
	let symbol: String
	let name: String
	let nameid: String
	let rank: Int
	let price_usd: String
	let percent_change_24h: String
	let percent_change_1h: String
	let percent_change_7d: String
	let price_btc: String
	let market_cap_usd: String
	let volume24: Double
	let volume24a: Double
	let csupply: String
	let tsupply: String
	let msupply: String
	
	var isPercentageChange7dPositive : Bool{
		if let percentChange7dDouble = Double(percent_change_7d){
			return percentChange7dDouble > 0
		}
		
		return false
	}
}


// Information about the api response
struct ApiInfo : Decodable{
	let coins_num : Int
	let time : Int
}
