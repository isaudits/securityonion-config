Security Onion + Elastic Configuration
===========

Additional tweaks and customizations for Elastic Stack implementation on Security
Onion

-------------------------------------------------------------------------------

Matthew C. Jones, CPA, CISA, OSCP, CCFE

IS Audits and Consulting, LLC - <http://www.isaudits.com/>

TJS Deemer Dana - <http://www.tjsdd.com>

-------------------------------------------------------------------------------

This is a work in process for a customized and extended version of the Elastic
Stack implementation on Security Onion. This may or may not work in your enviroment
and we do not intend to provide support for this project other than providing it
to the public for reference.

Modifications include:
- Fortigate firewalls do not work out of the box with Security Onion due to not
using a standard syslog format
    - Implementation of a custom syslog listener for Fortigate firewalls on port 5001
    - Corrected parsing of Fortigate syslogs

A setup script is included which symlinks our custom config files into the appropriate
directories. THIS SCRIPT WILL DELETE EXISTING CUSTOM CONFIG FILES IN THESE LOCATIONS!!!

Alternatively, you can manually copy or link these files into the appropriate directories:
- Logstash: /etc/logstash/custom/
- Syslog-ng: /etc/syslog-ng/conf.d/

If you elect to go the manual route, you'll need to include the custom syslog-ng files
by adding the following line to the bottom of /etc/syslog-ng/syslog-ng.conf:
'''@include "/etc/syslog-ng/conf.d/*.conf"'''
and also configure the firewall to allow inbound traffic for the custom listeners:
'''sudo ufw allow 5001'''

-------------------------------------------------------------------------------

This program is free software: you can redistribute it and/or modify it under 
the terms of the GNU General Public License as published by the Free Software 
Foundation, either version 3 of the License, or (at your option) any later 
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with 
this program. If not, see <http://www.gnu.org/licenses/>.