ruleset location_data {
  meta {
    name "lab 6"
    description <<
      send a twillio location text
    >>
    author "BJ Nordgren"
    key twilio {"account_sid" : "AC41296657fe2c0daad065ecf124973366",
                    "auth_token"  : "0b233e07bb712fdc8e67574cc5d9b3" 
        }
         
    use module a8x115 alias twilio with twiliokeys = keys:twilio();
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    
        logging off
  }
  dispatch {
  }
  global{
  
  }
rule HelloWorld is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <div id="main">show!!</div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Lab 6", {}, my_html);
    }
  }
  rule location_nearby is active{
    select when explicit location_nearby
    {
      send_directive("location is near");
      twilio:send_sms("8014001952", "3852194405", "nearby!");
    }
  }
  
  rule location_far is active{
    select when explicit location_far
    {
      send_directive("location is far");
      twilio:send_sms("8014001952", "3852194405", "far far away!");
    }
  }
  
}
