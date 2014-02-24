ruleset lab4 {
    meta {
        name "lab4"
        author "BJ Nordgren"
        logging off
    }    
    dispatch {
         //domain "exampley.com"
    }
    global {
        datasource rotten_data <- "http://api.rottentomatoes.com/api/public/v1.0/movies.json?";
    }   //domain "exampley.com"
    
    rule show_form {
        select when pageview ".*" setting ()
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
            imgtag = << <img src="#{img}"/> >>
        }
        every {
            
            replace_inner("#main", "#{search}");
            append("#main", "#{imgtag}");
            append("#main",stuff);
        }
        
        fired {
            set app:search search;
        }
    }
    rule replace_with_name {
        select when web pageview ".*"
        pre{
            search = app:search;
        }
        if(not not app:search) then {
            append("#main", "#{search}");
        }
    }
    rule clear_rule {
        select when pageview ".*" setting()
          
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


