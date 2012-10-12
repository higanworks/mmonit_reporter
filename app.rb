#!/usr/local/rvm/bin/ruby-1.9.3-p194@mmrepo

require 'json'
require 'faraday'

class MonitReports
  def initialize(mmonit = "http://127.0.0.1:8080")
    @connection = Faraday.new(:url => mmonit)
    res = @connection.get "/index.csp"
    @cookie = res.headers['set-cookie']
    @accepted = false
  end

  def stamp_auth(username, password)
    res = @connection.post "/z_security_check" do |req|
      req.headers['Cookie'] = @cookie
      req.body = {"z_password" => password, "z_username" => username}
    end
    raise "Authentication Faild" unless (300..399).include?(res.status)
    @accepted = true
  end

  def retrieve_status_list
    raise "Authentication first! Call #stamp_auth please." unless @accepted
    res = @connection.post "/json/status/list" do |req|
      req.headers['Cookie'] = @cookie
    end
    JSON.parse(res.body, :symbolize_names => true )
  end

  def pickup_unsafe_node(status = [])
    list = []
    status.map {|x| list << x[:host] unless x[:led] == "2" }
    list = ["All hosts fine."] if list == []
    list
  end

  def create_summary(status = [])
    summary = ""
    status.map {|x| summary << sprintf("%-20s", x[:host]) + "  " + sprintf("%-20s", x[:status]) + "\n" }
    summary
  end

end


require 'erb'

mon = MonitReports.new
mon.stamp_auth ENV["MMONIT_USER"], ENV["MMONIT_PASSWORD"]
status = mon.retrieve_status_list[:records]


mailbody = ERB.new(DATA.read, nil, '-').result
puts mailbody


__END__
Monit report from  <%= `hostname -f` %>

Pickup infomation. unless LED == "fine"
----------------------------------------------------------------
<% mon.pickup_unsafe_node(status).each do |host| -%>
<%= host %>
<% end -%>


Summary of M/Monit

HOSTNAME              STATUS
----------------------------------------------------------------
<%= mon.create_summary(status) %>
