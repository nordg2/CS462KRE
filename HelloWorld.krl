ruleset HelloWorldApp {
  meta {
    name "lab 5"
    description <<
      Search for a movie
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
 

}






