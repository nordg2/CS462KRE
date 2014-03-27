ruleset foursquare {
  meta {
    name "lab 5"
    description <<
      FourSquare
    >>
    author "BJ Nordgren"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
    subscribers = {
    "cid": "1475E6BA-B5C6-11E3-A7BC-5060D61CF0AC",
    "cid": "314FB70C-B5C6-11E3-8EE4-3E1B293232C8"
    };
  }
  rule HelloWorld is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <div id="main"></div>
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
    rule dispatch {
      select when explicit new_location_data
        foreach subscribers setting (subscriber)
          
          event:send(subscriber,"schedule","inquiry")
              with attrs = {"key": event:attr("key"),
                            "data_map": event:attr("value")
                            };
          
          always {
            raise explicit event subscribers_notified on final
          }
    }
    rule process_fs_checkin {
      select when foursquare checkin
      pre {
      // decode the JSON to get the data structure
        checkin = event:attr("checkin").decode(); 
        data_map = {"venue": checkin.pick("$..venue.name"),
          "city": checkin.pick("$..location.city"),
          "shout": checkin.pick("$..shout", true).head(),
          "createdAt": checkin.pick("$..createdAt"),
          "lat": checkin.pick("$..lat"),
          "long": checkin.pick("$..lng")
         } ;
      }
send_directive("checkin") with body = data_map;
      fired {
        set app:venue checkin.pick("$..venue.name");
        set app:city checkin.pick("$..location.city");
        set app:shout checkin.pick("$..shout", true).head();
        set app:createdAt checkin.pick("$..createdAt");
        set app:lat checkin.pick("$..lat");
        set app:long checkin.pick("$..lng");
        raise explicit event new_location_data
                with key = "fs_checkin"
                and value = data_map;
         
      }
      
  }
  
}
