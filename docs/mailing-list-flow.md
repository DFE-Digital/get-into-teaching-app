# Mailing list signup flow

```mermaid
graph TD;
  name_and_email[Get personalised guidance to your inbox] -- Doesn't exist in CRM --> degree[Do you have a degree?]
  name_and_email -- Exists in CRM --> already_registered[You're already registered with us]
  
  already_registered -- Not on mailing list --> degree
  already_registered -- On mailing list --> signed_up_already[You've already signed up]
  degree --> journey_stage[How close are you to applying?]
  
  journey_stage --> subject[Which subject do you want to teach?]
  subject --> events[Would you like to hear about events in your area?]
  
  events --> privacy_policy[Accept privacy policy]
  
  privacy_policy --> show_welcome_guide{Show welcome guide?}
  
  show_welcome_guide --> signed_up_no_wg[You've signed up]  
  show_welcome_guide --> signed_up_wg[You've signed up with Welcome Guide link]  
  
  signed_up_wg --> welcome_guide[Welcome guide]
```

## Show welcome guide logic

In order to display the welcome guide to a candidate they must:

* be a final year student
* be a graduate who in the 'how close are you to applying' question answered:
  * It’s just an idea
  * I’m not sure and finding out more
