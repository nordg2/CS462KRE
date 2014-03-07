ruleset a16x138 {
  meta {
    name "PDS Inspector"
    use module a16x137 version "dev" alias pds
  }

  dispatch {
    domain "exampley.com"
  }
  
  rule show_location_data {
    select when pageview ".*"
    pre {
      fs_location = pds:get_location("foursquare");
      v = fs_location.pick("$..venue");
      c = fs_location.pick("$..city");
      s = fs_location.pick("$..shout");
      t = "Phil last seen at #{v} in #{c}";
      body = 
        (s.typeof()) eq "str" => t + ' saying "#{s}"'
                               | t;
    }
  notify("Where's Phil?", body) with sticky = true;
}
