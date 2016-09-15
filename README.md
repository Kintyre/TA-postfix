TA_postfix
==========

This is a Splunk add-on for the Postfix mail server which aims to CIM
compliant, targeting the Email data model.



Customizations
--------------

Here are a few frequent customizations that can be applied to this app based
on your specific environment and preferences.


### Short status_code vs DSN ###

If you would prefer to see the short (3-digit) status_code instead of the
Enhanced Mail System Status Codes or DSN (Delivery Status Notification),
simply swap out the FIELDALIAS as show below:

Replace:

    FIELDALIAS-status_code = dsn as status_code

With:

    FIELDALIAS-status_code = status_code_short as status_code


### Preferred value for 'src' and 'dest' ###

By default this app sticks with the traditional use of 'src' and 'dest' by
returning either a fqdn or ip address.  However, it may be preferable to
change the order of preference or concatenate both values into one.

Please note that the use of "unknown" below is NOT because CIM datamodels
replace null or missing values with the string "unknown".  The "unknown"
referenced here is for the literal string "unknown" present in the actual 
raw log events.

Settings:

    EVAL-src = coalesce(src, nullif(src_host, "unknown"), src_ip)
    EVAL-dest = coalesce(dest, nullif(dest_host, "unknown"), dest_ip)

Alternate 1:  Use a combination of host and ip

    EVAL-src = if(isnull(src_host) or src_host=="unknown", src_ip, src_host . " (" . src_ip . ")")
    EVAL-dest = if(isnull(dest_host) or dest_host=="unknown", dest_ip, src_host . " (" . dest_ip . ")")

Alternate 2:  Prefer IP

(Because IP is almost always present, a simple field alias will be good enough.)

    FIELDALIAS-src = src_ip AS src
    FIELDALIAS-dest = dest_ip AS dest



Contributors
------------

 * Lowell Alleman <lowell@kintyre.co>
 * Romain Delmotte <romain.delmotte@experian.com>
 * Luke Harris via the "Splunk for Postfix" app (v1.1.1), 
   Field extractions borrowed. https://splunkbase.splunk.com/app/933/



Reference:
----------

* http://docs.splunk.com/Documentation/CIM/4.5.0/User/Email
