# Web Vulnerability Scanner

This simple bash script is designed to detect vulnerabilities on a target website, such as SQL Injection, XSS (Cross-Site Scripting), insecure HTTP methods (PUT and DELETE), missing HTTP headers (X-Frame-Options, X-XSS-Protection, Content-Security-Policy), and LFI (Local File Inclusion). It also checks whether a specified port is open.


## Example
Please enter the target site URL (e.g., http://targetsite.com): http://example.com
Please enter the port number to scan: 80

[+] SQL Injection possibility detected!
[-] XSS vulnerability not detected.
[-] Insecure HTTP methods not detected.
[-] X-Frame-Options header is missing. The site may be vulnerable to clickjacking.
[-] X-XSS-Protection header is missing. The site may be vulnerable to XSS attacks.
[-] Content-Security-Policy header is missing. No security policy is in place.
[-] LFI vulnerability not detected.
[+] Port 80 is open and accessible.


## Features

- SQL Injection detection
- XSS (Cross-Site Scripting) detection
- Detection of insecure HTTP methods (PUT, DELETE)
- Checking for missing HTTP headers:
  - X-Frame-Options
  - X-XSS-Protection
  - Content-Security-Policy
- LFI (Local File Inclusion) vulnerability detection
- Port scanning to check if the specified port is open

## Requirements

- `curl`
- `netcat` (`nc`)

This tool requires `curl` and `netcat` to be installed on your system.

### Installation

To install the required packages, run the following commands:

```bash
sudo apt update
sudo apt install curl netcat
```

```bash
git clone https://github.com/mr-martin-eden/web-exp-hunter
```

```bash
cd web-exp-hunter
```

```bash
chmod +× web-exp-hunter
```

```bash
./web-exp-hunter

or

bash web-exp-hunter
```
