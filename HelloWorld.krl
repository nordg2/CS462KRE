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
    datasource rotten_data <- "http://api.rottentomatoes.com/api/public/v1.0/movies.json?";
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
      CloudRain:createLoadPanel("Lab 5", {}, my_html);
    }
  }
  rule show_form {
        select when web cloudAppSelected
        pre {
            stuff = <<
                    <table>
                        <tr>
                            <td>
                                FourSquare!
                            </td>
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
    rule process_fs_checkin {
      select when foursquare checkin
      pre {
      // decode the JSON to get the data structure
      checkin = event:attr("checkin").decode();          
      }
      noop();
      fired {
      raise pds event new_location_available with
        key = "foursquare" and
        value = 
         {"venue": checkin.pick("$..venue.name"),
          "city": checkin.pick("$..location.city"),
          "shout": checkin.pick("$..shout", true).head(),
          "createdAt": checkin.pick("$..createdAt")
         }
    }
  }
  rule add_location_item {
  select when pds new_location_available
  noop();
  always {
    set ent:location{event:attr("key")} 
        event:attr("value");
    log "Saw " + event:attr("key") + " data";
    raise pds event new_location_item_added 
      with key = event:attr("key");
  }
}

}
