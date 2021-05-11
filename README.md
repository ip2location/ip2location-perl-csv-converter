# IP2Location Perl CSV Converter

This Perl script converts IP2Location CSV data file, that contains the IP address in numeric notation, into dot-decimal notation (such as x.x.x.x) or CIDR notation (x.x.x.x/24). It supports both the IP2Location commercial edition, DB1 to DB24 database and also the free edition, IP2Location LITE database. In addition to this, this converter can also be used to convert any CSV file that contains the IP number (the numeric notation).

You can download the IP2Location CSV file at the below links:  
[IP2Location Commercial Database](https://www.ip2location.com)   
[IP2Location LITE Database](https://lite.ip2location.com)  

Please do not use this script to convert IP2Location BIN data file. It only support the CSV format, not the binary format.

## Usage

``` bash
perl ip2location-csv-converter.pl [-range | -cidr | -hex] [-replace | -append] INPUT_FILE OUTPUT_FILE
```



#### Parameters

| Parameter | Description                                                  |
| --------- | ------------------------------------------------------------ |
| -range    | IP numbers will be converted into the first IP address and last IP address in the range. |
| -cidr     | IP numbers will be converted into CIDR format.               |
| -hex      | IP numbers will be converted into hexadecimal format.               |
| -replace  | The IP numbers in will be replaced to the selected format. |
| -append   | The converted format will be appended after the IP numbers field. |



### Example:

##### Sample Input

```
"17170432","17301503","IN","India"
"17301504","17367039","CN","China"
"17367040","17432575","MY","Malaysia"
"17432576","17435135","CN","China"
"17435136","17435391","AU","Australia"
"17435392","17465343","CN","China"
"17465344","17498111","TH","Thailand"
"17498112","17563647","KR","Korea, Republic of"
"17563648","17825791","CN","China"
"17825792","17842175","KR","Korea, Republic of"
```



##### Convert into range with replace option:

Command:

``` bash
perl ip2location-csv-converter.pl -range -replace IP2LOCATION-DB1.CSV IP2LOCATION-DB1.NEW.CSV
```

Output:

```
"1.6.0.0","1.7.255.255","IN","India"
"1.8.0.0","1.8.255.255","CN","China"
"1.9.0.0","1.9.255.255","MY","Malaysia"
"1.10.0.0","1.10.9.255","CN","China"
"1.10.10.0","1.10.10.255","AU","Australia"
"1.10.11.0","1.10.127.255","CN","China"
"1.10.128.0","1.10.255.255","TH","Thailand"
"1.11.0.0","1.11.255.255","KR","Korea, Republic of"
"1.12.0.0","1.15.255.255","CN","China"
"1.16.0.0","1.16.63.255","KR","Korea, Republic of"
```



##### Convert into CIDR with replace option:

Command:

``` bash
perl ip2location-csv-converter.pl -cidr -replace IP2LOCATION-DB1.CSV IP2LOCATION-DB1.NEW.CSV
```

Output:

```
"1.6.0.0/15","IN","India"
"1.8.0.0/16","CN","China"
"1.9.0.0/16","MY","Malaysia"
"1.10.0.0/21","CN","China"
"1.10.8.0/23","CN","China"
"1.10.10.0/24","AU","Australia"
"1.10.11.0/24","CN","China"
"1.10.12.0/22","CN","China"
"1.10.16.0/20","CN","China"
"1.10.32.0/19","CN","China"
```



##### Convert into hexadecimal with replace option:

Command:

``` bash
perl ip2location-csv-converter.pl -hex -replace IP2LOCATION-DB1.CSV IP2LOCATION-DB1.NEW.CSV
```

Output:

```
"01060000","0107ffff","IN","India"
"01080000","0108ffff","CN","China"
"01090000","0109ffff","MY","Malaysia"
"010a0000","010a09ff","CN","China"
"010a0a00","010a0aff","AU","Australia"
"010a0b00","010a7fff","CN","China"
"010a8000","010affff","TH","Thailand"
"010b0000","010bffff","KR","Korea, Republic of"
"010c0000","010fffff","CN","China"
"01100000","01103fff","KR","Korea, Republic of"
```



##### Convert into range with append option:

Command:

``` bash
perl ip2location-csv-converter.pl -range -append IP2LOCATION-DB1.CSV IP2LOCATION-DB1.NEW.CSV
```

Output:

```
"17170432","17301503","1.6.0.0","1.7.255.255","IN","India"
"17301504","17367039","1.8.0.0","1.8.255.255","CN","China"
"17367040","17432575","1.9.0.0","1.9.255.255","MY","Malaysia"
"17432576","17435135","1.10.0.0","1.10.9.255","CN","China"
"17435136","17435391","1.10.10.0","1.10.10.255","AU","Australia"
"17435392","17465343","1.10.11.0","1.10.127.255","CN","China"
"17465344","17498111","1.10.128.0","1.10.255.255","TH","Thailand"
"17498112","17563647","1.11.0.0","1.11.255.255","KR","Korea, Republic of"
"17563648","17825791","1.12.0.0","1.15.255.255","CN","China"
"17825792","17842175","1.16.0.0","1.16.63.255","KR","Korea, Republic of"
```



##### Convert into CIDR with append option:

Command:

``` bash
perl ip2location-csv-converter.pl -cidr -append IP2LOCATION-DB1.CSV IP2LOCATION-DB1.NEW.CSV
```

Output:

```
"17170432","17301503","1.6.0.0/15","IN","India"
"17301504","17367039","1.8.0.0/16","CN","China"
"17367040","17432575","1.9.0.0/16","MY","Malaysia"
"17432576","17435135","1.10.0.0/21","CN","China"
"17432576","17435135","1.10.8.0/23","CN","China"
"17435136","17435391","1.10.10.0/24","AU","Australia"
"17435392","17465343","1.10.11.0/24","CN","China"
"17435392","17465343","1.10.12.0/22","CN","China"
"17435392","17465343","1.10.16.0/20","CN","China"
"17435392","17465343","1.10.32.0/19","CN","China"
"17435392","17465343","1.10.64.0/18","CN","China"
"17465344","17498111","1.10.128.0/17","TH","Thailand"
"17498112","17563647","1.11.0.0/16","KR","Korea, Republic of"
"17563648","17825791","1.12.0.0/14","CN","China"
"17825792","17842175","1.16.0.0/18","KR","Korea, Republic of"
```



##### Convert into hexadecimal with append option:

Command:

``` bash
perl ip2location-csv-converter.pl -hex -append IP2LOCATION-DB1.CSV IP2LOCATION-DB1.NEW.CSV
```

Output:

```
"17170432","17301503","01060000","0107ffff","IN","India"
"17301504","17367039","01080000","0108ffff","CN","China"
"17367040","17432575","01090000","0109ffff","MY","Malaysia"
"17432576","17435135","010a0000","010a09ff","CN","China"
"17435136","17435391","010a0a00","010a0aff","AU","Australia"
"17435392","17465343","010a0b00","010a7fff","CN","China"
"17465344","17498111","010a8000","010affff","TH","Thailand"
"17498112","17563647","010b0000","010bffff","KR","Korea, Republic of"
"17563648","17825791","010c0000","010fffff","CN","China"
"17825792","17842175","01100000","01103fff","KR","Korea, Republic of"
```



## Custom Input File

You can use this converter for a custom input file provided the input is in CSV format, with the first and second field contain the **ip from** and **ip to** information in numeric format.

## Support
URL: https://www.ip2location.com
