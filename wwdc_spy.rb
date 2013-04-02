require 'rubygems'
require 'net/http'
require 'twilio-ruby'
require 'openssl'
require 'digest/sha1'

# Twilio Credentials
account_sid = 'REPLACE_ME'
auth_token = 'REPLACE_ME_TOO'

# Set up and read in the contents from http://developer.apple.com/wwdc
uri = URI.parse 'https://developer.apple.com/wwdc'
http = Net::HTTP.new uri.host, uri.port
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

data = http.get uri.request_uri
hash = Digest::SHA1.hexdigest data.body
time = Time.now 
time_string = time.strftime "%b %d, %Y %I:%M:%S %p"

# Check for a current wwdc_spy_hash file, otherwise create one in the current directory
hash_file = File.new('wwdc_spy_hash.txt', 'a+', :textmode => true) # a+ is mode read+write, starting at the end of the file	

# Read the first line of the file into old_hash
old_hash = hash_file.readlines[0]

# If old_hash doesn't exist, just write hash to hash_file and close the file
if !old_hash
	bytes_written = hash_file.write(hash)
	puts "Wrote #{bytes_written} bytes to wwdc_spy_hash.txt"
	hash_file.close
# Otherwise, compare the hashes
elsif old_hash && old_hash != hash
	# Hashes have changed! Let's write out the new hash first
	hash_file = File.new('wwdc_spy_hash.txt', 'w', :textmode => true)
	bytes_written = hash_file.write(hash)
	puts "Rewrote #{bytes_written} bytes to wwdc_spy_hash.txt"
	hash_file.close

	# Now we need to notify people!
	# Client to talk to the Twilio REST API
	@client = Twilio::REST::Client.new account_sid, auth_token

	# Send a text
	@text = @client.account.sms.messages.create(
		:from => 'twilio_number',
		:to => 'number_to_text',
		:body => "WWDC HAS CHANGED! Time triggered: #{time_string}"
	)

	# And a phone call
	@call = @client.account.calls.create(
		:from => 'twilio_number',
		:to => 'number_to_call',
		:url => ''
	)
else
	# Hashes are the same
	puts "Hashes are the same:\nOld Hash: #{old_hash}\nNew Hash: #{hash}"
end