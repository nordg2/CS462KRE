ruleset HelloWorldApp {
  meta {
    name "lab 4"
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
            synopsis = movie_data.pick("$.movies[0].synopsis");
            releaseYear = movie_data.pick("$.movies[0].year");
            criticRating = movie_data.pick("$.movies[0].ratings.critics_rating");
            criticScore = movie_data.pick("$.movies[0].ratings.critics_score");
            audienceRating = movie_data.pick("$.movies[0].ratings.audience_rating");
            audienceScore = movie_data.pick("$.movies[0].ratings.audience_score");

            movieTag = <<
              <table>
                <tr>
                  <td colspan="2">
                    #{movieTitle}&nbsp;<b>#{releaseYear}</b>
                  </td>
                </tr>
                <tr>
                  <td width="20%">
                    <table>
                      <tr>
                        <td colspan="2">
                          <img src="#{img}" width="300px" height="500px"/>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          Critics:
                        </td>
                        <td>
                          #{criticScore}&nbsp;#{criticRating}
                        </td>
                      </tr>
                      <tr>
                        <td>
                          Audience:
                        </td>
                        <td>
                          #{audienceScore}&nbsp;#{audienceRating}
                        </td>
                      </tr>
                      
                    </table>
                  </td>
                  <td width="80%">
                    <table>
                      
                      <tr>
                        <td>
                          Synopsis: #{synopsis}
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td>
                    
                  </td>
                </tr>
              </table>
            >>;
            imgtag = << <img src="#{img}"/> >>;
        }
        
          if(total eq 0) then {
            replace_inner("#main", "No movies were found");
            append("#main",stuff);
            append("#main", "#{search}");
          }
          if(total neq 0) then {
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



