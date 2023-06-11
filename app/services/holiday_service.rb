require "httparty"
require "json"
require "pry"

class HolidayService

  def get_holidays
    response = HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end
