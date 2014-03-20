ruleset location {
  meta {
    name "lab 7"
    description <<
      Current Location
    >>
    author "BJ Nordgren"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    use module b505212x5 alias blah
  }
  dispatch {
  }
  global {
    datasource rotten_data <- "http://api.rottentomatoes.com/api/public/v1.0/movies.json?";
  }
  rule HelloWorld is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <div id="main">test!</div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Lab 6", {}, my_html);
    }
  }
  rule show_form {
        select when web cloudAppSelected
        pre {
            venue = app:venue;
            city = app:city;
            shout = app:shout;
            createdAt = app:createdAt;
            lat = app:lat;
            long = app:long;
            
            stuff = <<
                    <table>
                        <tr>
                            <td>
                                Venue:
                            </td>
                            <td> #{venue}
                        </tr>
                        <tr>
                            <td>
                                City: 
                            </td>
                            <td> #{city}
                        </tr>
                        <tr>
                            <td>
                                Shout: 
                            </td>
                            <td> #{shout}
                        </tr>
                        <tr>
                            <td>
                                lat:  
                            </td>
                            <td> #{lat}
                        </tr>
                        <tr>
                            <td>
                                long:  
                            </td>
                            <td> #{long}
                        </tr>
                        <tr>
                            <td>
                                CreatedAt:  
                            </td>
                            <td> #{createdAt}
                        </tr>
                    </table>
                >>;
        }
        every {
            append("#main",stuff);
            watch("#myForm", "submit");
        }
        
        fired {
            last;
        }
    }
    rule nearby {
      select when location current_location
      pre {
      // decode the JSON to get the data structure
        cur_lat = event:attr("lat"); 
        cur_long = event:attr("long");
        fs_checkin = blah:get_location_data("fs_checkin");
        checkin_lat = fs_checkin.pick("$..lat");
        checkin_long = fs_checkin.pick("$..long");
        
        r90   = math:pi()/2;      
        rEm   = 6378;         // radius of the Earth in miles
         
        // convert co-ordinates to radians
        rlata = math:deg2rad(cur_lat);
        rlnga = math:deg2rad(cur_long);
        rlatb = math:deg2rad(checkin_lat);
        rlngb = math:deg2rad(checkin_long);
         
        // distance between two co-ordinates in radians
        dR = math:great_circle_distance(rlnga,r90 - rlata, rlngb,r90 - rlatb);
         
        // distance between two co-ordinates in miles
        dE = math:great_circle_distance(rlnga,r90 - rlata, rlngb,r90 - rlatb, rEm);
        
        
        data_map = {
          "lat": cur_lat,
          "long": cur_long
         };
      }
    send_directive("Current Location") with body = data_map;
      fired {
        raise explicit event location_nearby for b505212x8 if dE <= 5;
        raise explicit event location_far for b505212x8 if dE > 5;
      }
      
  }
  
}
