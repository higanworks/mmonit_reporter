mmonit_reporter
====


Description
-----

Create report from M/Monit HTTP API for system manager. Friendly format for mail. 

requirements
----

* Faraday(rubygems)
* rvm
* M/Monit (create none admin user recommend.)

Usage
----

### Setup

<pre><code>rvm use ruby-1.9.3-p194@mmrepo --create
bundle</code></pre>

### execute

tell username and password from env.

<pre><code>MMONIT_USER={mmonit_username} MMONIT_PASSWORD={mmonit_password} ./app.rb</code></pre>


Output Example
---------

<pre><code>$ MMONIT_USER=user MMONIT_PASSWORD=password ./app.rb

Monit report from  node01.example.jp


Pickup infomation. unless LED == "fine"
----------------------------------------------------------------
node03.example.jp


Summary of M/Monit

HOSTNAME              STATUS
----------------------------------------------------------------
node01.example.jp     All 6 services are available
node02.example.jp     All 15 services are available
node03.example.jp     11 out of 12 services are available
node04.example.jp     All 12 services are available
node05.example.jp     All 12 services are available
node06.example.jp     All 13 services are available
</code></pre>