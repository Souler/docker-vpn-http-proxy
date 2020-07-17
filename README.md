# Docker VPN HTTP proxy
> Simple Docker image to proxy an HTTP server while connected to a VPN

## Usage

```sh
$ docker build -t vpn .
$ docker run \
  -p 8080:80 \
  --cap-add=NET_ADMIN \ # This is mandatory!
  -e "PROXY_UPSTREAM=internal.api.company.io"
  -e "OPEN_VPN_FILE=$(cat ./config.ovpn | base64)" \
  vpn
```

## Why?

At [playtomic](https://github.com/syltek), in order to access the internal and development API we need to be connected to the company's VPN using a per-machine certificate policy (for example I happen to have 2 certificates, one for my laptop, one for my mobile phone). While working on your desktop, that is all good, just throw a VPN client (most of us use [Tunnelblick](https://tunnelblick.net)) and you are done.

Problem came when doing integration tests that consumed the internal API and were run on a CI parallelized environment. Because of the parallelization, we would need N certificates (where N is the number of machines running tests) so they all could run.

Since N certificates is not easy to implement (for our CI flow at least), nor it is easy to maintain, we created this. Now, whenever we are going to run integration tests, we spin up ONE of this services (which has its own certificate) and use said service as the API to consume. After the tests are done, we take the service down.

## Problems and limits

The main flaw with this approach is that the service is still using a single certificate, meaning that one CI workflow, running in parallel mode would work, but two CI workflows running at the same time would most likely end with the same problem of "one certificate per machine".

