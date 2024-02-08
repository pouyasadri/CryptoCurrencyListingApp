//
//  CryptoCurrencyViewModel.swift
//  CryptoCurrencyListingApp
//
//  Created by Pouya Sadri on 08/02/2024.
//

import Foundation


class CryptoCurrencyViewModel : ObservableObject{
	@Published var cryptoCurrencies : [CryptoCurrency] = []
	@Published var isLoading = false
	@Published var errorMessage: String?
	
	private let urlString = "https://api.coinlore.net/api/tickers/?start=0&limit=10"
	
	func fetchData(){
		guard let url = URL(string: urlString) else {
			errorMessage = "Invalid URL"
			return
		}
		
		isLoading = true
		
		let task = URLSession.shared.dataTask(with: url){[weak self] data, response, error in
			DispatchQueue.main.async {
				self?.handleResponse(data: data, reponse: response, error: error)
			}
			
		}
		
		task.resume()
	}
	
	private func handleResponse(data: Data?, reponse: URLResponse?, error: Error?){
		isLoading = false
		
		if let error = error{
			errorMessage = "Faild to fetch data: \(error.localizedDescription)"
			return
		}
		
		guard let httpsResponse = reponse as? HTTPURLResponse, httpsResponse.statusCode == 200 else{
			errorMessage =  "Error: Invalid Response From Server"
			return
		}
		
		guard let data = data else {
			errorMessage = "Error: No data received"
			return
		}
		
		decodeData(data)
	}
	
	
	private func decodeData(_ data: Data){
		do{
			let decoder = JSONDecoder()
			let decodedData = try decoder.decode(ApiResponse.self, from: data)
			cryptoCurrencies = decodedData.data
		}catch{
			errorMessage = "Error: Field to decode data"
		}
		
		
	}
}
