class NagerService
  def self.next_us_holidays
    response = HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
    parsed_holidays = JSON.parse(response.body, symbolize_names: true)
  end
end