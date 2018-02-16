module ApplicationHelper
    require 'uri'
    #should no be used for associated record
    def check_record(value)
        value ||= ""
    end
    
    
    def is_valid_url(url)
        uri = URI.parse(url)
        uri.kind_of? URI::HTTP
        
        rescue URI::InvalidURIError
        false
    end
      
  def formatted_duration total_seconds
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60

    if hours == 0
        "#{ minutes }m #{ seconds }s"
    else
        "#{ hours }h #{ minutes }m #{ seconds }s"
    end
  end

  def change_up?(data)
         if data > 0
            return ["<i class='fa fa-long-arrow-up text-green'></i>", "text-green"]
         elsif data == 0
            return ["<i class='fa fa-minus text-blue'></i>", "text-blue"]
        else
            return ["<i class='fa fa-long-arrow-down text-red'></i>", "text-red"]
        end 
  end

  def change_down?(data) #bounceRate :: positve(low) :: negative(high)
         if data > 0
            return ["<i class='fa fa-long-arrow-up text-red'></i>", "text-red"]
         elsif data == 0
            return ["<i class='fa fa-minus text-blue'></i>", "text-blue"]
        else
            return ["<i class='fa fa-long-arrow-down text-green'></i>", "text-green"]
        end 
  end

end
