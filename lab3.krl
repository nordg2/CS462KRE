ruleset lab3 {
    meta {
        name "notify example"
        author "BJ Nordgren"
        logging off
    }
    dispatch {
         //domain "exampley.com"
    }
    rule show_form {
        select when pageview ".*" setting ()
        pre {
            stuff = <<
                <form id=myForm" onsubmit='return false'>
                    <table>
                        <tr>
                            <td>
                                First Name:
                            </td>
                            <td>
                                <input name="first"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Last Name:
                            </td>
                            <td>
                                <input name="last"/>
                            </td>
                        </tr>
                    </table>
                    <input type="submit" value="Submit">
                </form>
                >>;
        }
        if(not app:username) then {
            append("#main",stuff);
            watch("#myForm", "submit");
        }
    }
    rule respond_submit {
        select when web submit "#myForm"
        pre{
            username = event:attr("first")+" - "+event:attr("last");
        }
        replace_inner("#main", "Hello #{username}");
        fired {
            set app:username username;
        }
    }
    rule replace_with_name {
        select when web pageview ".*"
        pre{
            username = app:username;
        }
        replace_inner("#main", "Hello #{username}");
    }
    rule clear_rule {
        select when pageview ".*" setting()
          
        pre {
            query1 = page:url("query");
            a1 = query1.extract(re/(clear([^&]*))/);
        }
       if a1[0] neq "" then
             notify("Username Cleared","");
        fired {
             clear app:username;
        } 
    }
    
    
}
