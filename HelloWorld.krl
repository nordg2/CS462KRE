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
            venue = app:venue;
            city = app:city;
            shout = app:shout;
            createdAt = app:createdAt;
            stuff = <<
                    <table>
                        <tr>
                            <td>
                                FourSquare! #{venue} #{city} #{shout} #{createdAt} 
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
      fired{
        set app:venue checkin.pick("$..venue.name");
        set app:city checkin.pick("$..location.city");
        set app:shout checkin.pick("$..shout", true).head();
        set app:createdAt checkin.pick("$..createdAt");
         
      }
      
  }
  
}
