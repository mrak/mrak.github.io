# stubby4node

What is it? Good question! Here's an impromptu tag-line:

> [stubby](http://stub.by) is a small web server used during development for
> stubbing or mocking resources external to your system.

Wow, that sounds super-generic and unexciting. Why would I use this? Another
good question! As developers, we often find ourselves reliant on web services
that are out of our control.

An example of this would be writing an application using Twitter’s API. You want your
__super-mobile-startup-cloud-social-buzzword-buzzword__ application to be rock-solid in the
event that Twitter goes down, no long has a specific tweet, or fails to find a
now-inactive user profile. What you’d like is a fake Twitter with canned
responses to formulate test cases.

Enter stubby.

Here would be a configuration file (let’s call it data.yaml) to describe a
couple of interactions:

__data.yaml__
```
- request:
    url: /api/users/nolongerhere
    method: GET
  response:
    status: 410
    headers:
      content-type: application/json
    body: '{"error":"User nolongerhere no longer exists."}'

- request:
    url: /api/tweets/
    method: POST
  response:
    status: 201
    headers:
      location: /api/tweets/4abdf897adcee820cd
```

We have a data file! … what do we _do_ with it? Assuming you have stubby installed
(which you should) you could do this:

<pre><code><span class="green">$</span> stubby --data data.yaml
<span class="magenta">Loaded: GET /api/users/nolongerhere</span>
<span class="magenta">Loaded: POST /api/tweets/</span>

<span class="cyan">Quit: ctrl-c</span>

<span class="bold black">Stub portal running at http://localhost:8882</span>
<span class="bold black">Admin portal running at http://localhost:8889</span>
</code></pre>

Ok, what just happened? It’s spitting girly colors at me.
It sure is! Any command-line url utility (wget, curl — looking at you)  can test
it out. I’m going to be demonstrating with [httpie](http://httpie.org), due to it’s human-readable
usage. Notice that we submit requests to the url described as “Stub portal” when
we exectued stubby:

<pre><code><span class="green">$</span> http GET localhost:8882/api/users/nolongerhere
<span class="blue">HTTP</span>/<span class="cyan">1.1 410</span> <span
class="yellow">Gone</span>
<span class="bold black">Connection:</span> <span class="cyan">keep-alive</span>
<span class="bold black">Date:</span> <span class="cyan">Tue, 09 Oct 2012 07:00:10 GMT</span>
<span class="bold black">Transfer-Encoding:</span> <span
class="cyan">chunked</span>
<span class="bold black">content-type:</span> <span class="cyan">application/json</span>

<span class="bold black">{</span>
    <span class="blue">"error":</span> <span class="cyan">User nolongerhere no longer exists."</span>
<span class="bold black">}</span>
</code></pre>

Stubby can’t take credit for the colors this time; that is actually httpie.
Stubby did, however, responded to us with status code 410: Gone, with the
content-type header application/json and the supplied body as the response.
We’ve interacted with a live connection of our making, with minimal fuss.
What about our other endpoint?

<pre><code><span class="green">$</span> http POST localhost:8882/api/tweets/
<span class="blue">HTTP</span>/<span class="cyan">1.1 201</span> <span class="yellow"> Created</span>
<span class="bold black">Connection:</span> <span class="cyan">keep-alive</span>
<span class="bold black">Date:</span> <span class="cyan">Tue, 09 Oct 2012 07:11:50 GMT</span>
<span class="bold black">Transfer-Encoding:</span> <span class="cyan">chunked</span>
<span class="bold black">location:</span> <span class="cyan">/api/tweets/4abdf897adcee820cd</span>
</code></pre>

Don’t worry, it’s working, too. It’s pretending that we created a new tweet by
posting to the (fake) API.

I imagine that you are thinking of new endpoints to describe in your data.yaml
for consumption of your tests. Also, you don’t have to use stubby from the
command-line. My friend and I have been writing language-specific
implementations of stubby. Currently only Java and node.js versions are
available. These implementations allow you to control stubby
programmatically through your native test suite (if you happen to be using
Coffeescript, node, or Java).

You should check them out!
