class SolanaPriceController < ApplicationController
  def show
    # Define the token symbol and the Solana API endpoint
    token_symbol = "SOL"
    endpoint = "https://api.solana.com/prices?symbols[]=#{token_symbol}"

    # Make a GET request to the API
    begin
      response = Net::HTTP.get_response(URI(endpoint))
      raise "Request failed: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)
    rescue => e
      @error = "Error: #{e}"
      render 'error' and return
    end

    # Parse the response as JSON
    begin
      prices = JSON.parse(response.body)
    rescue => e
      @error = "Error parsing JSON: #{e}"
      render 'error' and return
    end

    # Get the price for the SOL token
    @price = prices[token_symbol]

    # Check if the price was found
    if @price.nil?
      @error = "Error: price for #{token_symbol} not found"
      render 'error' and return
    end
  end
end
