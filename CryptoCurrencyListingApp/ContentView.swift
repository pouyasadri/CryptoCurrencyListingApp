//
//  ContentView.swift
//  CryptoCurrencyListingApp
//
//  Created by Pouya Sadri on 08/02/2024.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = CryptoCurrencyViewModel()
	
    var body: some View {
		ZStack{
			backgroundGradient
			if viewModel.isLoading{
				Text("Loading...")
					.foregroundStyle(.white)
					.font(.largeTitle)
			}else{
				content
			}
		}
		.onAppear{
			viewModel.fetchData()
		}
    }
	
	
	private var backgroundGradient: some View{
		LinearGradient(gradient: Gradient(colors: [.black,Color(red: 67/255, green: 67/255, blue: 67/255)]), startPoint: .top, endPoint: .bottom)
			.ignoresSafeArea()
	}
	
	private var content : some View{
		VStack{
			header
			columnTitles
			cryptoList
		}
		.foregroundStyle(.white)
	}
	
	private var header : some View{
		Text("Top 10 CryptoCurrencies")
			.font(.title)
			.fontWeight(.semibold)
	}
	
	private var columnTitles: some View{
		HStack{
			columnTitle("Name", alignment: .leading)
			columnTitle("Symbol", alignment: .center)
			columnTitle("Price", alignment: .trailing)
		}
		.padding()
	}
	
	private func columnTitle(_ text: String, alignment: Alignment) -> some View{
		Text(text)
			.font(.callout)
			.fontWeight(.light)
			.foregroundStyle(.secondary)
			.frame(maxWidth: .infinity,alignment: alignment)
	}
	
	private var cryptoList: some View{
		ScrollView{
			ForEach(viewModel.cryptoCurrencies,id: \.id){currency in
					CryptoRow(currency: currency)
			}
		}
	}
}


struct CryptoRow :View {
	let currency : CryptoCurrency
	var body: some View {
		HStack{
			rank
			icon
			name
			symbol
			priceAndChange
		}
		.padding(8)
		.frame(height: 70)
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(.secondary.opacity(0.5),lineWidth: 0.5)
		)
		.padding(.horizontal,12)
	}
	
	private var rank : some View{
		Text("# \(currency.rank)")
			.fontWeight(.light)
			.font(.caption)
	}
	
	private var icon : some View{
		AsyncImage(url : URL(string: "https://coinicons-api.vercel.app/api/icon/\(currency.symbol.lowercased())")){image in
			image.resizable()
				.scaledToFit()
			
		}placeholder: {
			Text(currency.symbol)
		}
		.frame(width: 24,height: 24)
		
	}
	
	private var name : some View{
		Text(currency.name)
			.font(.callout)
			.fontWeight(.medium)
			.frame(maxWidth: .infinity,alignment: .leading)
	}
	
	private var symbol : some View{
		Text(currency.symbol)
			.font(.caption)
			.fontWeight(.light)
			.frame(maxWidth: .infinity,alignment: .leading)
	}
	private var priceAndChange : some View{
		VStack{
			Text("$ \(currency.price_usd)")
				.font(.footnote)
				.fontWeight(.medium)
			
			HStack{
				Image(systemName: currency.isPercentageChange7dPositive ? "arrow.up" : "arrow.down")
					.resizable()
					.scaledToFit()
					.frame(width: 8,height: 8)
				Text("\(currency.percent_change_7d) %")
					.font(.caption2)
					.fontWeight(.light)
			}
			.foregroundStyle(currency.isPercentageChange7dPositive ? .green : .red)
		}
		.padding(.vertical)
		.frame(maxWidth: .infinity,alignment: .trailing)
	}
}

#Preview {
    ContentView()
}
