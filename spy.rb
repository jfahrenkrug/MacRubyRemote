# Horrible, horrible ugly hacks to get RubyGems working in embedded MacRuby
# your have to run
# sudo macgem install sinatra
# before you can use this

puts "spying"

%w{/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/site_ruby/1.9.0
/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/site_ruby/1.9.0/universal-darwin10.0
/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/site_ruby
/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/vendor_ruby/1.9.0
/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/vendor_ruby/1.9.0/universal-darwin10.0
/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/vendor_ruby
/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/1.9.0
/Library/Frameworks/MacRuby.framework/Versions/0.5/usr/lib/ruby/1.9.0/universal-darwin10.0}.each do |path|
	$: << path
end

require "rubygems"
require "sinatra/base"
require "webrick"
framework 'Cocoa'

module WEBrick
  class HTTPRequest
    def read_request_line(socket)
      @request_line = read_line(socket, 1024) if socket
      if @request_line.size >= 1024 and @request_line[-1, 1] != LF
        raise HTTPStatus::RequestURITooLarge
      end
      @request_time = Time.now
      raise HTTPStatus::EOFError unless @request_line
      #if /^(\S+)\s+(\S+)(?:\s+HTTP\/(\d+\.\d+))?\r?\n/mo =~ @request_line
	  if /^(\S+)\s+(\S+)(?:\s+HTTP\/(\d+\.\d+))/mo =~ @request_line
        @request_method = $1
        @unparsed_uri   = $2
        @http_version   = HTTPVersion.new($3 ? $3 : "0.9")
      else
        rl = @request_line.sub(/\x0d?\x0a\z/o, '')
        raise HTTPStatus::BadRequest, "XXX bad Request-Line `#{rl}'."
      end
    end
	
	def _read_data(io, method, *arg)
		puts "in read_data"
      begin
        WEBrick::Utils.timeout(@config[:RequestTimeout]){
			puts "method: #{method}"
			begin
				return io.__send__(method, *arg)
			rescue Errno::EAGAIN => e
				puts e
				return nil
			end
        }
      rescue Errno::ECONNRESET
        return nil
      rescue TimeoutError
        raise HTTPStatus::RequestTimeout
      end
    end
  end
end

class SpyServer < Sinatra::Base
  get "/" do
	"Your app has been infiltrated by MacRuby."
  end

  get "/run" do
	begin
		 return eval(params[:code]).to_s
	rescue Exception => e
		return "Error: " + e.message
	end
  end
end
  

Thread.new do
  SpyServer.run! :port => 4567
end
