ruleset HelloWorldApp {
  meta {
    name "lab 4"
    description <<
      Hello World
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
        <h5>Hello, world!</h5>
        <div id="main"></div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Lab 4", {}, my_html);
    }
  }
  rule show_form {
        select when web cloudAppSelected
        pre {
            stuff = <<
                <form id="myForm" onsubmit='return false'>
                    <table>
                        <tr>
                            <td>
                                Search Movies:
                            </td>
                            <td>
                                <input name="search"/>
                            </td>
                        </tr>
                    </table>
                    <input type="submit" value="Submit">
                </form>
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
    rule respond_submit {
        select when web submit "#myForm"
        pre{
        stuff = <<
                <form id="myForm" onsubmit='return false'>
                    <table>
                        <tr>
                            <td>
                                Search Movies:
                            </td>
                            <td>
                                <input name="search"/>
                            </td>
                        </tr>
                    </table>
                    <input type="submit" value="Submit">
                </form>
                >>;
            search = "Search query used: "+event:attr("search");
            searchQuery = event:attr("search");
            movie_data = datasource:rotten_data("apikey=293h6xsdm6mwebuud7bswzxa&q=#{searchQuery}&page_limit=10&page=1");
            total = movie_data.pick("$.total");
            img = movie_data.pick("$.movies[0].posters.thumbnail");
            movieTitle = movie_data.pick("$.movies[0].title");
            movieTag = <<
              <table>
                <tr>
                  <td>
                    <img src="#{img}"/>
                  </td>
                  <td>
                    #{movieTitle}
                  </td>
                </tr>
              </table>
            >>;
            imgtag = << <img src="#{img}"/> >>;
        }
        every {
            
            replace_inner("#main", "#{movieTag}");
            append("#main",stuff);
            append("#main", "#{search}");
        }
        
        fired {
            set app:search search;
        }
    }
    rule replace_with_name {
        select when web cloudAppSelected
        pre{
            search = app:search;
        }
        if(not not app:search) then {
            append("#main", "#{search}");
        }
    }
    rule clear_rule {
        select when web cloudAppSelected
          
        pre {
            query1 = page:url("query");
            a1 = query1.extract(re/(clear([^&]*))/);
        }
       if a1[0] neq "" then
             notify("search cleared"," ");
        fired {
             clear app:search;
             last
        } 
    }
}



