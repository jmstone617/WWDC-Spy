WWDC-Spy

A small ruby script to notify you of changes to the WWDC site

## Prerequisites:
In order to take advantage of the notification features of WWDC Spy, you need to install and require the Twilio gem. First, you can install the gem via RubyGems like so:

```
$ gem install twilio-ruby
```

Next, make sure you have a Twilio account. If you don't have one, you can sign up for a free one here: https://www.twilio.com/try-twilio

## Include Twilio Information:
Once you have a Twilio account, include your Account SID and Auth Token in the top of wwdc_spy.rb:

``` ruby
# Twilio Credentials
account_sid = 'REPLACE_ME'
auth_token = 'REPLACE_ME_TOO'
```

## Send a Text:
In order to send a text message when the WWDC site changes, you must include your Twilio number and your verified mobile number in the @text instance variable:

``` ruby
# Send a text
@text = @client.account.sms.messages.create(
	:from => 'twilio_number',
	:to => 'number_to_text',
	:body => "WWDC HAS CHANGED! Time triggered: #{time_string}"
)
```

## Make a Phone Call:
Making a phone call is just as easy. Again, include your Twilio number and verified mobile number. In the URL symbol, include the URL to some TwiML (Twilio Markup Language) with instructions for the phone call. You can use Twimlbin (http://www.twimlbin.com) to host your TwiML code for free.

``` ruby
# And a phone call
@call = @client.account.calls.create(
	:from => 'twilio_number',
	:to => 'number_to_call',
	:url => ''
)
```

## Pro Tip:
If you are using iOS 6+ pn your iOS Device with Do Not Disturb enabled, add your Twilio phone number to your Favorites or allowed contact group to make sure you don't sleep through the WWDC Tickets release!

And that's it! Good luck getting your ticket this year!
