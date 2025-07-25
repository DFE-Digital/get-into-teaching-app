# Sign up journeys

There are multiple different sign up journeys available on the Get into Teaching website. The logic for what the user sees during the sign up is captured in the graphs below (you can view them on [mermaid.live](https://mermaid.live/)).

## Mailing list sign up flow

```mermaid
graph TD;
  name[Free personalised teacher training guidance] -- Doesn't exist in CRM --> returning_teacher[Are you already qualified to teach?]
  name -- Exists in CRM --> authenticate[You're already registered with us]
  
  returning_teacher -- Yes --> already_qualified[We're sorry, but our emails are for people who are not already qualified to teach]
  returning_teacher -- No --> degree_status[Do you have a degree?]

  authenticate -- Not on mailing list --> returning_teacher
  authenticate -- On mailing list --> signed_up_already[You've already signed up]
  degree_status --> teacher_training[How close are you to applying?]
  
  teacher_training --> subject[Select the subject you're most interested in teaching]

  subject --> postcode["What's your UK postcode? (optional)"]
  
  postcode --> completed[You've signed up] 
```

## Event sign up flow

```mermaid
graph TD;
  chooses_event[/Chooses a Train to Teach event/] --> personal_details
  personal_details[Sign up for this event] -- Doesn't exist in CRM --> contact_details["What's your telephone number? (optional)"] --> accept_privacy_policy[Accept privacy policy]

  personal_details -- Exists in CRM --> already_registered[You've already registered with us]
  already_registered --> contact_details

  contact_details --> further_details[Get tailored email guidance]

  further_details -- I want email updates --> personalised_updates[About you]
  further_details -- No email updates --> completed[Sign up complete]

  personalised_updates --> completed
```

## Book a callback flow

```mermaid
graph TD;
  book[Book a callback] -- Doesn't exist in CRM --> matchback_failed["We didn’t recognise the first name, last name or email address you entered"]
  book -- Exists in CRM --> authenticate[You're already registered with us]

  authenticate --> callback[Choose a time for your callback]
  
  callback --> talking_points["Tell us what you’d like to talk to us about"]

  talking_points --> completed[Callback confirmed]
```

## Adviser sign up flow

The adviser sign up is complex and has multiple branches, making it difficult to model in graph TD. We maintain a [lucid board](https://lucid.app/lucidchart/dd4d9f2d-57e9-406c-b58b-bb3847460142/edit?from_internal=true) with screenshots of the different journeys instead.
