Overview

This lab focuses on web reconnaissance using Maltego. You will gather and visualize intelligence about domains, email addresses, and infrastructure using Maltego and supporting OSINT tools.

The lab emphasizes relationship mapping, integration of multiple OSINT tools, and producing structured reconnaissance reports for security analysis.

Objectives

By the end of this lab, you will:

Install and configure Maltego Community Edition
Integrate Maltego with OSINT tools
Perform domain and email reconnaissance
Visualize relationships between entities
Analyze infrastructure and digital footprints
Export and document findings

Lab Tasks Summary

Task 1: Setup and Installation
Install Java
Install Maltego
Install OSINT tools (theHarvester, Sublist3r, Recon-ng, DNSrecon)

Task 2: Basic Reconnaissance
Create Maltego graph
Add domain entities
Run transforms for DNS, IP, and location
Discover email addresses

Task 3: Tool Integration
Run Sublist3r for subdomains
Use DNSrecon for DNS records
Integrate Recon-ng results
Import findings into Maltego

Task 4: Visual Mapping
Build domain relationship graphs
Map email and organization relationships
Analyze infrastructure connections

Task 5: Advanced Techniques
Create custom transforms
Export graph data
Generate HTML reports

Task 6: Verification and Testing
Validate tool integration
Run performance tests
Ensure all tools function correctly

Key Commands:
Install Maltego
sudo dpkg -i Maltego.v4.5.0.deb
sudo apt-get install -f
Run theHarvester
theharvester -d example.com -l 100 -b google,bing
Run Sublist3r
python3 sublist3r.py -d example.com
Run DNSrecon
dnsrecon -d example.com -t std
Expected Outcomes

After completing this lab, you will have:

Domain and subdomain intelligence
Email address discoveries
DNS and infrastructure data
Visual reconnaissance graphs
Structured reports

Legal Notice

Only perform reconnaissance on:

Domains you own
Systems you are authorized to test

Unauthorized reconnaissance is illegal.

Conclusion

This lab demonstrates how to perform structured web reconnaissance using Maltego and supporting OSINT tools. You learned how to gather, correlate, and visualize intelligence, which is essential for incident response, threat intelligence, and adversary emulation.
