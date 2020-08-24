# PHP-FPM Reverse Proxy Party

A bit of testing on reverse proxies using the FastCGI protocol to PHP-FPM.

## Using

Run:

```bash
make test

make reports
```

If all goes well, you should have both the `.json` and `.json.html` reports from the nginx and haproxy tests.

## Test

The test suite uses [artillery](https://artillery.io/) to perform a quick load test on the two different services.

When you run `make test`, here's what happens:

1. Clean any existing reports
2. Build the local artillery container
3. Runs the nginx and HAProxy tests
   1. Each starts by stopping and removing the existing containers
   2. The test simulates 20 users arriving every second for 60 seconds (total of 1200 virtual users arriving)

The endpoint it hits is just a simple php file with a tiny bit of code to ensure proper execution. The file and container is shared between the two tests (though only one container--nginx or HAProxy--is up at a time).
